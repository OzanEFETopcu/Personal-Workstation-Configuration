-- Magit-style git workflow inside Neovim: status view, stage/unstage by file
-- or hunk, commit, push, pull, branch, stash. Hands off to diffview for rich
-- side-by-side diff rendering.
--
-- In the status buffer:
--   <Tab>     toggle inline diff for the file under cursor
--   s         stage the file / hunk under cursor
--   S         stage everything
--   u         unstage the file / hunk under cursor
--   U         unstage everything
--   x         discard changes (asks first)
--   c c       commit (opens an editor for the message; :wq to confirm)
--   c a       amend the last commit
--   P p       push to upstream
--   F p       pull from upstream
--   b b       checkout branch
--   $         show git history of the cursor item
--   ?         full keymap help

return {
  'NeogitOrg/neogit',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'sindrets/diffview.nvim',
    'nvim-telescope/telescope.nvim',
  },
  cmd = 'Neogit',
  keys = {
    { '<leader>gs', '<cmd>Neogit<CR>', desc = '[G]it [S]tatus (neogit)' },
  },
  opts = {
    integrations = {
      diffview = true,
      telescope = true,
    },
    disable_hint = false, -- show the top "press ? for help" hint
  },
}
