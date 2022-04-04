vim.opt.fillchars = { vert = ' ' }
vim.opt.mouse = 'a'
vim.opt.backupcopy = 'yes'
vim.opt.undolevels = 1000
vim.opt.splitright = true
vim.opt.splitbelow = true
vim.opt.showmatch = true
vim.opt.ignorecase = true
vim.opt.hlsearch = true
vim.opt.smartcase = true
vim.opt.errorbells = false
vim.opt.title = true
vim.opt.lazyredraw = true
vim.opt.encoding = 'UTF-8'
vim.opt.fileformat = 'unix'
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.expandtab = true
vim.opt.shiftwidth = 4
vim.opt.number = true

vim.opt.termguicolors = true

vim.cmd [[color galaxian]]

require('plugins')
vim.g.limelight_conceal_ctermfg = 240
require'nvim-treesitter.configs'.setup {
    highlight = {
        enable = true,
        custom_captures = {
            -- Highlight the @foo.bar capture group with the "Identifier" highlight group.
            ["foo.bar"] = "Identifier",
        },
        -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
        -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
        -- Using this option may slow down your editor, and you may see some duplicate highlights.
        -- Instead of true it can also be a list of languages
        additional_vim_regex_highlighting = false,
    },
}
