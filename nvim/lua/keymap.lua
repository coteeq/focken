local M = {}

function M.setup()
    vim.g.mapleader = ' '
    vim.g.maplocalleader = ' '

    -- Don't lose focus
    vim.keymap.set("v", ">", ">gv")
    vim.keymap.set("v", "<", "<gv")

    vim.keymap.set(
        'n', '<C-h>', '<C-w><C-h>',
        { desc = 'Move focus to the left window' }
    )
    vim.keymap.set(
        'n', '<C-l>', '<C-w><C-l>',
        { desc = 'Move focus to the right window' }
    )
    vim.keymap.set(
        'n', '<C-j>', '<C-w><C-j>',
        { desc = 'Move focus to the lower window' }
    )
    vim.keymap.set(
        'n', '<C-k>', '<C-w><C-k>',
        { desc = 'Move focus to the upper window' }
    )

    vim.keymap.set(
        'n', '<Leader>f', 'viw"-y:%s/<C-r>-/<C-r>-/g<Left><Left>',
        { desc = 'Search word' }
    )
    vim.keymap.set(
        'v', '<Leader>f', '"-y:%s/<C-r>-/<C-r>-/g<Left><Left>',
        { desc = 'Search selection' }
    )

    vim.keymap.set(
        'v', '<Leader>y', '"+ygv',
        { desc = 'Copy to clipboard' }
    )

    vim.keymap.set(
        'n',
        '<Leader>c',
        function()
            vim.o.cmdheight = vim.o.cmdheight > 0 and 0 or 1
        end,
        { desc = "toggle cmdheight" }
    )
end

return M
