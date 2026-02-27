vim.g.clipboard = 'osc52'
vim.o.mouse = 'a'
vim.o.number = true

vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- vim.o.showmode = false

-- indent wrapped line to the same level.
vim.o.breakindent = true

-- Minimal number of screen lines to keep above and below the cursor.
vim.o.scrolloff = 2

vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
vim.keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })

vim.o.ignorecase = true
vim.o.smartcase = true

vim.o.mousescroll = 'ver:3,hor:2'
vim.o.foldmethod = 'marker'

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

-- Make sure to setup `mapleader` and `maplocalleader` before
-- loading lazy.nvim so that mappings are correct.

-- Setup lazy.nvim
require("lazy").setup({
  {
    "j-hui/fidget.nvim",
    opts = {
      notification = {
        override_vim_notify = true,
      },
    },
  },
  { url = "https://codeberg.org/andyg/leap.nvim.git", opts = {} },
  { "serhez/bento.nvim", opts = { ui = { floating = { max_rendered_buffers = 20 } } } },
  
  { "karb94/neoscroll.nvim", opts = {} },
  {
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

      local miniclue = require('mini.clue')

      miniclue.setup({
        triggers = {
          { mode = 'n', keys = 'g' },
        },
        clues = {
          miniclue.gen_clues.g(),
        },
        window = {
          delay = 200,
        },
      })

      require("mini.cmdline").setup({
        autocorrect = { enable = false },
	autocomplete = { delay = 1000 },
      })

      require("mini.sessions").setup()

      require("mini.pick").setup()

      require("mini.statusline").setup({

      })

    end
  },
  {
    'nvim-telescope/telescope.nvim',
    version = '*',
    dependencies = {
        'nvim-lua/plenary.nvim',
        -- optional but recommended
        { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
    },
  },
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

vim.keymap.set({'n', 'x', 'o'}, 's', '<Plug>(leap)')


