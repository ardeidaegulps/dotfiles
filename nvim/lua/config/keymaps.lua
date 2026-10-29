local map = vim.keymap.set

function custom(name)
  return function() require("config.keymaps")[name]() end
end

map('n', '<leader>yc', custom("toggle_colorcolumn"))
map('n', '<leader>yd', custom("toggle_docs"))
map('n', '<leader>yp', custom("toggle_paste"))
map('n', '<leader>yw', custom("toggle_wrap"))

map('n', '<f10>', '<cmd>let @+ = expand("%:p")<cr><cmd>echo "Copied: ".expand("%:p")<cr>')

map({ 'n', 'v' }, '<leader>c', vim.lsp.buf.code_action)
map({ 'n', 'v' }, 'gra', vim.lsp.buf.code_action)
map('n', '<leader>l', function() vim.diagnostic.open_float { border = 'single' } end)
map('n', '<leader>p', ':lua=')

-- MISCELLANEOUS

map('n', 'q:', '<nop>')
map('n', 'q', '<nop>')
map('n', 'Q', 'q')

map('n', 'K', vim.lsp.buf.hover)  -- better keyword lookup
map('n', 'Y', 'y$')  -- yank until end-of-line, recommended in help-doc
map('v', '/', '<esc>/\\%V')  -- search within range
map('n', '-', '$')  -- dollar sign is hard to reach
map('v', '-', '$')  -- dollar sign is hard to reach
map('n', '<c-c>', '<c-a>')  -- <c-a> is my tmux prefix key
map('n', 'g-', '<cmd>%s`\\s\\+$``e<cr><cmd>let @/="<<<<<<<"<cr>``')

-- NAVIGATE

map('n', '[l', custom("prev_diagnostic"))
map('n', ']l', custom("next_diagnostic"))

map('n', 'gD', vim.lsp.buf.declaration)
map('n', 'gd', vim.lsp.buf.definition)
map('n', '<c-]>', vim.lsp.buf.definition)

map('t', '<c-h>', '<c-\\><c-n><c-w>h')
map('t', '<c-j>', '<c-\\><c-n><c-w>j')
map('t', '<c-k>', '<c-\\><c-n><c-w>k')
map('t', '<c-l>', '<c-\\><c-n><c-w>l')
map('n', '<c-h>', '<c-w>h')
map('n', '<c-j>', '<c-w>j')
map('n', '<c-k>', '<c-w>k')
map('n', '<c-l>', '<c-w>l')
map('v', '<c-h>', '<gv')
map('v', '<c-j>', 'xp`[V`]')
map('v', '<c-k>', 'xkP`[V`]')
map('v', '<c-l>', '>gv')

-- OTHER MODES

map('c', '<c-c>', '<esc>')
map('c', '<c-_>', '<cr>:%s`<C-r>/``gc<left><left><left>')
map('c', 'w!!', 'w !sudo tee % >/dev/null')

-- map('i', '<leader>flag', '⚑')
map('n', '<leader><leader>', '<esc><cmd>let @/="<<<<<<<"<cr>n')
map('v', '<leader><leader>', '<esc><cmd>let @/="<<<<<<<"<cr>n')
map('i', '<leader><leader>', '<esc><cmd>let @/="<<<<<<<"<cr>n')

-- <c-o>,yp to toggle paste mode
map('i', '<leader>print', '<c-g>uprintln!("{:?}", );<left><left><c-g>u')

map('i', '<leader>*', '<c-g>u<esc>[s1z=`]a<c-g>u')  -- fix last misspelled word
map('i', '<leader>"', '<c-r>')
map('i', '<leader>[', '<left>')
map('i', '<leader>]', '<right>')


local M = {}

function M.toggle_colorcolumn()
  local cc = vim.wo.colorcolumn
  vim.wo.colorcolumn = (cc ~= '81,82') and '81,82' or ''
end

function M.toggle_wrap()
  vim.opt.wrap = not vim.opt.wrap._value
end

function M.toggle_paste()
  vim.opt.paste = not vim.opt.paste._value
end

function M.toggle_docs()
  local colorbuddy = require('colorbuddy')
  local Color, c, Group, g, s = colorbuddy.setup()
  if g["@string.docstring"].parent.name == 'darker' then
    Group.new('@string.docstring', c.blue, c.none, s.none)
  else
    Group.new('@string.docstring', c.darker, c.none, s.none)
  end
