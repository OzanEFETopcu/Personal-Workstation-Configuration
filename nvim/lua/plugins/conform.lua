-- Format runner. Pipes the current buffer through a configured external
-- formatter (e.g. stylua for Lua). Install formatters via Mason; wire them up
-- per-filetype below.
--
-- Run `:ConformInfo` to see what conform will do for the current buffer.

return {
  'stevearc/conform.nvim',
  event = { 'BufWritePre' },
  cmd = { 'ConformInfo' },
  keys = {
    {
      '<leader>f',
      function() require('conform').format { async = true } end,
      mode = '',
      desc = '[F]ormat buffer',
    },
  },
  ---@module 'conform'
  ---@type conform.setupOpts
  opts = {
    notify_on_error = false,

    -- Per-filetype: opt-in to format-on-save by listing the filetype below.
    -- Triggered on BufWritePre (every save, including autosaves).
    format_on_save = function(bufnr)
      local enabled_filetypes = {
        lua = true,
        javascript = true,
        javascriptreact = true,
        typescript = true,
        typescriptreact = true,
        json = true,
        jsonc = true,
        markdown = true,
        css = true,
        scss = true,
        html = true,
        yaml = true,
        cs = true,
      }
      if enabled_filetypes[vim.bo[bufnr].filetype] then
        return { timeout_ms = 500 }
      else
        return nil
      end
    end,

    default_format_opts = {
      lsp_format = 'fallback', -- if no formatter is configured for the filetype, ask the LSP
    },

    -- Which external formatter(s) to run for each filetype. List multiple to
    -- chain them in order, or set `stop_after_first = true` to try alternatives.
    formatters_by_ft = {
      lua = { 'stylua' },
      javascript = { 'prettier' },
      javascriptreact = { 'prettier' },
      typescript = { 'prettier' },
      typescriptreact = { 'prettier' },
      json = { 'prettier' },
      jsonc = { 'prettier' },
      markdown = { 'prettier' },
      css = { 'prettier' },
      scss = { 'prettier' },
      html = { 'prettier' },
      yaml = { 'prettier' },
      cs = { 'csharpier' },
    },
  },
}
