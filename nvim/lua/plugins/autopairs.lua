-- Auto-close brackets and quotes. Typing `(` produces `()` with the cursor
-- in the middle; typing the closing char skips over it instead of doubling.
-- Smart enough to avoid pairing inside strings/comments.

return {
  'windwp/nvim-autopairs',
  event = 'InsertEnter',
  opts = {},
}
