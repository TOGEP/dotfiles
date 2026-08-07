local function augroup(name)
  return vim.api.nvim_create_augroup("dotfiles_" .. name, { clear = true })
end

vim.filetype.add({
  extension = {
    gotmpl = "gotmpl",
    libsonnet = "libsonnet",
    mdx = "markdown.mdx",
  },
})

vim.api.nvim_create_autocmd({ "FocusGained", "BufEnter", "CursorHold", "CursorHoldI" }, {
  group = augroup("auto_reload"),
  callback = function()
    if vim.fn.mode() ~= "c" then
      vim.cmd("checktime")
    end
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  group = augroup("markdown_folding"),
  pattern = "markdown",
  callback = function()
    vim.opt_local.foldmethod = "indent"
  end,
})

if vim.fn.has("wsl") == 1 then
  vim.api.nvim_create_autocmd("TextYankPost", {
    group = augroup("wsl_yank"),
    callback = function()
      if vim.v.event.operator == "y" then
        vim.fn.system("clip.exe", vim.v.event.regcontents)
      end
    end,
  })
end
