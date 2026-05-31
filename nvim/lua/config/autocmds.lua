-- [[ Basic Autocommands ]]
--  See `:help lua-guide-autocommands`

-- Highlight when yanking (copying) text
--  Try it with `yap` in normal mode
--  See `:help vim.hl.on_yank()`
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function() vim.hl.on_yank() end,
})

-- Auto-save (VS Code-like): write the buffer when leaving insert mode, after a
-- normal-mode change, or when the window loses focus.
vim.api.nvim_create_autocmd({ 'InsertLeave', 'TextChanged', 'FocusLost' }, {
  desc = 'Auto-save on change / focus loss',
  group = vim.api.nvim_create_augroup('user-auto-save', { clear = true }),
  callback = function()
    if vim.bo.modified and vim.bo.buftype == '' and vim.fn.expand('%') ~= '' then
      vim.cmd.write()
    end
  end,
})

-- In diff windows, sync cursor movement between panes (j/k on one side
-- moves both). Scrollbind is already on by default in diff mode; cursorbind
-- is not. Together they give the VS Code "two cursors in lockstep" feel.
vim.api.nvim_create_autocmd('OptionSet', {
  pattern = 'diff',
  group = vim.api.nvim_create_augroup('user-diff-cursorbind', { clear = true }),
  callback = function()
    if vim.v.option_new == 'true' then
      vim.wo.cursorbind = true
    end
  end,
})

-- Restore last cursor position when reopening a file. Neovim stores a mark
-- named `"` (double-quote) for the cursor's location at last exit; we jump to
-- it if it's still within the file's bounds.
vim.api.nvim_create_autocmd('BufReadPost', {
  desc = 'Restore last cursor position',
  group = vim.api.nvim_create_augroup('user-restore-cursor', { clear = true }),
  callback = function(event)
    local mark = vim.api.nvim_buf_get_mark(event.buf, '"')
    local line_count = vim.api.nvim_buf_line_count(event.buf)
    if mark[1] > 0 and mark[1] <= line_count then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
  end,
})
