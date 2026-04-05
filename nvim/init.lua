vim.g.clipboard = 'osc52'

vim.o.mouse = 'a'
vim.o.number = true
vim.o.expandtab = true
vim.o.shiftwidth = 4
vim.o.modeline = false

vim.g.mapleader = ' '
vim.g.maplocalleader = ' '
vim.cmd.colorscheme("default")

-- vim.o.showmode = false

-- indent wrapped line to the same level.
vim.o.breakindent = true

-- Minimal number of screen lines to keep above and below the cursor.
vim.o.scrolloff = 2

vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
vim.keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })

-- don't lose selection
vim.keymap.set("v", ">", ">gv")
vim.keymap.set("v", "<", "<gv")

vim.o.ignorecase = true
vim.o.smartcase = true

vim.o.mousescroll = 'ver:3,hor:2'
vim.o.foldmethod = 'marker'

vim.o.wrap = true

-- lazy bootstrap {{{
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

-- }}}

vim.keymap.set({'n', 'x', 'o'}, 's', '<Plug>(leap)')
nvcmd = require("cmd")
nvcmd.map({'n', 'x', 'o'}, '<Leader>c', "toggle_cmdline")

-- Setup lazy.nvim
require("lazy").setup("extralazy", {
  -- automatically check for plugin updates
  checker = { enabled = true },
})

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
