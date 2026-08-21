#!/bin/sh

set -eu

herdr_bin=${HERDR_BIN_PATH:-herdr}
tab_id=${HERDR_ACTIVE_TAB_ID:?HERDR_ACTIVE_TAB_ID is not set}
active_pane_id=${HERDR_ACTIVE_PANE_ID:?HERDR_ACTIVE_PANE_ID is not set}
active_cwd=${HERDR_ACTIVE_PANE_CWD:-$HOME}

state_root=${XDG_STATE_HOME:-"$HOME/.local/state"}/herdr/todo-panes
socket_key=$(printf '%s' "${HERDR_SOCKET_PATH:-default}" | cksum | awk '{print $1}')
tab_key=$(printf '%s' "$tab_id" | tr -c 'A-Za-z0-9_.-' '_')
state_key=${socket_key}_$tab_key
state_file=$state_root/$state_key
lock_dir=$state_file.lock

mkdir -p "$state_root"
if ! mkdir "$lock_dir" 2>/dev/null; then
  exit 0
fi
trap 'rmdir "$lock_dir" 2>/dev/null || true' EXIT HUP INT TERM

if [ -s "$state_file" ]; then
  todo_pane_id=$(sed -n '1p' "$state_file")
  pane_json=$("$herdr_bin" pane get "$todo_pane_id" 2>/dev/null || true)
  pane_tab_id=$(printf '%s' "$pane_json" | /usr/bin/jq -r '.result.pane.tab_id // empty' 2>/dev/null || true)

  if [ "$pane_tab_id" = "$tab_id" ]; then
    "$herdr_bin" pane close "$todo_pane_id"
    rm -f "$state_file"
    exit 0
  fi

  rm -f "$state_file"
fi

layout_json=$("$herdr_bin" pane layout --pane "$active_pane_id")
leftmost_pane_id=$(
  printf '%s' "$layout_json" | /usr/bin/jq -r \
    '.result.layout.panes | min_by(.rect.x) | .pane_id // empty'
)
split_ratio=$(
  printf '%s' "$layout_json" | /usr/bin/jq -r '
    .result.layout as $layout
    | ($layout.panes | min_by(.rect.x) | .rect.width) as $left_width
    | (($layout.area.width * 0.23) / $left_width) as $ratio
    | if $ratio > 0.80 then 0.80 elif $ratio < 0.20 then 0.20 else $ratio end
  '
)

if [ -z "$leftmost_pane_id" ] || [ -z "$split_ratio" ]; then
  exit 1
fi

split_json=$(
  "$herdr_bin" pane split \
    --pane "$leftmost_pane_id" \
    --direction right \
    --ratio "$split_ratio" \
    --cwd "$active_cwd" \
    --no-focus
)
todo_pane_id=$(printf '%s' "$split_json" | /usr/bin/jq -r '.result.pane.pane_id // empty')

if [ -z "$todo_pane_id" ]; then
  exit 1
fi

printf '%s\n' "$todo_pane_id" >"$state_file"
"$herdr_bin" pane rename "$todo_pane_id" TODO

if ! "$herdr_bin" pane run "$todo_pane_id" 'exec nvim "$HOME/Documents/Note/Kanban/work.md"'; then
  "$herdr_bin" pane close "$todo_pane_id" 2>/dev/null || true
  rm -f "$state_file"
  exit 1
fi

if ! "$herdr_bin" pane swap --source-pane "$leftmost_pane_id" --target-pane "$todo_pane_id"; then
  "$herdr_bin" pane close "$todo_pane_id" 2>/dev/null || true
  rm -f "$state_file"
  exit 1
fi

"$herdr_bin" pane focus --pane "$leftmost_pane_id" --direction left
