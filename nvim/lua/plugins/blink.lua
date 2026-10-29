return {
  "saghen/blink.cmp",
  dependencies = { "rafamadriz/friendly-snippets" },
  version = "*",
  opts = {
    keymap = {
      preset = "none",
      ["<Tab>"] = {
        "select_and_accept",
        "snippet_forward",
        function() -- sidekick next edit suggestion
          return require("sidekick").nes_jump_or_apply()
        end,
        "fallback",
      },
      ["<S-Tab>"] = { "select_prev", "snippet_backward", "fallback" },
      -- ["<C-space>"] = { "show", "show_documentation", "hide_documentation" },
    },
    completion = {
      menu = {
        auto_show = false,
        draw = {
          columns = { { "label", "label_description", gap = 1 }, { "kind" } },
        },
      },
      ghost_text = {
        enabled = function()
          if vim.fn.pumvisible() ~= 0 then
            return false
          end
          local col = vim.api.nvim_win_get_cursor(0)[2]
          local line = vim.api.nvim_get_current_line()
          local next_char = line:sub(col + 1, col + 1)
          if next_char:match("[%w_]") then
            return false
          end
          return true
        end,
      },
    },
  },
}
