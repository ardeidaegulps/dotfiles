local M = {
  "echasnovski/mini.diff",
  version = "*",
  event = "BufReadPre",
  keys = {
    {
      "<f4>",
      function()
        require("mini.diff").toggle_overlay()
      end,
      desc = "Toggle diff overlay",
    },
    {
      "<leader>hs",
      function()
        local mode = vim.api.nvim_get_mode().mode
        if mode:find("[vV\22]") then
          vim.cmd("normal! \27")
          require("mini.diff").do_hunks(0, "apply", { line_start = vim.fn.line("'<"), line_end = vim.fn.line("'>") })
        else
          require("mini.diff").do_hunks(0, "apply", { line_start = vim.fn.line("."), line_end = vim.fn.line(".") })
        end
      end,
      mode = { "n", "v" },
      desc = "Stage hunk",
    },
    {
      "<leader>hr",
      function()
        local mode = vim.api.nvim_get_mode().mode
        if mode:find("[vV\22]") then
          vim.cmd("normal! \27")
          require("mini.diff").do_hunks(0, "reset", { line_start = vim.fn.line("'<"), line_end = vim.fn.line("'>") })
        else
          require("mini.diff").do_hunks(0, "reset", { line_start = vim.fn.line("."), line_end = vim.fn.line(".") })
        end
      end,
      mode = { "n", "v" },
      desc = "Reset hunk",
    },
    {
      "[h",
      function()
        require("mini.diff").goto_hunk("prev")
      end,
      desc = "Previous hunk",
    },
    {
      "]h",
      function()
        require("mini.diff").goto_hunk("next")
      end,
      desc = "Next hunk",
    },
  },
  opts = {
    view = {
      style = "sign",
      signs = {
        add = "│",
        change = "│",
        delete = "═",
      },
    },
  },
}

return M
