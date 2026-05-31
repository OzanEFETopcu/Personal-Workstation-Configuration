-- Runs CLI linters (eslint_d, markdownlint, ...) and surfaces their output
-- as Neovim diagnostics. Complementary to LSP: LSP handles types and
-- semantic checks; linters handle style and project conventions.
--
-- To wire a linter to a filetype: add it to `linters_by_ft` below.
-- The binary must be installed (via Mason or system package manager).

return {
  'mfussenegger/nvim-lint',
  event = { 'BufReadPre', 'BufNewFile' },
  config = function()
    local lint = require 'lint'

    lint.linters_by_ft = {
      markdown = { 'markdownlint' },
      -- ESLint is handled by `eslint-lsp` (an LSP server), configured in
      -- lua/plugins/lsp.lua, not by nvim-lint. It uses the project's local
      -- ESLint via node_modules, which avoids version-mismatch bugs.
    }

    -- Run linters on the events most editors call "save / leave insert mode".
    local lint_augroup = vim.api.nvim_create_augroup('lint', { clear = true })
    vim.api.nvim_create_autocmd({ 'BufEnter', 'BufWritePost', 'InsertLeave' }, {
      group = lint_augroup,
      callback = function()
        -- Skip non-editable buffers (LSP hover popups, help, etc.) to avoid noise.
        if vim.bo.modifiable then lint.try_lint() end
      end,
    })
  end,
}
