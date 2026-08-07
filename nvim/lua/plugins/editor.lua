return {
  {
    "kevinhwang91/nvim-ufo",
    event = { "BufReadPost", "BufNewFile" },
    dependencies = { "kevinhwang91/promise-async" },
    keys = {
      {
        "zR",
        function()
          require("ufo").openAllFolds()
        end,
        desc = "Open all folds",
      },
      {
        "zM",
        function()
          require("ufo").closeAllFolds()
        end,
        desc = "Close all folds",
      },
    },
    opts = {
      provider_selector = function(_, filetype)
        if filetype == "markdown" then
          return { "indent" }
        end
        return { "lsp", "indent" }
      end,
    },
  },
  {
    "obsidian-nvim/obsidian.nvim",
    ft = "markdown",
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = {
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
    },
  },
  {
    "pwntester/octo.nvim",
    cmd = "Octo",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons",
      "ibhagwan/fzf-lua",
    },
    keys = {
      { "<Leader>go", "<Cmd>Octo<CR>", desc = "Open Octo" },
      { "<Leader>gi", "<Cmd>Octo issue list<CR>", desc = "List GitHub issues" },
      { "<Leader>gp", "<Cmd>Octo pr list<CR>", desc = "List GitHub pull requests" },
      {
        "<Leader>ou",
        function()
          require("config.octo").open_url_under_cursor()
        end,
        desc = "Open GitHub URL with Octo",
      },
    },
    opts = {
      picker = "fzf-lua",
      enable_builtin = true,
      default_to_projects_v2 = false,
      suppress_missing_scope = {
        projects_v2 = true,
      },
    },
  },
  {
    "mfussenegger/nvim-dap",
    ft = "go",
    dependencies = { "leoluz/nvim-dap-go" },
    keys = {
      {
        "gb",
        function()
          require("dap").continue()
        end,
        desc = "Start or continue Go debugging",
      },
    },
    config = function()
      local dap = require("dap")
      require("dap-go").setup()
      vim.api.nvim_create_user_command("BP", dap.toggle_breakpoint, { desc = "Toggle DAP breakpoint" })
      vim.api.nvim_create_user_command("BPC", dap.clear_breakpoints, { desc = "Clear DAP breakpoints" })
    end,
  },
  {
    "iamcco/markdown-preview.nvim",
    ft = "markdown",
    cmd = { "MarkdownPreview", "MarkdownPreviewStop", "MarkdownPreviewToggle" },
    build = "cd app && yarn install",
  },
  {
    "mattn/vim-maketable",
    ft = "markdown",
  },
  {
    "mbbill/undotree",
    cmd = "UndotreeToggle",
    keys = {
      { "<F5>", "<Cmd>UndotreeToggle<CR>", desc = "Toggle undo tree" },
    },
  },
  {
    "lervag/vimtex",
    ft = { "tex", "plaintex" },
  },
  {
    "google/vim-jsonnet",
    ft = "jsonnet",
  },
  {
    "vim-jp/vimdoc-ja",
    event = "VeryLazy",
    build = function(plugin)
      -- Neovim 0.12 regenerates doc/tags-ja without its tracked encoding header.
      -- Ignore only that generated change so lazy.nvim can still update the plugin.
      vim.system({ "git", "-C", plugin.dir, "update-index", "--assume-unchanged", "doc/tags-ja" }):wait()
    end,
  },
}
