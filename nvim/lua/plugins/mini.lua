-- mini.nvim — a collection of small independent modules from one repo.
-- We enable three: better text objects, surround manipulation, and the
-- statusline. Each module is activated by its own setup() call.

return {
  'nvim-mini/mini.nvim',
  config = function()
    -- [[ mini.ai — smarter around/inside text objects ]]
    -- Examples:
    --   va)  - [v]isually select [a]round [)]paren
    --   ci'  - [c]hange [i]nside [']quote
    --   yiiq - [y]ank [i]nside [i]+1 [q]uote (next quoted region)
    require('mini.ai').setup {
      -- Avoid conflicts with Neovim 0.12's built-in incremental selection.
      mappings = {
        around_next = 'aa',
        inside_next = 'ii',
      },
      n_lines = 500,
    }

    -- [[ mini.surround — add/delete/replace surrounding chars ]]
    -- Examples:
    --   saiw)  - [s]urround [a]dd [i]nner [w]ord with [)]
    --   sd'    - [s]urround [d]elete [']quotes
    --   sr)'   - [s]urround [r]eplace [)] with [']
    require('mini.surround').setup()

    -- [[ mini.statusline — the bar at the bottom of the screen ]]
    local statusline = require 'mini.statusline'
    statusline.setup { use_icons = vim.g.have_nerd_font }

    -- Override the cursor-location section to show line:col in a tighter format.
    ---@diagnostic disable-next-line: duplicate-set-field
    statusline.section_location = function() return '%2l:%-2v' end
  end,
}