end

function M.prev_diagnostic()
  local row = vim.api.nvim_win_get_cursor(0)[1]
  local diag = vim.diagnostic
  local errors = diag.get(0, {
    severity = diag.severity.ERROR
  })
  diag.goto_prev {
    float = { border = 'single' },
    cursor_position = { row - 1, 0 },
    severity = (next(errors) ~= nil) and diag.severity.ERROR or diag.severity.WARN
  }
end

function M.next_diagnostic()
  local row = vim.api.nvim_win_get_cursor(0)[1]
  local diag = vim.diagnostic
  local errors = diag.get(0, {
    severity = diag.severity.ERROR
  })
  diag.goto_next {
    float = { border = 'single' },
    cursor_position = { row + 1, 0 },
    severity = (next(errors) ~= nil) and diag.severity.ERROR or diag.severity.WARN
  }
end

-- NATIVE FLOATING TERMINAL

local term_buf = nil
local term_win = nil

local function get_dimensions()
  local stats = vim.api.nvim_list_uis()[1]
  local width = math.floor(stats.width * 0.8)
  local height = math.floor(stats.height * 0.8)
  local row = math.floor((stats.height - height) / 2)
  local col = math.floor((stats.width - width) / 2)
  return width, height, row, col
end

local function toggle_terminal()
  if term_win and vim.api.nvim_win_is_valid(term_win) then
    vim.api.nvim_win_close(term_win, true)
    term_win = nil
    return
  end

  local width, height, row, col = get_dimensions()

  if not term_buf or not vim.api.nvim_buf_is_valid(term_buf) then
    term_buf = vim.api.nvim_create_buf(false, true)
  end

  term_win = vim.api.nvim_open_win(term_buf, true, {
    relative = "editor",
    width = width,
    height = height,
    row = row,
    col = col,
    style = "minimal",
    border = "single",
  })

  if vim.bo[term_buf].buftype ~= "terminal" then
    vim.fn.termopen(vim.o.shell, { env = { LD_LIBRARY_PATH = "" } })
  end
  vim.cmd("startinsert")
end

local function run_in_floating_terminal(cmd)
  local width, height, row, col = get_dimensions()
  local buf = vim.api.nvim_create_buf(false, true)

  local win = vim.api.nvim_open_win(buf, true, {
    relative = "editor",
    width = width,
    height = height,
    row = row,
    col = col,
    style = "minimal",
    border = "single",
  })

  vim.fn.termopen(cmd, { env = { LD_LIBRARY_PATH = "" } })

  vim.keymap.set('n', 'q', function()
    if vim.api.nvim_win_is_valid(win) then
      vim.api.nvim_win_close(win, true)
    end
  end, { buffer = buf, silent = true })

  vim.cmd("startinsert")
end

local blame_win = nil

local UNCOMMITTED = '^0+$'

local function blame_line(file, line)
  local output = vim.fn.systemlist({ 'git', 'blame', '--porcelain', '-L', line .. ',' .. line, '--', file })
  if vim.v.shell_error ~= 0 or #output == 0 then
    return nil
  end
  local info = {}
  for _, l in ipairs(output) do
    local key, val = l:match('^(%S+) (.*)$')
    if key and info[key] == nil then info[key] = val end
  end
  info.hash = output[1]:match('^(%x+)')
  info.orig_line = tonumber(output[1]:match('^%x+ (%d+)'))
  return info
end

local function branch_of(hash)
  for _, refs in ipairs({ '--refs=refs/remotes/*', '--refs=refs/heads/*' }) do
    local name = vim.fn.system({ 'git', 'name-rev', '--name-only', refs, '--exclude=*/HEAD', hash })
      :gsub('%s+$', ''):gsub('^remotes/', '')
    if vim.v.shell_error == 0 and name ~= '' and name ~= 'undefined' then
      return name
    end
  end
  return '-'
end

local function parse_hunks(raw)
  local hunks, cur = {}, nil
  for _, l in ipairs(raw) do
    if l:match('^@@') then
      cur = {
        start = tonumber(l:match('%+(%d+)')),
        count = tonumber(l:match('%+%d+,(%d+)')) or 1,
        body = {},
      }
      table.insert(hunks, cur)
    elseif cur then
      table.insert(cur.body, l)
    end
  end
  return hunks
