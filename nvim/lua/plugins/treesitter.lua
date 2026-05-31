-- Treesitter parses source code into structured syntax trees, enabling
-- accurate highlighting, indentation, folding, and structural navigation.
-- Parsers are per-language `.so` binaries installed on demand.
--
-- Useful commands:
--   :TSUpdate         update / install missing parsers
--   :InspectTree      open a live syntax tree of the current buffer
--   :Inspect          show highlight groups at the cursor

return {
  'nvim-treesitter/nvim-treesitter',
  lazy = false, -- must be ready before the first file opens
  build = ':TSUpdate',
  branch = 'main',
  config = function()
    -- Parsers installed up front so highlighting, indentation, and the
    -- embedded code blocks inside LSP hover popups work immediately on the
    -- first file opened of each filetype (the FileType autocmd below can
    -- still install anything else on demand).
    local parsers = {
      'bash', 'c', 'c_sharp', 'css', 'diff', 'gitcommit', 'gitignore',
      'html', 'javascript', 'jsdoc', 'json', 'lua', 'luadoc',
      'markdown', 'markdown_inline', 'query', 'regex', 'scss', 'toml',
      'tsx', 'typescript', 'vim', 'vimdoc', 'yaml',
    }
    require('nvim-treesitter').install(parsers)

    ---@param buf integer
    ---@param language string
    local function treesitter_try_attach(buf, language)
      if not vim.treesitter.language.add(language) then return end
      vim.treesitter.start(buf, language)

      -- Treesitter-based indentation when the parser ships an indents query.
      local has_indent_query = vim.treesitter.query.get(language, 'indents') ~= nil
      if has_indent_query then vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()" end
    end

    -- On every new filetype: install the parser if needed, then attach.
    local available_parsers = require('nvim-treesitter').get_available()
    vim.api.nvim_create_autocmd('FileType', {
      callback = function(args)
        local buf, filetype = args.buf, args.match
        local language = vim.treesitter.language.get_lang(filetype)
        if not language then return end

        local installed_parsers = require('nvim-treesitter').get_installed 'parsers'

        if vim.tbl_contains(installed_parsers, language) then
          treesitter_try_attach(buf, language)
        elseif vim.tbl_contains(available_parsers, language) then
          require('nvim-treesitter').install(language):await(function() treesitter_try_attach(buf, language) end)
        else
          -- Parser may exist manually outside nvim-treesitter's registry.
          treesitter_try_attach(buf, language)
        end
      end,
    })
  end,
}
