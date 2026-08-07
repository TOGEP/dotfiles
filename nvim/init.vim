" encode setting
set encoding=utf-8

" display
set number
set cursorline
set showmatch
set whichwrap=b,s,h,l,<,>,[,],~
set mouse=a
set termguicolors
set background=dark
syntax on

" Auto-reload files changed outside current Neovim instance
set autoread
augroup TodoAutoReload
  autocmd!
  autocmd FocusGained,BufEnter,CursorHold,CursorHoldI * if mode() !=# "c" | checktime | endif
augroup END

" Tab/Indent
set expandtab
set tabstop=2
set softtabstop=2 
set autoindent
set smartindent
set shiftwidth=2

" clipboard
set clipboard=unnamed
" wsl yank setting
if has("wsl")
   augroup Yank
        autocmd!
        autocmd TextYankPost * :call system('clip.exe ',@")
    augroup END
endif

" search
set incsearch
set ignorecase
set smartcase
set hlsearch

" complement
set wildmenu
set history=5000

" noswapfile
set noswapfile
set nobackup
set noundofile

" fold
set foldcolumn=1
set foldlevel=99
set foldlevelstart=99
set foldenable
augroup markdown_folding
  autocmd!
  autocmd FileType markdown setlocal foldmethod=indent
augroup END

" keymap
let mapleader = "\<Space>"
nnoremap <silent> <Esc><Esc> :nohlsearch<CR>
noremap H ^
noremap L g_
" US keyboad
nnoremap ; :
nnoremap : ;
vnoremap : :
vnoremap : ;

" tabline
set showtabline=2

" undo
set undolevels=1000
if has('persistent_undo')
  let undo_path = expand('~/.vim/undo')
  if !isdirectory(undo_path)
    call mkdir(undo_path, 'p')
  endif
  set undofile
endif

" open&source vimrc
nnoremap <Leader>. :new $MYVIMRC<CR>
nnoremap <Leader>, :source $MYVIMRC<CR>

" vim-plug
call plug#begin(stdpath('data') . '/plugged')

" lsp
" masonは遅延読み込みが非推奨となっているのでプラグイン読み込みはinitファイル上で書くように
" > mason.nvim is optimized to load as little as possible during setup. Lazy-loading the plugin, or somehow deferring the setup, is not recommended.
Plug 'mason-org/mason.nvim'
Plug 'mason-org/mason-lspconfig.nvim'
Plug 'neovim/nvim-lspconfig'
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-path'
Plug 'hrsh7th/cmp-cmdline'
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-tree/nvim-web-devicons'
Plug 'ibhagwan/fzf-lua'
Plug 'pwntester/octo.nvim'
Plug 'petertriho/cmp-git'
Plug 'hrsh7th/nvim-cmp'
" For vsnip users.
Plug 'hrsh7th/cmp-vsnip'
Plug 'hrsh7th/vim-vsnip'
" TODO change from vsnip to luasnip.
" Plug 'L3MON4D3/LuaSnip'
" Plug 'saadparwaiz1/cmp_luasnip'
" For 'copilot.vim' users.
Plug 'hrsh7th/cmp-copilot'

Plug 'obsidian-nvim/obsidian.nvim'

Plug 'kevinhwang91/promise-async'
Plug 'kevinhwang91/nvim-ufo'

lua << EOF
-- lsp settings
-- lspの設定に関しては遅延読み込みしても良い
-- Global mappings.
-- See `:help vim.diagnostic.*` for documentation on any of the below functions
vim.keymap.set('n', '<space>e', vim.diagnostic.open_float)
vim.keymap.set('n', '[d', function() vim.diagnostic.jump({ count = -1 }) end)
vim.keymap.set('n', ']d', function() vim.diagnostic.jump({ count = 1 }) end)
vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist)

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(client, bufnr)
-- Enable completion triggered by <c-x><c-o>
vim.bo[bufnr].omnifunc = 'v:lua.vim.lsp.omnifunc'

-- Mappings.
-- See `:help vim.lsp.*` for documentation on any of the below functions
local bufopts = { noremap=true, silent=true, buffer=bufnr }
-- vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
vim.keymap.set('n', 'gd', vim.lsp.buf.definition, bufopts)
vim.keymap.set('n', 'K', vim.lsp.buf.hover, bufopts)
vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, bufopts)
-- vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, bufopts)
vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, bufopts)
vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, bufopts)
vim.keymap.set('n', '<space>wl', function() print(vim.inspect(vim.lsp.buf.list_workspace_folders())) end, bufopts)
vim.keymap.set('n', 'gy', vim.lsp.buf.type_definition, bufopts)
vim.keymap.set('n', 'rn', vim.lsp.buf.rename, bufopts)
vim.keymap.set('n', '<space>ca', vim.lsp.buf.code_action, bufopts)
vim.keymap.set('n', 'gr', vim.lsp.buf.references, bufopts)
vim.keymap.set('n', '<space>f', function() vim.lsp.buf.format { async = true } end, bufopts)
end
EOF

