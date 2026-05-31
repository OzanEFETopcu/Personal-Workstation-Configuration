-- Highlight TODO / NOTE / HACK / FIX / WARN / PERF / INFO etc. in comments
-- with distinct colors. Provides `:TodoTelescope` to fuzzy-search them.
-- Only works in line comments (`--`), not block comments (`--[[ ]]`).

return {
  'folke/todo-comments.nvim',
  event = 'VimEnter',
  dependencies = { 'nvim-lua/plenary.nvim' },
  ---@module 'todo-comments'
  ---@type TodoOptions
  ---@diagnostic disable-next-line: missing-fields
  opts = { signs = false },
}
