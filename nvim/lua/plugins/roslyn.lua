-- C# / .NET via Microsoft's official Roslyn language server.
-- roslyn.nvim wraps the non-standard protocol extensions (solution loading,
-- multi-project orchestration) so it integrates cleanly with Neovim's LSP.
--
-- It auto-detects the nearest .sln when you open a .cs file; if multiple
-- exist you can pick one via `:Roslyn target`.

return {
  'seblyng/roslyn.nvim',
  ft = { 'cs' },
  ---@module 'roslyn.config'
  ---@type RoslynNvimConfig
  opts = {
    -- Use the Roslyn binary installed via Mason (the `roslyn` package).
    -- roslyn.nvim finds it automatically; this is just a placeholder for
    -- any per-project overrides you might want later.
  },
}