" colorscheme
Plug 'jonathanfilip/vim-lucius'
Plug 'ghifarit53/tokyonight-vim'
Plug 'EdenEast/nightfox.nvim'

Plug 'preservim/nerdtree'
Plug 'jistr/vim-nerdtree-tabs'
map <C-e> :NERDTreeTabsToggle<CR>
" ファイル指定せずにvimを開いた時にNERDTreeを最初から表示
" autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | NERDTree | endif
" NERDTreeToggleのウィンドウだけが残る場合はvimを終了
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif
" 隠しファイル表示
let NERDTreeShowHidden = 1

Plug 'ryanoasis/vim-devicons'

Plug 'itchyny/lightline.vim'

Plug 'w0rp/ale'

Plug 'vim-jp/vimdoc-ja'

Plug 'mattn/vim-goimports'

" Plug 'airblade/vim-rooter'

Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
let g:fzf_layout = { 'down': '50%' }
command! -bang -nargs=* Rg
  \ call fzf#vim#grep(
  \ 'rg --column --line-number --no-heading --hidden --smart-case --glob "!\.git/*" -- '.shellescape(<q-args>),
  \ 1,
  \ fzf#vim#with_preview({'dir': system('git rev-parse --show-toplevel 2> /dev/null')[:-2]}),
  \ <bang>0)
nnoremap <silent> <Leader>g :Rg<CR>
nnoremap <Leader>p :GFiles<CR>

Plug 'easymotion/vim-easymotion'
" Disable default mappings
let g:EasyMotion_do_mapping = 0
" Turn on case insensitive feature
let g:EasyMotion_smartcase = 1
" <Leader>f{char} to move to {char}
map <Leader>f <Plug>(easymotion-bd-f)
nmap <Leader>f <Plug>(easymotion-overwin-f)
" <Leader>s{char}{char} to move to {char}{char}
nmap <Leader>s <Plug>(easymotion-overwin-f2)
vmap <Leader>s <Plug>(easymotion-bd-f2)
" Move to line
map <Leader>l <Plug>(easymotion-bd-jk)
nmap <Leader>l <Plug>(easymotion-overwin-line)
" Move to word
map  <Leader>w <Plug>(easymotion-bd-w)
nmap <Leader>w <Plug>(easymotion-overwin-w)

Plug 'airblade/vim-gitgutter'
set updatetime=250
" Move to Hunk
nmap [h <Plug>(GitGutterPrevHunk)
nmap ]h <Plug>(GitGutterNextHunk)
" Highlight Toggle
nnoremap <Leader>hh :GitGutterLineHighlightsToggle<CR>
" default gitgutter maps
" nmap <Leader>hs <Plug>GitGutterStageHunk
" nmap <Leader>hr <Plug>GitGutterRevertHunk
" nmap <Leader>hp <Plug>GitGutterPreviewHunk

Plug 'APZelos/blamer.nvim'

" not pre build build bundle for ARM platform.(2021/4/26)
" Plug 'iamcco/markdown-preview.nvim', { 'do': { -> mkdp#util#install() }, 'for': ['markdown', 'vim-plug']}
Plug 'iamcco/markdown-preview.nvim', { 'do': 'cd app && yarn install'  }

Plug 'mattn/vim-maketable'

Plug 'jiangmiao/auto-pairs'

Plug 'mbbill/undotree'
nnoremap <F5> :UndotreeToggle<CR>

Plug 'lervag/vimtex'

Plug 'simeji/winresizer'
let g:winresizer_vert_resize = 1
let g:winresizer_horiz_resize = 1

Plug 'thinca/vim-quickrun', {'on': 'QuickRun'}
Plug 'Shougo/vimproc.vim', {'do' : 'make'}
let g:quickrun_config = {
  \'_' : {
    \ 'outputter/error/success': 'buffer',
    \ 'outputter/error/error': 'quickfix',
    \ 'outputter/quickfix/open_cmd': 'copen',
    \ 'runner' : "vimproc",
    \ 'runner/vimproc/updatetime' : 60,
    \ 'hook/time/enable': 1
  \ },
\}

" 小文字rと大文字RでQuickRunの挙動を分岐
" 小文字rの場合:カレントディレクトリにinputファイルがあれば中身を標準入力として引き渡して実行，それ以外は標準入力無しで実行
" 大文字Rの場合:クリップボードの中身を標準入力として引き渡して実行
nnoremap <Leader>r :call <SID>DoQuickRun()<CR>
nnoremap <Leader>R :QuickRun -input =@+<CR>
function! s:DoQuickRun() abort
  if filereadable('input')
    execute ':QuickRun <input'
  else
    execute ':QuickRun'
  endif
