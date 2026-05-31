-- TODO: Run `:Tutor` first if Neovim basics are rusty.
-- NOTE: `<space>sh` fuzzy-searches the help docs. Use it liberally.
-- NOTE: `:Lazy` opens the plugin manager UI (status, update, profile, etc.).
-- HACK: Run `:checkhealth` to diagnose install / plugin issues.
-- INFO: Lua primer (10–15 min) → https://learnxinyminutes.com/docs/lua/
--       Then `:help lua-guide` for how Neovim integrates Lua.

-- Set <space> as the leader key
-- See `:help mapleader`
-- NOTE: Must happen before plugins are loaded (otherwise wrong leader will be used)
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Set to true if you have a Nerd Font installed and selected in the terminal
vim.g.have_nerd_font = true

-- Disable Neovim's built-in netrw file explorer. oil.nvim handles directory
-- editing instead. These must be set before plugins load.
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- All `vim.o.*` / `vim.opt.*` configuration lives in lua/config/options.lua
-- All keymaps + diagnostic config live in lua/config/keymaps.lua
-- All autocommands live in lua/config/autocmds.lua
require 'config.options'
require 'config.keymaps'
require 'config.autocmds'

-- [[ Bootstrap lazy.nvim plugin manager ]]
-- On first launch this clones lazy.nvim into stdpath('data'); subsequent
-- launches just prepend the existing path to the runtimepath.
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = 'https://github.com/folke/lazy.nvim.git'
  local out = vim.fn.system { 'git', 'clone', '--filter=blob:none', '--branch=stable', lazyrepo, lazypath }
  if vim.v.shell_error ~= 0 then error('Error cloning lazy.nvim:\n' .. out) end
end
vim.opt.rtp:prepend(lazypath)

-- [[ Plugin specs ]]
-- Each file in lua/plugins/ is auto-discovered by lazy via this `import`.
require('lazy').setup({
  { import = 'plugins' },
}, { ---@diagnostic disable-line: missing-fields
  ui = {
    -- If you are using a Nerd Font: set icons to an empty table which will use the
    -- default lazy.nvim defined Nerd Font icons, otherwise define a unicode icons table
    icons = vim.g.have_nerd_font and {} or {
      cmd = '⌘',
      config = '🛠',
      event = '📅',
      ft = '📂',
      init = '⚙',
      keys = '🗝',
      plugin = '🔌',
      runtime = '💻',
      require = '🌙',
      source = '📄',
      start = '🚀',
      task = '📌',
      lazy = '💤 ',
    },
  },
})

-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
