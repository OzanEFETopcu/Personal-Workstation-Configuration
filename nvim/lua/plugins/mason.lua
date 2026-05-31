-- Central registry of every external tool Mason should keep installed.
-- These three lists are flat name lists — actual configuration of each tool
-- lives where it's wired: LSPs in lua/plugins/lsp.lua, formatters in
-- conform.lua, linters in lint.lua.

local servers = {
  'lua_ls',
  'ts_ls',
  'eslint-lsp', -- ESLint as an LSP (uses project's local eslint via node_modules)
  'roslyn-language-server', -- C# / .NET; managed by lua/plugins/roslyn.lua (not the LSP servers table)
}

local formatters = {
  'stylua',
  'prettier',
  'csharpier',
}

local linters = {
  'markdownlint',
}

local ensure_installed = {}
vim.list_extend(ensure_installed, servers)
vim.list_extend(ensure_installed, formatters)
vim.list_extend(ensure_installed, linters)

return {
  {
    'mason-org/mason.nvim',
    ---@module 'mason.settings'
    ---@type MasonSettings
    ---@diagnostic disable-next-line: missing-fields
    opts = {},
  },
  {
    'WhoIsSethDaniel/mason-tool-installer.nvim',
    dependencies = { 'mason-org/mason.nvim' },
    config = function()
      require('mason-tool-installer').setup { ensure_installed = ensure_installed }
    end,
  },
}
