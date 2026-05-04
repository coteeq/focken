vim.cmd.colorscheme("default")

require("options").setup()
require("keymap").setup()
require("packed").setup()

vim.api.nvim_create_autocmd(
  "OptionSet",
  {
    pattern = "background",
    desc = "Auto switch colorscheme on background change",
    callback = function()
      vim.notify("BG changed! New: " .. vim.o.background)
      -- apply_theme(vim.o.background)
    end
  }
)

vim.keymap.set({'n', 'x', 'o'}, 's', '<Plug>(leap)')
