local M = {
  "neovim/nvim-lspconfig",
  dependencies = {
    {
      "chrisgrieser/nvim-lsp-endhints",
      config = function()
        require("lsp-endhints").setup {
          icons = {
            type = "■ ",
            parameter = "■ ",
            offspec = "■ ",
            unknown = "■ ",
          },
        }
      end,
    },
  },
  event = "BufReadPre",
}

function M.config()
  vim.diagnostic.config({
    virtual_text = {
      severity = { min = vim.diagnostic.severity.WARN },
    },
  })

  local custom_init = function(client, init)
    if client.server_capabilities then
      client.server_capabilities.documentFormattingProvider = nil
      client.server_capabilities.semanticTokensProvider = nil
    end
  end

  -- Global LspAttach autocommand to enable inlay hints and native completion when supported
  vim.api.nvim_create_autocmd("LspAttach", {
    callback = function(args)
      local client = vim.lsp.get_client_by_id(args.data.client_id)
      if not client then return end
      if client.server_capabilities.inlayHintProvider then
        vim.lsp.inlay_hint.enable(true, { bufnr = args.buf })
      end
    end,
  })

  -- Define LSP configurations using Neovim 0.11/0.12+ native API
  vim.lsp.config('rust_analyzer', {
    on_init = custom_init,
    settings = {
      ["rust-analyzer"] = {
        cargo = {
          extraEnv = {
            RUSTFLAGS = "-A dead_code", -- https://stackoverflow.com/a/76095190
          }
        },
        check = {
          -- command = "clippy",
          invocationLocation = "root",
        },
        diagnostics = {
          disabled = {
            "unresolved-extern-crate", -- rust-analyzer#6714
            "unresolved-proc-macro",   -- rust-analyzer#7497
            "inactive-code",
          }
        }
      }
    }
  })

  vim.lsp.config('pylsp', {
    settings = {
      pylsp = {
        plugins = {
          pycodestyle = {
            ignore = {'E501', 'W504'},
          }
        }
      }
    }
  })

  vim.lsp.config('clangd', {})

  vim.lsp.config('taplo', {})

  -- Enable the configured servers
  vim.lsp.enable({ 'rust_analyzer', 'pylsp', 'clangd', 'taplo' })
end

return M
