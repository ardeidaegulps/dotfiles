local M = {
  "nvim-treesitter/nvim-treesitter",
  branch = "main",
  lazy = false,
  build = ":TSUpdate",
}

local languages = {
  "rust", "python", "c", "cpp", "toml", "lua", "markdown",
  "markdown_inline", "yaml", "javascript", "typescript", "bash",
  "html", "gitattributes", "gitcommit", "gitignore", "make",
  "vim", "vimdoc"
}

function M.config()
  -- Setup nvim-treesitter core
  require("nvim-treesitter.config").setup({
    ensure_installed = languages,
  })

  -- Enable highlighting via autocommand for supported filetypes
  vim.api.nvim_create_autocmd("FileType", {
    pattern = languages,
    callback = function()
      pcall(vim.treesitter.start)
    end,
  })
end

return M
