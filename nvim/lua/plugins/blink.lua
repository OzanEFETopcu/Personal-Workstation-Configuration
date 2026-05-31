-- Autocompletion engine. Pops up suggestions from the LSP, snippets, and
-- filesystem paths as you type. LuaSnip provides snippet expansion.
--
-- Default preset keymaps (insert mode, while menu is open):
--   <C-y>          accept the highlighted suggestion
--   <C-n> / <Down> next item
--   <C-p> / <Up>   previous item
--   <C-Space>      open menu / toggle docs panel
--   <C-e>          dismiss menu
--   <C-k>          toggle signature help
--   <Tab> / <S-Tab> jump between snippet placeholders (after accepting a snippet)
--
-- NOTE: For docs on a symbol in your code (not the completion menu), use `K`
-- in normal mode — that's the LSP hover, separate from this plugin.

return {
  'saghen/blink.cmp',
  event = 'VimEnter',
  version = '1.*',
  dependencies = {
    -- Snippet engine that blink uses under the hood.
    {
      'L3MON4D3/LuaSnip',
      version = '2.*',
      build = (function()
        -- Compile jsregexp for richer regex inside snippets. Skipped on Windows
        -- or when `make` isn't available.
        if vim.fn.has 'win32' == 1 or vim.fn.executable 'make' == 0 then return end
        return 'make install_jsregexp'
      end)(),
      dependencies = {
        -- `friendly-snippets` is a giant collection of language snippets.
        -- Uncomment to enable; see https://github.com/rafamadriz/friendly-snippets
        -- {
        --   'rafamadriz/friendly-snippets',
        --   config = function()
        --     require('luasnip.loaders.from_vscode').lazy_load()
        --   end,
        -- },
      },
      opts = {},
    },
  },
  ---@module 'blink.cmp'
  ---@type blink.cmp.Config
  opts = {
    keymap = {
      -- 'default'    → <C-y> to accept (Vim-style)                   ← current
      -- 'super-tab'  → <Tab>  to accept (still uses C-n/C-p to navigate)
      -- 'enter'      → <CR>   to accept
      preset = 'default',
    },

    appearance = {
      -- Match the Nerd Font "Mono" variant for icon alignment.
      nerd_font_variant = 'mono',
    },

    completion = {
      -- Show docs side-panel; first 500ms is a delay before it appears.
      -- Manually toggle with <C-Space> when the menu is open.
      documentation = { auto_show = false, auto_show_delay_ms = 500 },
    },

    sources = {
      default = { 'lsp', 'path', 'snippets' },
    },

    snippets = { preset = 'luasnip' },

    -- 'lua' = pure-Lua matcher (works everywhere, slower)
    -- 'prefer_rust_with_warning' = use the bundled Rust matcher when available
    fuzzy = { implementation = 'lua' },

    -- Signature help while typing function arguments.
    signature = { enabled = true },
  },
}