endfunction

Plug 'liuchengxu/vim-which-key'
nnoremap <silent> <Leader> :<c-u>WhichKey '<Space>'<CR>
vnoremap <silent> <Leader> :<c-u>WhichKeyVisual '<Space>'<CR>
" By default timeoutlen is 1000 ms
set timeoutlen=500

Plug 'sebdah/vim-delve'
autocmd fileType go nnoremap <silent> gb :<c-u>DlvDebug<CR>
autocmd fileType go command! BP :DlvToggleBreakpoint
autocmd fileType go command! BPC :DlvClearAll

Plug 'github/copilot.vim'
let g:copilot_no_tab_map = v:true
let g:copilot_assume_mapped = v:true
imap <silent><script><expr> <C-J> copilot#Accept("\<CR>")

Plug 'google/vim-jsonnet'

" 安定板が出たら使うかも
" Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}

call plug#end()

" lsp setup
lua << EOF
require("mason").setup()
require("mason-lspconfig").setup({
  ensure_installed = {
    "gopls",
    "terraformls",
    "rust_analyzer",
    "marksman",
    "ltex",
  },
  automatic_enable = true,
})
EOF

" ufo setup
lua << EOF
require('ufo').setup({
  provider_selector = function(bufnr, filetype, buftype)
    if filetype == "markdown" then
      return { "indent" }
    end
    return { "lsp", "indent" }
  end,
})

vim.keymap.set('n', 'zR', function()
  require('ufo').openAllFolds()
end)

vim.keymap.set('n', 'zM', function()
  require('ufo').closeAllFolds()
end)
EOF

" Setup language servers.
lua << EOF
vim.lsp.config('gopls', {})
vim.lsp.enable('gopls')
vim.lsp.config('terraformls', {})
vim.lsp.enable('terraformls')
vim.lsp.config('rust_analyzer', {
  settings = {
    ['rust-analyzer'] = {},
  },
})
vim.lsp.enable('rust_analyzer')

vim.lsp.config('marksman', {})
vim.lsp.enable('marksman')

vim.lsp.config('ltex', {
  filetypes = { 'markdown', 'text', 'gitcommit' },
  settings = {
    ltex = {
      language = 'ja-JP',
    },
  },
})
vim.lsp.enable('ltex')
EOF

" setup obsidian nvim.
lua << EOF
require("obsidian").setup({
  legacy_commands = false,
  workspaces = {
    {
      name = "Note",
      path = "~/Documents/Note",
    },
  },

  completion = {
    min_chars = 2,
  },

  daily_notes = {
    folder = "dailies",
    date_format = "%Y-%m-%d",
  },

  ui = {
    enable = false,
  },
})
EOF

