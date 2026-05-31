-- LSP (Language Server Protocol): IDE-like features via external server
-- binaries. Configuration only — installation is centralized in mason.lua.
-- fidget shows server progress in the corner.
--
-- To enable a new language: add an entry to the `servers` table here AND
-- add its name to the `servers` list in lua/plugins/mason.lua so Mason
-- installs it.

return {
  'neovim/nvim-lspconfig',
  dependencies = {
    -- Translates between Mason package names and lspconfig server names.
    'mason-org/mason-lspconfig.nvim',
    -- Progress notifications widget for LSP activity.
    { 'j-hui/fidget.nvim', opts = {} },
  },
  config = function()
    -- [[ LspAttach — runs per buffer when a language server attaches ]]
    -- Registers buffer-local keymaps and optional features (document
    -- highlighting, inlay hints) based on what the server supports.
    vim.api.nvim_create_autocmd('LspAttach', {
      group = vim.api.nvim_create_augroup('kickstart-lsp-attach', { clear = true }),
      callback = function(event)
        -- Helper: scopes keymaps to this buffer and prefixes the desc.
        local map = function(keys, func, desc, mode)
          mode = mode or 'n'
          vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
        end

        -- Rename the symbol under the cursor across the whole project.
        map('grn', vim.lsp.buf.rename, '[R]e[n]ame')

        -- Show available code actions / quick fixes (n + visual).
        map('gra', vim.lsp.buf.code_action, '[G]oto Code [A]ction', { 'n', 'x' })

        -- WARN: declaration ≠ definition (use grd from telescope.lua for definition).
        map('grD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')

        local client = vim.lsp.get_client_by_id(event.data.client_id)

        -- Highlight other usages of the symbol under the cursor when idle.
        if client and client:supports_method('textDocument/documentHighlight', event.buf) then
          local highlight_augroup = vim.api.nvim_create_augroup('kickstart-lsp-highlight', { clear = false })
          vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
            buffer = event.buf,
            group = highlight_augroup,
            callback = vim.lsp.buf.document_highlight,
          })

          vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
            buffer = event.buf,
            group = highlight_augroup,
            callback = vim.lsp.buf.clear_references,
          })

          vim.api.nvim_create_autocmd('LspDetach', {
            group = vim.api.nvim_create_augroup('kickstart-lsp-detach', { clear = true }),
            callback = function(event2)
              vim.lsp.buf.clear_references()
              vim.api.nvim_clear_autocmds { group = 'kickstart-lsp-highlight', buffer = event2.buf }
            end,
          })
        end

        -- Toggle inlay hints (inferred types / parameter names as virtual text).
        if client and client:supports_method('textDocument/inlayHint', event.buf) then
          map('<leader>th', function()
            vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { bufnr = event.buf })
          end, '[T]oggle Inlay [H]ints')
        end
      end,
    })

    -- [[ Per-server configuration ]]
    -- Keys here are server names (as nvim-lspconfig knows them). Values
    -- override the defaults. To enable a new language, also add its name
    -- to the `servers` list in lua/plugins/mason.lua.
    ---@type table<string, vim.lsp.Config>
    local servers = {
      ts_ls = {}, -- TypeScript / JavaScript

      -- ESLint as an LSP — uses your project's local eslint from node_modules,
      -- which avoids the version mismatches `eslint_d` was causing.
      -- The Mason package name is `eslint-lsp`; lspconfig calls it just `eslint`.
      eslint = {},

      -- Special handling so lua_ls knows about Neovim's runtime when editing this config.
      lua_ls = {
        on_init = function(client)
          client.server_capabilities.documentFormattingProvider = false -- stylua does formatting

          if client.workspace_folders then
            local path = client.workspace_folders[1].name
            if path ~= vim.fn.stdpath 'config'
              and (vim.uv.fs_stat(path .. '/.luarc.json') or vim.uv.fs_stat(path .. '/.luarc.jsonc')) then
              return -- project has its own .luarc; don't override
            end
          end

          client.config.settings.Lua = vim.tbl_deep_extend('force', client.config.settings.Lua, {
            runtime = {
              version = 'LuaJIT',
              path = { 'lua/?.lua', 'lua/?/init.lua' },
            },
            workspace = {
              checkThirdParty = false,
              library = vim.tbl_extend('force', vim.api.nvim_get_runtime_file('', true), {
                '${3rd}/luv/library',
                '${3rd}/busted/library',
              }),
            },
          })
        end,
        ---@type lspconfig.settings.lua_ls
        settings = {
          Lua = {
            format = { enable = false }, -- stylua does formatting
          },
        },
      },
    }

    -- [[ Register + enable each server ]]
    for name, server in pairs(servers) do
      vim.lsp.config(name, server)
      vim.lsp.enable(name)
    end
  end,
}
