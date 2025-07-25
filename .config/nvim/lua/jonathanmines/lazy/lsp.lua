local function organize_imports()
  local params = {
    command = "_typescript.organizeImports",
    arguments = {vim.api.nvim_buf_get_name(0)},
    title = ""
  }
  vim.lsp.buf.execute_command(params)
end

return {
    "neovim/nvim-lspconfig",
    dependencies = {
        "williamboman/mason.nvim",
        "williamboman/mason-lspconfig.nvim",
        "hrsh7th/cmp-nvim-lsp",
        "hrsh7th/cmp-buffer",
        "hrsh7th/cmp-path",
        "hrsh7th/cmp-cmdline",
        "hrsh7th/nvim-cmp",
        "L3MON4D3/LuaSnip",
        "saadparwaiz1/cmp_luasnip",
        "j-hui/fidget.nvim",
    },

    config = function()
        local cmp = require('cmp')
        local cmp_lsp = require("cmp_nvim_lsp")
        local capabilities = vim.tbl_deep_extend(
            "force",
            {},
            vim.lsp.protocol.make_client_capabilities(),
            cmp_lsp.default_capabilities()
        )

        require("fidget").setup({})
        require("mason").setup()
        require("mason-lspconfig").setup({
            ensure_installed = {
                "lua_ls",
                "rust_analyzer",
                "pyright",  -- Add Python LSP
            },
            handlers = {
                function(server_name) -- default handler (optional)
                    require("lspconfig")[server_name].setup {
                        capabilities = capabilities
                    }
                end,

                --["tsserver"] = function()
                --  local lspconfig = require("lspconfig")
                --  lspconfig.tsserver.setup {
                --    capabilities = capabilities,
                --    commands = {
                --      OrganizeImports = {
                --        organize_imports,
                --        description = "Organize Imports"
                --      }
                --    }
                --  }
                --end,

                ["ruby_lsp"] = function()
                  local lspconfig = require("lspconfig")
                  lspconfig.ruby_lsp.setup {
                    -- Use rbenv shim for ruby-lsp
                    cmd = { os.getenv("HOME") .. "/.rbenv/shims/ruby-lsp" },
                    capabilities = capabilities
                  }
                end,

                ["pyright"] = function()
                  local lspconfig = require("lspconfig")
                  lspconfig.pyright.setup {
                    settings = {
                      python = {
                        pythonPath = "/Users/jonathan.mines/firstup/taskmaster/py-311-venv/bin/python",
                        analysis = {
                          autoSearchPaths = true,
                          diagnosticMode = "workspace",
                          useLibraryCodeForTypes = true,
                        },
                      },
                    },
                  }
                end,

                ["rust_analyzer"] = function()
                    local lspconfig = require("lspconfig")
                    local util = require("lspconfig.util")
                    lspconfig.rust_analyzer.setup {
                        capabilities = capabilities,
                        -- Explicitly set root directory detection
                        root_dir = util.root_pattern("Cargo.toml", "rust-project.json"),
                        -- Ensure it starts with the Mason-installed binary
                        cmd = { vim.fn.expand("~/.local/share/nvim/mason/bin/rust-analyzer") },
                        filetypes = { "rust" },
                        settings = {
                            ["rust-analyzer"] = {
                                cargo = {
                                    allFeatures = true,
                                },
                                checkOnSave = {
                                    command = "clippy",
                                },
                            },
                        },
                    }
                end,

                ["lua_ls"] = function()
                    local lspconfig = require("lspconfig")
                    lspconfig.lua_ls.setup {
                        capabilities = capabilities,
                        settings = {
                            Lua = {
				                runtime = { version = "Lua 5.1" },
                                diagnostics = {
                                    globals = { "vim", "it", "describe", "before_each", "after_each" },
                                }
                            }
                        }
                    }
                end,
            }
        })

        local cmp_select = { behavior = cmp.SelectBehavior.Select }

        cmp.setup({
            snippet = {
                expand = function(args)
                    require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
                end,
            },
            mapping = cmp.mapping.preset.insert({
                ['<C-p>'] = cmp.mapping.select_prev_item(cmp_select),
                ['<C-n>'] = cmp.mapping.select_next_item(cmp_select),
                ['<C-y>'] = cmp.mapping.confirm({ select = true }),
                ["<C-Space>"] = cmp.mapping.complete(),
            }),
            sources = cmp.config.sources({
                { name = 'nvim_lsp' },
                { name = 'luasnip' }, -- For luasnip users.
            }, {
                { name = 'buffer' },
            })
        })

        vim.diagnostic.config({
            -- update_in_insert = true,
            float = {
                focusable = false,
                style = "minimal",
                border = "rounded",
                source = "always",
                header = "",
                prefix = "",
            },
        })
    end
}
