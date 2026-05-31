-- Tokyonight colorscheme (variants: -night, -storm, -moon, -day).
-- Live-preview every installed colorscheme with `:Telescope colorscheme`.

return {
  'folke/tokyonight.nvim',
  priority = 1000, -- load before other plugins so they pick up the right highlight groups
  config = function()
    ---@diagnostic disable-next-line: missing-fields
    require('tokyonight').setup {
      styles = {
        comments = { italic = false },
      },
    }
    vim.cmd.colorscheme 'tokyonight-night'
  end,
}
