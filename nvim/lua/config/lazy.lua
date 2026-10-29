local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end

vim.opt.rtp:prepend(lazypath)

require("lazy").setup("plugins", {
  ui = {
    border = "single",
    icons = {
      loaded = "●",
      not_loaded = "○",
      cmd = "ᴄᴍᴅ",
      config = "ᴄꜰɢ",
      event = "ᴇᴠᴛ",
      ft = "ꜰᴛᴘ",
      init = "ɪɴɪᴛ",
      keys = "ᴋᴇʏ",
      plugin = "ᴘʟᴜɢ",
      runtime = "ʀᴜɴ",
      source = "ꜱʀᴄ",
      start = "ꜱᴛᴀʀᴛ",
      task = "ᴛᴀꜱᴋ",
      lazy = "ʟᴀᴢʏ",
      list = {
        "●",
        "➜",
        "★",
        "‒",
      },
    },
  }
})
