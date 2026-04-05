return {
  {
    "j-hui/fidget.nvim",
    opts = { notification = { override_vim_notify = true } }
  },
  { url = "https://codeberg.org/andyg/leap.nvim.git", opts = {} },
  { "serhez/bento.nvim", opts = { ui = { floating = { max_rendered_buffers = 20 } } } },
  { "karb94/neoscroll.nvim", opts = {} },
  { "lewis6991/gitsigns.nvim", commit = "a462f416e2ce4744531c6256252dee99a7d34a83", opts = {} },
  {
    "nvim-tree/nvim-tree.lua",
    commit = "b3772adec8db61ba9098c5624a0823a77be3a23d",
    opts = {},
  },
  {
    'nvim-telescope/telescope.nvim',
    version = '*',
    dependencies = {
        'nvim-lua/plenary.nvim',
        -- optional but recommended
        { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
    },
    opts = {
      defaults = {
        border = {},
        borderchars = { " ", " ", " ", " ", " ", " ", " ", " " },
        layout_config = {
          horizontal = {
            prompt_position = "top",
          },
        },
      },
    },
  },
  {
    "nvim-treesitter/nvim-treesitter-textobjects",
    dependencies = "nvim-treesitter/nvim-treesitter",
    opts = {
      textobjects = {
        select = {
          enable = true,
          lookahead = true,
          keymaps = {
            ["af"] = "@function.outer",
            ["if"] = "@function.inner",
            ["ac"] = "@class.outer",
            ["ic"] = "@class.inner",
            ["aa"] = "@parameter.outer",
            ["ia"] = "@parameter.inner",
          },
        },
      },
    },
  },
  { -- Highlight, edit, and navigate code
    'nvim-treesitter/nvim-treesitter',
    config = function()
      local filetypes = { 'bash', 'c', 'diff', 'html', 'lua', 'luadoc', 'markdown', 'markdown_inline', 'query', 'vim', 'vimdoc' }
      require('nvim-treesitter').install(filetypes)
      vim.api.nvim_create_autocmd('FileType', {
        pattern = filetypes,
        callback = function() vim.treesitter.start() end,
      })
    end,
  },
}
