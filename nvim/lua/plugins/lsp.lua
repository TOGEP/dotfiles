local servers = {
  gopls = {},
  terraformls = {},
  rust_analyzer = {
    settings = {
      ["rust-analyzer"] = {},
    },
  },
  marksman = {},
  ltex = {
    filetypes = { "markdown", "text", "gitcommit" },
    settings = {
      ltex = {
        language = "ja-JP",
      },
    },
  },
  lua_ls = {
    settings = {
      Lua = {
        diagnostics = {
          globals = { "vim" },
        },
        workspace = {
          checkThirdParty = false,
          library = vim.api.nvim_get_runtime_file("", true),
        },
      },
    },
  },
}

local function on_attach(_, bufnr)
  vim.bo[bufnr].omnifunc = "v:lua.vim.lsp.omnifunc"

  local function map(lhs, rhs, desc)
    vim.keymap.set("n", lhs, rhs, { buffer = bufnr, silent = true, desc = desc })
  end

  map("gd", vim.lsp.buf.definition, "Go to definition")
  map("K", vim.lsp.buf.hover, "Show hover documentation")
  map("gi", vim.lsp.buf.implementation, "Go to implementation")
  map("<Space>wa", vim.lsp.buf.add_workspace_folder, "Add workspace folder")
  map("<Space>wr", vim.lsp.buf.remove_workspace_folder, "Remove workspace folder")
  map("<Space>wl", function()
    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  end, "List workspace folders")
  map("gy", vim.lsp.buf.type_definition, "Go to type definition")
  map("rn", vim.lsp.buf.rename, "Rename symbol")
  map("<Space>ca", vim.lsp.buf.code_action, "Code action")
  map("gr", vim.lsp.buf.references, "List references")
end

return {
  {
    "mason-org/mason.nvim",
    lazy = false,
    dependencies = {
      "mason-org/mason-lspconfig.nvim",
      "neovim/nvim-lspconfig",
      "hrsh7th/cmp-nvim-lsp",
      "WhoIsSethDaniel/mason-tool-installer.nvim",
    },
    config = function()
      require("mason").setup()

      local capabilities = require("cmp_nvim_lsp").default_capabilities()

      for server, config in pairs(servers) do
        local server_on_attach = vim.lsp.config[server] and vim.lsp.config[server].on_attach
        config.capabilities = vim.tbl_deep_extend(
          "force",
          vim.lsp.config[server] and vim.lsp.config[server].capabilities or {},
          capabilities
        )
        config.on_attach = function(client, bufnr)
          if server_on_attach then
            server_on_attach(client, bufnr)
          end
          on_attach(client, bufnr)
        end
        vim.lsp.config(server, config)
      end

      require("mason-lspconfig").setup({
        ensure_installed = vim.tbl_keys(servers),
        automatic_enable = vim.tbl_keys(servers),
      })

      require("mason-tool-installer").setup({
        ensure_installed = {
          "gopls",
          "terraform-ls",
          "rust-analyzer",
          "marksman",
          "ltex-ls",
          "lua-language-server",
          "goimports",
          "stylua",
        },
        auto_update = false,
        run_on_start = false,
      })
    end,
  },
  {
    "stevearc/conform.nvim",
    event = { "BufReadPre", "BufNewFile" },
    cmd = "ConformInfo",
    keys = {
      {
        "<Leader>cf",
        function()
          require("conform").format({ async = true, lsp_format = "fallback" })
        end,
        desc = "Format buffer",
      },
    },
    init = function()
      vim.api.nvim_create_user_command("Format", function()
        require("conform").format({ async = true, lsp_format = "fallback" })
      end, { desc = "Format the current buffer" })
    end,
    opts = {
      formatters_by_ft = {
        go = { "goimports" },
        lua = { "stylua" },
        rust = { "rustfmt" },
        terraform = { "terraform_fmt" },
        ["terraform-vars"] = { "terraform_fmt" },
      },
      default_format_opts = {
        lsp_format = "fallback",
      },
      format_on_save = {
        timeout_ms = 1000,
        lsp_format = "fallback",
      },
      notify_on_error = true,
      notify_no_formatters = false,
    },
  },
}
