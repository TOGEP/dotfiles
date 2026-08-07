local M = {}

local function github_url_under_cursor()
  local line = vim.api.nvim_get_current_line()
  local cursor_column = vim.api.nvim_win_get_cursor(0)[2] + 1

  local function pick_url(pattern)
    local start_at = 1
    while true do
      local start_pos, end_pos, url = line:find(pattern, start_at)
      if not start_pos then
        return nil
      end

      local matched = line:sub(start_pos, end_pos)
      local relative_start, relative_end = matched:find("(https?://[^%s]+)")
      if relative_start and relative_end then
        local url_start = start_pos + relative_start - 1
        local url_end = start_pos + relative_end - 1
        if cursor_column >= url_start and cursor_column <= url_end then
          return url:gsub("[),%.:;!?]+$", "")
        end
      end
      start_at = end_pos + 1
    end
  end

  local url = pick_url("%b[]%((https?://[^)%s]+)%)")
    or pick_url("<(https?://[^>%s]+)>")
    or pick_url("(https?://[%w%-%._~:/%?#%[%]@!$&'*+,;=%%]+)")

  if url and url:match("^https?://github%.com/") then
    return url
  end

  local cfile = vim.fn.expand("<cfile>")
  if cfile:match("^https?://github%.com/") then
    return cfile
  end
end

function M.open_url_under_cursor()
  local url = github_url_under_cursor()
  if not url then
    vim.notify("カーソル位置のGitHub URLを解決できませんでした", vim.log.levels.WARN)
    return
  end

  local existing_buffers = {}
  for _, buffer in ipairs(vim.api.nvim_list_bufs()) do
    existing_buffers[buffer] = true
  end

  local columns = vim.o.columns
  local lines = vim.o.lines - vim.o.cmdheight
  local width = math.max(1, math.floor(columns * 0.86))
  local height = math.max(1, math.floor(lines * 0.82))
  local column = math.max(0, math.floor((columns - width) / 2))
  local row = math.max(0, math.floor((lines - height) / 2))

  local float_buffer = vim.api.nvim_create_buf(false, true)
  local float_window = vim.api.nvim_open_win(float_buffer, true, {
    relative = "editor",
    width = width,
    height = height,
    col = column,
    row = row,
    border = "rounded",
  })
  vim.wo[float_window].winhighlight = "NormalFloat:Normal,FloatBorder:FloatBorder"

  local ok, err = pcall(vim.api.nvim_cmd, { cmd = "Octo", args = { url } }, {})
  if not ok then
    vim.notify("Octo 実行エラー: " .. tostring(err), vim.log.levels.ERROR)
    pcall(vim.api.nvim_win_close, float_window, true)
    return
  end

  vim.schedule(function()
    if not vim.api.nvim_win_is_valid(float_window) then
      return
    end

    local current_buffer = vim.api.nvim_win_get_buf(float_window)
    if vim.bo[current_buffer].filetype == "octo" then
      return
    end

    local candidate
    for _, buffer in ipairs(vim.api.nvim_list_bufs()) do
      if not existing_buffers[buffer] and vim.api.nvim_buf_is_valid(buffer) then
        local filetype = vim.bo[buffer].filetype or ""
        local name = vim.api.nvim_buf_get_name(buffer)
        if filetype == "octo" or name:match("octo") then
          candidate = buffer
          break
        end
      end
    end

    if not candidate then
      vim.notify("Octoバッファをfloating windowに関連付けできませんでした", vim.log.levels.WARN)
      return
    end

    vim.api.nvim_win_set_buf(float_window, candidate)
    for _, window in ipairs(vim.api.nvim_list_wins()) do
      if
        window ~= float_window
        and vim.api.nvim_win_is_valid(window)
        and vim.api.nvim_win_get_buf(window) == candidate
      then
        if vim.api.nvim_win_get_config(window).relative == "" then
          pcall(vim.api.nvim_win_close, window, true)
        end
      end
    end
  end)
end

return M
