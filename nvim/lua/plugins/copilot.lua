-- GitHub Copilot AI suggestions, rendered as inline ghost text.
--
-- Authenticate once with `:Copilot auth` (opens a browser device-code flow).
-- If you already use Copilot in VS Code, the token in ~/.config/github-copilot/
-- is auto-detected — no extra step needed.
--
-- Inside an active suggestion (the faded text after your cursor):
--   <C-g>   accept the whole suggestion
--   <M-]>   next suggestion (cycle alternatives Copilot generated)
--   <M-[>   previous suggestion
--   <M-\>   dismiss the suggestion
--
-- Useful commands:
--   :Copilot status   show authentication / enabled state
--   :Copilot panel    open a panel with multiple suggestion alternatives
--   :Copilot disable  / :Copilot enable

return {
  'zbirenbaum/copilot.lua',
  event = 'InsertEnter',
  cmd = 'Copilot',
  opts = {
    suggestion = {
      enabled = true,
      auto_trigger = true, -- pop up suggestions automatically as you type
      hide_during_completion = true, -- don't fight the blink completion menu
      debounce = 75,
      keymap = {
        accept = '<C-g>',
        accept_word = false,
        accept_line = false,
        next = '<M-]>',
        prev = '<M-[>',
        dismiss = '<M-\\>',
      },
    },
    panel = {
      enabled = true,
      auto_refresh = true,
      keymap = {
        jump_prev = '[[',
        jump_next = ']]',
        accept = '<CR>',
        refresh = 'gr',
        open = '<M-CR>',
      },
    },
    -- Filetypes where Copilot should NOT run. The `*` catch-all is true by
    -- default; explicitly disable in places where AI suggestions are noise.
    filetypes = {
      ['*'] = true,
      gitcommit = false,
      gitrebase = false,
      help = false,
      TelescopePrompt = false,
      ['neo-tree-popup'] = false,
    },
  },
}
