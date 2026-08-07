local map = vim.keymap.set

map("n", "<Esc><Esc>", "<Cmd>nohlsearch<CR>", { silent = true, desc = "Clear search highlight" })
map({ "n", "x", "o" }, "H", "^", { desc = "First non-blank character" })
map({ "n", "x", "o" }, "L", "g_", { desc = "Last non-blank character" })

-- Swap ':' and ';' for a US keyboard layout.
map("n", ";", ":", { noremap = true })
map("n", ":", ";", { noremap = true })
map("x", ";", ":", { noremap = true })
map("x", ":", ";", { noremap = true })

map("n", "<Leader>.", function()
  vim.cmd("new " .. vim.fn.fnameescape(vim.env.MYVIMRC))
end, { desc = "Open Neovim config" })

map("n", "<Leader>,", function()
  vim.cmd.source(vim.env.MYVIMRC)
  vim.notify("Neovim config reloaded")
end, { desc = "Reload Neovim config" })

map("n", "<Space>e", vim.diagnostic.open_float, { desc = "Open diagnostic float" })
map("n", "[d", function()
  vim.diagnostic.jump({ count = -1 })
end, { desc = "Previous diagnostic" })
map("n", "]d", function()
  vim.diagnostic.jump({ count = 1 })
end, { desc = "Next diagnostic" })
map("n", "<Space>q", vim.diagnostic.setloclist, { desc = "Diagnostic location list" })
