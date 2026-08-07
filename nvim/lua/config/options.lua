local opt = vim.opt

opt.encoding = "utf-8"
opt.number = true
opt.cursorline = true
opt.showmatch = true
opt.whichwrap = "b,s,h,l,<,>,[,],~"
opt.mouse = "a"
opt.termguicolors = true
opt.background = "dark"

opt.autoread = true

opt.expandtab = true
opt.tabstop = 2
opt.softtabstop = 2
opt.autoindent = true
opt.smartindent = true
opt.shiftwidth = 2

opt.clipboard = "unnamed"

opt.incsearch = true
opt.ignorecase = true
opt.smartcase = true
opt.hlsearch = true
opt.wildmenu = true
opt.history = 5000

opt.swapfile = false
opt.backup = false

opt.foldcolumn = "1"
opt.foldlevel = 99
opt.foldlevelstart = 99
opt.foldenable = true

opt.showtabline = 2
opt.undolevels = 1000
opt.timeoutlen = 500
opt.updatetime = 250

if vim.fn.has("persistent_undo") == 1 then
  local undo_dir = vim.fn.expand("~/.vim/undo")
  vim.fn.mkdir(undo_dir, "p")
  opt.undodir = undo_dir
  opt.undofile = true
else
  opt.undofile = false
end
