vim.g.mapleader = ","
vim.g.undodir = vim.fn.stdpath('cache')..'/undodir'
vim.g.python3_host_prog = '/usr/bin/python3'
vim.g.tex_flavor = 'latex'

require("config.autocmds")
require("config.options")
require('config.lazy')

vim.cmd [[colorscheme cactusbuddy]]

vim.api.nvim_create_autocmd("User", {
  pattern = "VeryLazy",
  callback = function()
    require("config.keymaps")
  end,
})
