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

    local function pack(url, version)
        return {
            src = url,
            version = version
        }
    end

    local function gh(repo, version) return pack("https://github.com/" .. repo, version) end
    local function cb(repo, version) return pack("https://codeberg.org/" .. repo, version) end

    vim.pack.add({
        gh("j-hui/fidget.nvim"),
        cb("andyg/leap.nvim.git"),
        gh("serhez/bento.nvim"),
        gh("karb94/neoscroll.nvim"),
        gh("nvim-mini/mini.nvim"),

        gh("nvim-lua/plenary.nvim"),
        gh("nvim-telescope/telescope.nvim"),
        gh("nvim-telescope/telescope-fzf-native.nvim"),

        gh("petertriho/nvim-scrollbar", "f8e87b96cd6362ef8579be456afee3b38fd7e2a8"),

        gh("nvim-tree/nvim-tree.lua", "b3772adec8db61ba9098c5624a0823a77be3a23d"),
        gh("lewis6991/gitsigns.nvim", "a462f416e2ce4744531c6256252dee99a7d34a83"),
        gh("nvim-treesitter/nvim-treesitter", "4916d6592ede8c07973490d9322f187e07dfefac"),
        gh("nvim-treesitter/nvim-treesitter-textobjects", "93d60a475f0b08a8eceb99255863977d3a25f310"),

        gh("saghen/blink.cmp", "78336bc89ee5365633bcf754d93df01678b5c08f"), -- v1.10.2

        gh("mrcjkb/rustaceanvim", "bc391bbb8db0dbf3e3e9fe8f9f03112ecbab7463"),

        gh("oskarnurm/koda.nvim", "a7da3ced59eadafbda6eb4d7f7e2a6a3d9ecf858"),
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

    require("telescope").setup({})
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

    local filetypes = {
        'bash',
        'c',
        'diff',
        'html',
        'lua',
        'luadoc',
        'markdown',
        'markdown_inline',
        'query',
        'vim',
        'vimdoc'
    }
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

    require("koda").setup({
        theme = { dark = "moss", light = "light" }
    })
    vim.cmd("colorscheme koda")
end

return M
