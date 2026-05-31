-- A directory editor: opens any folder as a buffer where you create, rename,
-- delete, and move files by editing the text. Save the buffer to apply
-- changes (oil shows a confirmation preview first).
--
-- Default keymaps inside an oil buffer:
--   <CR>   open file / enter directory
--   -      go up one directory
--   _      open the cwd
--   gx     open file with system app
--   g.     toggle hidden files
--   gs     change sort order
--   g?     show full keymap help

return {
  'stevearc/oil.nvim',
  dependencies = { 'nvim-tree/nvim-web-devicons' },
  lazy = false, -- needed early so `nvim <dir>` opens in oil instead of netrw
  keys = {
    { '-', '<cmd>Oil<CR>', desc = 'Open parent directory in oil' },
    { '<leader>e', '<cmd>Oil<CR>', desc = 'Open file [E]xplorer (oil)' },
  },
  ---@module 'oil'
  ---@type oil.SetupOpts
  opts = {
    -- Show hidden files by default — toggle with `g.` inside oil.
    view_options = {
      show_hidden = true,
    },
    -- Show file size, mtime, permissions in the gutter (toggle with `g\`).
    columns = { 'icon' },
    -- Skip the confirmation popup for trivial single-file actions, still
    -- prompts for batch/dangerous ones. Set to true if you want the prompt
    -- to always appear.
    skip_confirm_for_simple_edits = false,
  },
}