" setup octo.nvim
lua << EOF
local ok, octo = pcall(require, "octo")
if ok then
  local picker = "default"
  if pcall(require, "fzf-lua") then
    picker = "fzf-lua"
  end

  octo.setup({
    picker = picker,
    enable_builtin = true,
    default_to_projects_v2 = false,
    suppress_missing_scope = {
      projects_v2 = true,
    },
  })

  local function github_url_under_cursor()
    local line = vim.api.nvim_get_current_line()
    local col = vim.api.nvim_win_get_cursor(0)[2] + 1

    local function pick_url(pattern, start_at)
      local from = start_at or 1
      while true do
        local s, e, url = line:find(pattern, from)
        if not s then
          return nil
        end
        local match = line:sub(s, e)
        local rs, re = match:find("(https?://[^%s]+)")
        if rs and re then
          local us = s + rs - 1
          local ue = s + re - 1
          if col >= us and col <= ue then
            return url:gsub("[),%.:;!?]+$", "")
          end
        end
        from = e + 1
      end
    end

    local url = pick_url("%b[]%((https?://[^)%s]+)%)")
      or pick_url("<(https?://[^>%s]+)>")
      or pick_url("(https?://[%w%-%._~:/%?#%[%]@!$&'*+,;=%%]+)")

    if url and url:match("^https?://github%.com/") then
      return url
    end

    local cfile = vim.fn.expand("<cfile>")
    if cfile and cfile:match("^https?://github%.com/") then
      return cfile
    end
    return nil
  end

  local function octo_open_url_under_cursor()
    local url = github_url_under_cursor()
    if not url then
      vim.notify("カーソル位置のGitHub URLを解決できませんでした", vim.log.levels.WARN)
      return
    end

    local before = {}
    for _, b in ipairs(vim.api.nvim_list_bufs()) do
      before[b] = true
    end

    local columns = vim.o.columns
    local lines = vim.o.lines - vim.o.cmdheight
    local width = math.floor(columns * 0.86)
    local height = math.floor(lines * 0.82)
    local col = math.floor((columns - width) / 2)
    local row = math.floor((lines - height) / 2)
    if row < 0 then
      row = 0
    end

    local float_buf = vim.api.nvim_create_buf(false, true)
    local float_win = vim.api.nvim_open_win(float_buf, true, {
      relative = "editor",
      width = width,
      height = height,
      col = col,
      row = row,
      border = "rounded",
    })
    vim.wo[float_win].winhighlight = "NormalFloat:Normal,FloatBorder:FloatBorder"

    local ok_cmd, err = pcall(vim.api.nvim_cmd, { cmd = "Octo", args = { url } }, {})
    if not ok_cmd then
      vim.notify("Octo 実行エラー: " .. tostring(err), vim.log.levels.ERROR)
      if vim.api.nvim_win_is_valid(float_win) then
        pcall(vim.api.nvim_win_close, float_win, true)
      end
      return
    end

    vim.schedule(function()
      if not vim.api.nvim_win_is_valid(float_win) then
        return
      end

      local current_buf = vim.api.nvim_win_get_buf(float_win)
      local current_ft = vim.bo[current_buf].filetype or ""
      if current_ft == "octo" then
        return
      end

      local candidate_buf = nil
      for _, b in ipairs(vim.api.nvim_list_bufs()) do
        if (not before[b]) and vim.api.nvim_buf_is_valid(b) then
          local ft = vim.bo[b].filetype or ""
          local name = vim.api.nvim_buf_get_name(b)
          if ft == "octo" or name:match("octo") then
            candidate_buf = b
            break
          end
        end
      end

      if candidate_buf then
        vim.api.nvim_win_set_buf(float_win, candidate_buf)
        for _, w in ipairs(vim.api.nvim_list_wins()) do
          if w ~= float_win and vim.api.nvim_win_is_valid(w) and vim.api.nvim_win_get_buf(w) == candidate_buf then
            local cfg = vim.api.nvim_win_get_config(w)
            if cfg.relative == "" then
              pcall(vim.api.nvim_win_close, w, true)
            end
          end
        end
      else
        vim.notify("Octoバッファをfloating windowに関連付けできませんでした", vim.log.levels.WARN)
      end
    end)
  end

  vim.keymap.set('n', '<Leader>go', '<Cmd>Octo<CR>', { noremap = true, silent = true })
  vim.keymap.set('n', '<Leader>gi', '<Cmd>Octo issue list<CR>', { noremap = true, silent = true })
  vim.keymap.set('n', '<Leader>gp', '<Cmd>Octo pr list<CR>', { noremap = true, silent = true })
  vim.keymap.set('n', '<Leader>ou', octo_open_url_under_cursor, { noremap = true, silent = true })
end
EOF

" Set up nvim-cmp.
lua << EOF
  local cmp = require'cmp'

  cmp.setup({
    snippet = {
      -- REQUIRED - you must specify a snippet engine
      expand = function(args)
        vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` users.
        -- require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
      end,
    },
    window = {
      -- completion = cmp.config.window.bordered(),
      -- documentation = cmp.config.window.bordered(),
    },
    mapping = cmp.mapping.preset.insert({
      ['<C-b>'] = cmp.mapping.scroll_docs(-4),
      ['<C-f>'] = cmp.mapping.scroll_docs(4),
      ['<C-Space>'] = cmp.mapping.complete(),
      ['<C-e>'] = cmp.mapping.abort(),
      ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
    }),
    sources = cmp.config.sources({
      { name = 'copilot' },
      { name = 'nvim_lsp' },
      { name = 'vsnip' }, -- For vsnip users.
      -- { name = 'luasnip' }, -- For luasnip users.
    }, {
      { name = 'buffer' },
    })
  })

  -- Set configuration for specific filetype.
  cmp.setup.filetype('gitcommit', {
    sources = cmp.config.sources({
      { name = 'cmp_git' }, -- You can specify the `cmp_git` source if you were installed it.
    }, {
      { name = 'buffer' },
    })
  })

  -- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
  cmp.setup.cmdline({ '/', '?' }, {
    mapping = cmp.mapping.preset.cmdline(),
    sources = {
      { name = 'buffer' }
    }
  })

  -- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
  cmp.setup.cmdline(':', {
    mapping = cmp.mapping.preset.cmdline(),
    sources = cmp.config.sources({
      { name = 'path' }
    }, {
      { name = 'cmdline' }
    })
  })

  -- Set up lspconfig.
  local capabilities = require('cmp_nvim_lsp').default_capabilities()
  -- Replace <YOUR_LSP_SERVER> with each lsp server you've enabled.
  -- require('lspconfig')['<YOUR_LSP_SERVER>'].setup {
  --   capabilities = capabilities
  -- }
EOF

colorscheme nightfox
