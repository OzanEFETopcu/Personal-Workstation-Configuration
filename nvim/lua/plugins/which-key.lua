-- Popup that shows the next available keys after a partial sequence (e.g.
-- press <leader> and pause). Reads the `desc` field of every keymap, so most
-- of the work is done just by writing descriptive keymaps.
return {
  'folke/which-key.nvim',
  event = 'VimEnter',
  ---@module 'which-key'
  ---@type wk.Opts
  ---@diagnostic disable-next-line: missing-fields
  opts = {
    -- delay between pressing a key and opening which-key (milliseconds)
    delay = 0,
    icons = { mappings = vim.g.have_nerd_font },

    -- Document existing key chains so they show up grouped in the popup.
    spec = {
      { '<leader>s', group = '[S]earch', mode = { 'n', 'v' } },
      { '<leader>t', group = '[T]oggle' },
      { '<leader>h', group = 'Git [H]unk', mode = { 'n', 'v' } }, -- Enable gitsigns recommended keymaps first
      { '<leader>g', group = '[G]it (status / diff / history)' },
      { 'gr', group = 'LSP Actions', mode = { 'n' } },
    },
  },
}
