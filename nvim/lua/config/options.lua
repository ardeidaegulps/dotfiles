local indent = 4

-- FEATURES
vim.o.foldmethod = 'expr'
vim.o.foldlevel = 99
vim.o.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
vim.o.path = vim.o.path .. ',**'
vim.o.splitright = true
vim.o.completeopt = 'menu,menuone,popup'
vim.o.autocomplete = false
vim.o.shortmess = vim.o.shortmess .. 'c'
vim.o.backspace = vim.o.backspace .. ',nostop'
vim.o.mouse = ''

vim.o.compatible = false
vim.o.formatprg = 'par -w 72'

-- INDENTS
vim.o.expandtab = true
vim.o.shiftwidth = indent
vim.o.softtabstop = indent
vim.o.tabstop = indent
vim.o.spelllang = 'en_us,cjk'
vim.o.formatoptions = 'tcqjnB'
vim.o.textwidth = 80

-- SEARCHING
vim.o.ignorecase = true
vim.o.smartcase = true
vim.o.incsearch = true
vim.o.hlsearch = true

-- LOOKINGS
vim.o.list = true
vim.o.number = true
vim.o.cursorline = true
vim.o.colorcolumn = '81,82'
vim.o.listchars = vim.o.listchars .. ',tab:» ,trail:·'
vim.o.fillchars = 'fold:╴'
vim.o.termguicolors = true
vim.o.background = 'dark'
vim.o.showmode = false
vim.o.scrolloff = 3
vim.o.showtabline = 0
vim.o.winborder = 'single'

-- Force Neovim terminal/shell to run as a login shell to inherit system profiles
if not vim.o.shell:find('-l') then
  vim.o.shell = vim.o.shell .. ' -l'
end
