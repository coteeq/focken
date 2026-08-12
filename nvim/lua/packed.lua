local M = {}

function M.setup()
    local hooks = function(ev)
        local name, kind = ev.data.spec.name, ev.data.kind
        vim.print("Hooked on " .. name .. " (kind = " .. kind .. ")")
        if name == 'telescope-fzf-native.nvim' and (kind == 'install' or kind == 'update') then
            vim.print("Trying to load fzf")
            vim.system(
                { 'make' },
                { cwd = ev.data.path }
            ):wait()
            vim.print("Loaded fzf")
        end
    end

    vim.api.nvim_create_autocmd('PackChanged', { callback = hooks })

    vim.pack.add({
        "https://github.com/j-hui/fidget.nvim",
        "https://codeberg.org/andyg/leap.nvim.git",
        "https://github.com/serhez/bento.nvim",
        "https://github.com/karb94/neoscroll.nvim",
        "https://github.com/nvim-mini/mini.nvim",

        "https://github.com/nvim-lua/plenary.nvim",
        "https://github.com/nvim-telescope/telescope.nvim",
        "https://github.com/nvim-telescope/telescope-fzf-native.nvim",


        {
            src = "https://github.com/petertriho/nvim-scrollbar",
            version = "f8e87b96cd6362ef8579be456afee3b38fd7e2a8",
        },

        {
            src = "https://github.com/nvim-tree/nvim-tree.lua",
            version = "b3772adec8db61ba9098c5624a0823a77be3a23d",
        },
        {
            src = "https://github.com/lewis6991/gitsigns.nvim",
            version = "a462f416e2ce4744531c6256252dee99a7d34a83",
        },
        {
            src = "https://github.com/nvim-treesitter/nvim-treesitter",
            version = "4916d6592ede8c07973490d9322f187e07dfefac",
        },
        {
            src = "https://github.com/nvim-treesitter/nvim-treesitter-textobjects",
            version = "93d60a475f0b08a8eceb99255863977d3a25f310",
        },

        {
            src = "https://github.com/saghen/blink.cmp",
            version = "78336bc89ee5365633bcf754d93df01678b5c08f", -- v1.10.2
        },

        {
            src = "https://github.com/mrcjkb/rustaceanvim",
            commit = "bc391bbb8db0dbf3e3e9fe8f9f03112ecbab7463",
        },

    })

    -- Setup lazy.nvim
    require("fidget").setup({
        notification = {
            override_vim_notify = true,
        },
    })
    require("leap").setup({})
    require("bento").setup({
        ui = {
            floating = {
                max_rendered_buffers = 20
            }
        }
    })
    require("neoscroll").setup({})
    require("mini.basics").setup({
        mappings = {
            option_toggle_prefix = "", -- disable
        },
        autocommands = {
            basic = false,
        },
    })
    require("mini.cmdline").setup({
        autocorrect = { enable = false },
        autocomplete = { delay = 1000 },
    })
    require("mini.sessions").setup({})
    require("mini.pick").setup({})
    require("mini.statusline").setup({})

    require("telescope").setup({
        defaults = {
            border = {},
            borderchars = { " ", " ", " ", " ", " ", " ", " ", " " },
            layout_config = {
                horizontal = {
                    prompt_position = "top",
                },
            },
        },
    })
    require("telescope").load_extension('fzf')

    require("nvim-tree").setup({})

    require("scrollbar").setup({})

    -- vim.print({
    --     dependencies = "nvim-treesitter/nvim-treesitter",
    --     require("nvim-treesitter-textobjects").setup({
    --       textobjects = {
    --         select = {
    --           enable = true,
    --           lookahead = true,
    --           keymaps = {
    --             ["af"] = "@function.outer",
    --             ["if"] = "@function.inner",
    --             ["ac"] = "@class.outer",
    --             ["ic"] = "@class.inner",
    --             ["aa"] = "@parameter.outer",
    --             ["ia"] = "@parameter.inner",
    --           },
    --         },
    --       },
    --     })
    -- })

    local filetypes = { 'bash', 'c', 'diff', 'html', 'lua', 'luadoc', 'markdown', 'markdown_inline', 'query', 'vim', 'vimdoc' }
    require('nvim-treesitter').install(filetypes)
    vim.api.nvim_create_autocmd('FileType', {
        pattern = filetypes,
        callback = function() vim.treesitter.start() end,
    })
    local miniclue = require('mini.clue')
    miniclue.setup({
        triggers = {
            { mode = { 'n', 'x' }, keys = '<Leader>' },
            { mode = 'n', keys = 'g' },
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

    require("blink.cmp").setup{}
end

return M
