return {
  {
    "EdenEast/nightfox.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      vim.cmd.colorscheme("nightfox")
    end,
  },
  {
    "nvim-tree/nvim-web-devicons",
    lazy = true,
  },
  {
    "nvim-tree/nvim-tree.lua",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    cmd = { "NvimTreeOpen", "NvimTreeToggle", "NvimTreeFindFile" },
    keys = {
      {
        "<C-e>",
        function()
          require("nvim-tree.api").tree.toggle({ find_file = true, focus = true })
        end,
        desc = "Toggle file tree",
      },
    },
    opts = {
      sync_root_with_cwd = true,
      respect_buf_cwd = true,
      renderer = {
        group_empty = true,
      },
      filters = {
        dotfiles = false,
      },
    },
    config = function(_, opts)
      require("nvim-tree").setup(opts)
      vim.api.nvim_create_autocmd("QuitPre", {
        group = vim.api.nvim_create_augroup("dotfiles_nvim_tree_quit", { clear = true }),
        callback = function()
          local tree = require("nvim-tree.api").tree
          if tree.is_visible() and #vim.api.nvim_list_wins() == 2 then
            tree.close()
          end
        end,
      })
    end,
  },
  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = {
      options = {
        theme = "nightfox",
        globalstatus = true,
      },
    },
  },
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {},
  },
  {
    "ibhagwan/fzf-lua",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    cmd = "FzfLua",
    keys = {
      {
        "<Leader>g",
        function()
          require("fzf-lua").live_grep({
            rg_opts = "--column --line-number --no-heading --color=always --smart-case --hidden --glob '!.git/*'",
          })
        end,
        desc = "Search project text",
      },
      {
        "<Leader>p",
        function()
          require("fzf-lua").git_files()
        end,
        desc = "Find Git files",
      },
    },
    opts = {
      winopts = {
        height = 0.5,
        width = 1,
        row = 1,
      },
    },
  },
  {
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPre", "BufNewFile" },
    keys = {
      {
        "[h",
        function()
          if vim.wo.diff then
            vim.cmd.normal({ "[c", bang = true })
          else
            require("gitsigns").nav_hunk("prev")
          end
        end,
        desc = "Previous Git hunk",
      },
      {
        "]h",
        function()
          if vim.wo.diff then
            vim.cmd.normal({ "]c", bang = true })
          else
            require("gitsigns").nav_hunk("next")
          end
        end,
        desc = "Next Git hunk",
      },
      {
        "<Leader>hh",
        function()
          require("gitsigns").toggle_linehl()
        end,
        desc = "Toggle Git line highlights",
      },
      {
        "<Leader>hb",
        function()
          require("gitsigns").toggle_current_line_blame()
        end,
        desc = "Toggle Git line blame",
      },
    },
    opts = {
      current_line_blame = false,
    },
  },
  {
    "folke/flash.nvim",
    event = "VeryLazy",
    opts = {},
    keys = {
      {
        "<Leader>f",
        mode = { "n", "x", "o" },
        function()
          require("flash").jump()
        end,
        desc = "Jump with Flash",
      },
      {
        "<Leader>s",
        mode = { "n", "x", "o" },
        function()
          require("flash").jump({ search = { mode = "search" } })
        end,
        desc = "Search and jump with Flash",
      },
      {
        "<Leader>l",
        mode = { "n", "x", "o" },
        function()
          require("flash").jump({
            search = { mode = "search", max_length = 0 },
            label = { after = { 0, 0 } },
            pattern = "^",
          })
        end,
        desc = "Jump to line",
      },
      {
        "<Leader>w",
        mode = { "n", "x", "o" },
        function()
          require("flash").jump({
            pattern = ".",
            search = {
              mode = function(pattern)
                return "\\<" .. pattern:sub(2)
              end,
            },
          })
        end,
        desc = "Jump to word",
      },
    },
  },
  {
    "mrjones2014/smart-splits.nvim",
    lazy = false,
    keys = {
      {
        "<C-h>",
        function()
          require("smart-splits").move_cursor_left()
        end,
        desc = "Move left",
      },
      {
        "<C-j>",
        function()
          require("smart-splits").move_cursor_down()
        end,
        desc = "Move down",
      },
      {
        "<C-k>",
        function()
          require("smart-splits").move_cursor_up()
        end,
        desc = "Move up",
      },
      {
        "<C-l>",
        function()
          require("smart-splits").move_cursor_right()
        end,
        desc = "Move right",
      },
      {
        "<A-h>",
        function()
          require("smart-splits").resize_left()
        end,
        desc = "Resize left",
      },
      {
        "<A-j>",
        function()
          require("smart-splits").resize_down()
        end,
        desc = "Resize down",
      },
      {
        "<A-k>",
        function()
          require("smart-splits").resize_up()
        end,
        desc = "Resize up",
      },
      {
        "<A-l>",
        function()
          require("smart-splits").resize_right()
        end,
        desc = "Resize right",
      },
    },
    opts = {},
  },
}
