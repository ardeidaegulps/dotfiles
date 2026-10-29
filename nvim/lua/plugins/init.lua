return {
  { "dstein64/vim-startuptime", cmd = "StartupTime" },
  { "tpope/vim-fugitive", cmd = "Git" },

  { "chrisgrieser/nvim-early-retirement", event = "VeryLazy" },
  { "echasnovski/mini.align", event = "VeryLazy", config = true },
  { "echasnovski/mini.operators", event = "VeryLazy", config = true },
  { "echasnovski/mini.pairs", event = "InsertEnter", config = true },
  { "kylechui/nvim-surround", event = "VeryLazy" },
  { "tpope/vim-repeat", event = "VeryLazy" },
  { "wakatime/vim-wakatime", event = "BufReadPre" },

  {
    dir = vim.fn.stdpath("config").."/cactusbuddy",
    lazy = false,
    priority = 1000,
    dependencies = {
      "echasnovski/mini.base16",
      "echasnovski/mini.statusline",
    },
    config = function()
      vim.cmd("colorscheme cactusbuddy")
    end,
  },
}
