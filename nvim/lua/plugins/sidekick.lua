-- Ensures `target` is a symlink pointing at `source`, (re)creating it if
-- missing or stale. Used to expose skills kept in this nvim config to
-- Copilot CLI's skills directory (~/.copilot/skills).
local function ensure_skill_symlink(source, target)
  local stat = vim.uv.fs_lstat(target)
  if stat then
    if stat.type ~= "link" then
      vim.notify(("sidekick: %s already exists and is not a symlink"):format(target), vim.log.levels.WARN)
      return
    end
    if vim.uv.fs_readlink(target) == source then
      return -- already correct
    end
    vim.uv.fs_unlink(target)
  end

  vim.fn.mkdir(vim.fs.dirname(target), "p")
  local ok, err = vim.uv.fs_symlink(source, target)
  if not ok then
    vim.notify(("sidekick: failed to symlink %s -> %s: %s"):format(target, source, err), vim.log.levels.ERROR)
  end
end

local M = {
  "folke/sidekick.nvim",
  opts = {
    nes = {
      enabled = true,
    },
    cli = {
      tools = {
        copilot = {},
      },
    },
  },
  keys = {
    {
      "<tab>",
      function()
        if not require("sidekick").nes_jump_or_apply() then
          return "<Tab>"
        end
      end,
      mode = { "n" },
      expr = true,
      desc = "Sidekick NES Jump/Apply",
    },
    {
      "<leader>s",
      function()
        require("sidekick.cli").toggle({ name = "copilot", focus = true })
      end,
      desc = "Sidekick Toggle Copilot CLI",
    },
  },
  config = function(_, opts)
    require("sidekick").setup(opts)
    ensure_skill_symlink(
      vim.fn.stdpath("config") .. "/skills/docs-rs",
      vim.fn.expand("~/.copilot/skills/docs-rs")
    )
  end,
}

return M