end

-- Returns the hunk lines around the blamed line, with '~' marking omitted lines.
local function diff_snippet(hash, file, orig_line, context)
  local hunks = parse_hunks(vim.fn.systemlist({ 'git', 'show', '--format=', '-U3', hash, '--', file }))
  for _, h in ipairs(hunks) do
    if orig_line >= h.start and orig_line < h.start + h.count then
      local new_no, target = h.start - 1, 1
      for i, l in ipairs(h.body) do
        local p = l:sub(1, 1)
        if p == ' ' or p == '+' then new_no = new_no + 1 end
        if p == '+' and new_no == orig_line then target = i end
      end
      local from = math.max(1, target - context)
      local to = math.min(#h.body, target + context)
      local snippet = {}
      if from > 1 then table.insert(snippet, '~') end
      for i = from, to do
        table.insert(snippet, h.body[i])
      end
      if to < #h.body then table.insert(snippet, '~') end
      return snippet
    end
  end
  return {}
end

local diff_group = { ['+'] = 'DiffAdd', ['-'] = 'DiffDelete' }

local function git_blame_float()
  if blame_win and vim.api.nvim_win_is_valid(blame_win) then
    vim.api.nvim_win_close(blame_win, true)
    blame_win = nil
    return
  end

  local file = vim.fn.expand('%:p')
  local info = blame_line(file, vim.fn.line('.'))
  local lines, marks, diff_lines = {}, {}, {}

  if not info then
    lines = { 'not in a git tree' }
  else
    local hash = info.hash
    local short = hash:sub(1, 8)
    local branch = '-'
    local uncommitted = hash:match(UNCOMMITTED) ~= nil
    if not uncommitted then
      branch = branch_of(hash)
      diff_lines = diff_snippet(hash, file, info.orig_line, 3)
    end

    local author = info.author or ''
    local title = info.summary or ''
    lines = { short .. ' ' .. author .. ' ' .. title, 'branch: ' .. branch }
    local author_start = #short + 1
    local author_end = author_start + #author
    marks = {
      { 0, 0, #short, 'Comment' },
      { 0, author_start, author_end, 'Comment' },
      { 0, author_end + 1, #lines[1], 'Noise' },
      { 1, 0, #'branch:', 'Comment' },
      { 1, #'branch: ', #lines[2], 'Noise' },
    }
  end

  local header_rows = #lines
  for _, l in ipairs(diff_lines) do
    table.insert(lines, l)
    local row = #lines - 1
    local group = diff_group[l:sub(1, 1)]
    if not group and (l == '~' or l:sub(1, 2) == '@@') then group = 'Comment' end
    if group then
      table.insert(marks, { row, 0, #l, group })
    end
  end

  local width = 0
  for _, l in ipairs(lines) do
    width = math.max(width, vim.fn.strdisplaywidth(l))
  end

  local buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
  vim.bo[buf].bufhidden = 'wipe'

  local blame_ns = vim.api.nvim_create_namespace('git_blame_float')
  for _, m in ipairs(marks) do
    vim.api.nvim_buf_set_extmark(buf, blame_ns, m[1], m[2], { end_col = m[3], hl_group = m[4] })
  end

  blame_win = vim.api.nvim_open_win(buf, false, {
    relative = "cursor",
    width = math.min(width + 2, math.floor(vim.o.columns * 0.8)),
    height = math.min(#lines, vim.o.lines - 6),
    row = 1,
    col = 0,
    style = "minimal",
    border = "single",
  })
  vim.wo[blame_win].wrap = false

  vim.api.nvim_create_autocmd({ "CursorMoved", "InsertEnter", "BufLeave" }, {
    once = true,
    callback = function()
      if blame_win and vim.api.nvim_win_is_valid(blame_win) then
        vim.api.nvim_win_close(blame_win, true)
      end
      blame_win = nil
    end,
  })
end

map({ 'n', 't' }, '<f9>', toggle_terminal)
map('n', '<f3>', git_blame_float)
map('n', '<f5>', function() run_in_floating_terminal("make build") end)
map('n', '<f6>', function() run_in_floating_terminal("make start") end)
map('n', '<f7>', function() run_in_floating_terminal("make debug") end)
map('n', '<f8>', function() run_in_floating_terminal("make check") end)

return M
