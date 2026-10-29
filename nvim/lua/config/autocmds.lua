-- Git commit: 72 char limit & spell check
vim.api.nvim_create_autocmd({"FileType"}, {
  pattern = {
    "gitcommit",
  },
  callback = function()
    vim.bo.textwidth = 72
    vim.wo.colorcolumn = '73,74'
    vim.wo.spell = true
  end
})

-- Set 2-space indentation for configs & scripts
vim.api.nvim_create_autocmd({"FileType"}, {
  pattern = {
    "javascript",
    "lua",
    "markdown",
    "tex",
    "yaml",
  },
  callback = function()
    vim.bo.shiftwidth = 2
    vim.bo.softtabstop = 2
    vim.bo.tabstop = 2
  end
})

-- Always show markdown formatting syntax
vim.api.nvim_create_autocmd("FileType", {
  pattern = "markdown",
  callback = function()
    vim.wo.conceallevel = 0
  end,
})

-- Disable autocomplete in Telescope
vim.api.nvim_create_autocmd("FileType", {
  pattern = "TelescopePrompt",
  callback = function()
    vim.bo.autocomplete = false
  end,
})
