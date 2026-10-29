local M = {
  "nvim-telescope/telescope.nvim",
  dependencies = {
    "nvim-lua/popup.nvim",
    "nvim-lua/plenary.nvim",
    "nvim-telescope/telescope-project.nvim",
    "nvim-telescope/telescope-bibtex.nvim",
    "nvim-telescope/telescope-ui-select.nvim",
    "stevearc/aerial.nvim",
  },
  cmd = { "Telescope" },
  keys = {
    {
      "<leader>fa",
      function()
        require('telescope.builtin').builtin()
      end,
    },
    {
      "<leader>fb",
      function()
        require('telescope.builtin').buffers()
      end,
    },
    {
      "<leader>ff",
      function()
        require('telescope.builtin').find_files()
      end,
    },
    {
      "<leader>fg",
      function()
        require('telescope.builtin').live_grep()
      end,
    },
    {
      "<leader>fh",
      function()
        require('telescope.builtin').highlights()
      end,
    },
    {
      "<leader>fl",
      function()
        require('telescope.builtin').diagnostics()
      end,
    },
    {
      "<leader>fm",
      function()
        require('telescope.builtin').marks()
      end,
    },
    {
      "<leader>fo",
      function()
        require('telescope.builtin').oldfiles()
      end,
    },
    {
      "<leader>fp",
      function()
        require('telescope').extensions.project.project()
      end,
    },
    {
      "<leader>fr",
      function()
        require('telescope.builtin').lsp_references()
      end,
    },
    {
      "<leader>fs",
      function()
        require('telescope').extensions.aerial.aerial()
      end,
    },
  },
}

function M.config()
  local telescope = require('telescope')
  local builtin = require('telescope.builtin')

  telescope.setup {
    defaults = {
      mappings = {
        i = {
          ["<c-down>"] = function(...)
            return require("telescope.actions").cycle_history_next(...)
          end,
          ["<c-up>"] = function(...)
            return require("telescope.actions").cycle_history_prev(...)
          end,
        }
      }
    },
    extensions = {
      ['ui-select'] = {
        require('telescope.themes').get_dropdown()
      },
      project = {
        theme = "dropdown",
        sync_with_nvim_tree = true,
      }
    }
  }

  telescope.load_extension('project')
  telescope.load_extension('aerial')
  telescope.load_extension('bibtex')
  telescope.load_extension('ui-select')
end

return M
