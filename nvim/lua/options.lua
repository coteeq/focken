local M = {}

function M.setup()

    vim.g.clipboard = 'osc52'
    vim.o.mouse = 'a'
    vim.o.number = true
    vim.o.expandtab = true
    vim.o.shiftwidth = 4
    vim.o.modeline = false
    vim.o.wrap = true

    -- indent wrapped line to the same level.
    vim.o.breakindent = true

    -- Minimal number of screen lines to keep above and below the cursor.
    vim.o.scrolloff = 2

    vim.o.ignorecase = true
    vim.o.smartcase = true

    -- Does it belong here?
    vim.o.mousescroll = 'ver:3,hor:2'
    vim.o.foldmethod = 'marker'
end

return M
