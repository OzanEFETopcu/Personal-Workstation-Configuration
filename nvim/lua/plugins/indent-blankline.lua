-- Vertical indent guides on every line, even blank ones. Helps you see
-- nesting depth at a glance. See `:help ibl`.

return {
  'lukas-reineke/indent-blankline.nvim',
  main = 'ibl', -- the module name differs from the repo name
  ---@module 'ibl'
  ---@type ibl.config
  opts = {},
}
