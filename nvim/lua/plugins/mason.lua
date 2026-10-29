local M = {
  "williamboman/mason.nvim",
  event = "VeryLazy",
  cmd = "Mason",
}

tools = {
  "rust-analyzer",
  "python-lsp-server",
  "clangd",
}

function M.config()
  require("mason").setup()
  local mr = require("mason-registry")
  for _, tool in ipairs(tools) do
    local p = mr.get_package(tool)
    if not p:is_installed() then
      p:install()
    end
  end
end

return M
