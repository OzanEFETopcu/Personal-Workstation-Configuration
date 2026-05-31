-- Side-by-side diff viewer + file history browser. Pairs with neogit:
-- neogit drives the status/stage/commit workflow, diffview renders the diffs.
--
-- Inside a Diffview tab:
--   <Tab> / <S-Tab>  next / previous file in the file panel
--   <C-w>w           switch between file panel, left diff, and right diff
--   ]c / [c          next / previous hunk (also works for git diffs)
--   :DiffviewClose   close the diffview tab

return {
  'sindrets/diffview.nvim',
  cmd = { 'DiffviewOpen', 'DiffviewClose', 'DiffviewToggleFiles', 'DiffviewFocusFiles', 'DiffviewFileHistory' },
  keys = {
    { '<leader>gd', '<cmd>DiffviewOpen<CR>',          desc = '[G]it [D]iff (working tree vs HEAD)' },
    { '<leader>gc', '<cmd>DiffviewClose<CR>',         desc = '[G]it Diff [C]lose' },
    { '<leader>gh', '<cmd>DiffviewFileHistory %<CR>', desc = '[G]it file [H]istory (current file)' },
    { '<leader>gH', '<cmd>DiffviewFileHistory<CR>',   desc = '[G]it [H]istory (whole repo)' },
  },
  opts = {
    enhanced_diff_hl = true, -- highlight intra-line changes (word-level diffs)
  },
}
