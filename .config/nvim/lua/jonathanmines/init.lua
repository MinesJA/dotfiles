require("jonathanmines.set")
require("jonathanmines.remap")
require("jonathanmines.lazy_init")

local augroup = vim.api.nvim_create_augroup
local JonathanMinesGroup = augroup('JonathanMines', {})

local autocmd = vim.api.nvim_create_autocmd
local yank_group = augroup('HighlightYank', {})

function R(name)
    require("plenary.reload").reload_module(name)
end

vim.filetype.add({
    extension = {
        templ = 'templ',
    }
})

autocmd('TextYankPost', {
    group = yank_group,
    pattern = '*',
    callback = function()
        vim.highlight.on_yank({
            higroup = 'IncSearch',
            timeout = 40,
        })
    end,
})

autocmd({"BufWritePre"}, {
    group = JonathanMinesGroup,
    pattern = "*",
    command = [[%s/\s\+$//e]],
})

autocmd("BufWritePre", {
  group = vim.api.nvim_create_augroup("TS_add_missing_imports", { clear = true }),
  desc = "TS_add_missing_imports",
  pattern = { "*.ts", "*.tsx", "*.js", "*.jsx" },
  callback = function()
    vim.cmd([[TSToolsAddMissingImports]])
    vim.cmd("write")
  end,
})

-- Ensure rust-analyzer starts for Rust files
autocmd('FileType', {
    group = JonathanMinesGroup,
    pattern = 'rust',
    callback = function()
        -- Small delay to ensure buffer is fully loaded
        vim.defer_fn(function()
            -- Check if rust-analyzer is attached
            local clients = vim.lsp.get_active_clients({ bufnr = 0 })
            local has_rust_analyzer = false
            for _, client in ipairs(clients) do
                if client.name == "rust_analyzer" then
                    has_rust_analyzer = true
                    break
                end
            end
            
            -- If not attached, try to start it
            if not has_rust_analyzer then
                vim.cmd('LspStart rust_analyzer')
            end
        end, 100)
    end
})

autocmd('LspAttach', {
    group = JonathanMinesGroup,
    callback = function(e)
        local opts = { buffer = e.buf }
        vim.keymap.set("n", "gd", function() vim.lsp.buf.definition() end, opts)
        vim.keymap.set("n", "K", function() vim.lsp.buf.hover() end, opts)
        vim.keymap.set("n", "<leader>vws", function() vim.lsp.buf.workspace_symbol() end, opts)
        vim.keymap.set("n", "<leader>vd", function() vim.diagnostic.open_float() end, opts)
        vim.keymap.set("n", "<leader>vca", function() vim.lsp.buf.code_action() end, opts)
        vim.keymap.set("n", "<leader>vrr", function() vim.lsp.buf.references() end, opts)
        vim.keymap.set("n", "<leader>vrn", function() vim.lsp.buf.rename() end, opts)
        vim.keymap.set("i", "<C-h>", function() vim.lsp.buf.signature_help() end, opts)
        vim.keymap.set("n", "[d", function() vim.diagnostic.goto_next() end, opts)
        vim.keymap.set("n", "]d", function() vim.diagnostic.goto_prev() end, opts)
    end
})

vim.g.netrw_browse_split = 0
vim.g.netrw_banner = 0
vim.g.netrw_winsize = 25

-- Command to manually restart rust-analyzer
vim.api.nvim_create_user_command('RustAnalyzerRestart', function()
    -- Stop all rust-analyzer clients
    local clients = vim.lsp.get_active_clients()
    for _, client in ipairs(clients) do
        if client.name == "rust_analyzer" then
            vim.lsp.stop_client(client.id)
        end
    end
    
    -- Restart for current buffer if it's a Rust file
    if vim.bo.filetype == "rust" then
        vim.defer_fn(function()
            vim.cmd('edit')  -- Reload the buffer to trigger FileType autocmd
        end, 100)
    end
end, {})
