local M = {}

local function clue_setup()
  local miniclue = require('mini.clue')
  miniclue.setup({
    triggers = {
      { mode = { 'n', 'x', 'o' }, keys = 'g' },
      { mode = { 'n', 'x', 'o' }, keys = '<Leader>' },
    },
    clues = {
      miniclue.gen_clues.g(),
    },
    window = {
      delay = 200,
      config = {
        width = 'auto',
        anchor = 'SE',
        row = 'auto',
        col = 'auto',
      },
    },
  })
end


return {
  "nvim-mini/mini.nvim",
  config = function()
    require("mini.basics").setup({
      mappings = {
        option_toggle_prefix = "", -- disable
      },
      autocommands = {
        basic = false,
      },
    })

    clue_setup()

    require("mini.cmdline").setup({
      autocorrect = { enable = false },
      autocomplete = { delay = 1000 },
    })

    require("mini.sessions").setup()
    require("mini.pick").setup()
    require("mini.statusline").setup({})
    vim.notify("mini init")

  end
}
