-- Debug module for rust-analyzer issues
local M = {}

function M.debug_info()
    print("=== Rust LSP Debug Info ===")
    print("Current file:", vim.fn.expand('%:p'))
    print("File type:", vim.bo.filetype)
    print("Working directory:", vim.fn.getcwd())
    
    -- Check for Cargo.toml
    local cargo_toml = vim.fn.findfile("Cargo.toml", ".;")
    print("\nCargo.toml found at:", cargo_toml ~= "" and vim.fn.fnamemodify(cargo_toml, ":p") or "NOT FOUND")
    
    -- List all LSP clients
    print("\nAll active LSP clients:")
    local all_clients = vim.lsp.get_active_clients()
    for _, client in ipairs(all_clients) do
        print(string.format("  - %s (id: %d, root: %s)", 
            client.name, 
            client.id, 
            client.config.root_dir or "none"))
    end
    
    -- List LSP clients for current buffer
    print("\nLSP clients for current buffer:")
    local buf_clients = vim.lsp.get_active_clients({ bufnr = 0 })
    if #buf_clients == 0 then
        print("  NONE")
    else
        for _, client in ipairs(buf_clients) do
            print(string.format("  - %s (id: %d)", client.name, client.id))
        end
    end
    
    -- Check rust-analyzer config
    local has_lspconfig, lspconfig = pcall(require, 'lspconfig')
    if has_lspconfig and lspconfig.rust_analyzer then
        print("\nrust-analyzer config:")
        print("  Command:", vim.inspect(lspconfig.rust_analyzer.cmd))
        local root_dir = lspconfig.rust_analyzer.get_root_dir(vim.fn.expand('%:p'))
        print("  Detected root:", root_dir or "NONE")
    end
    
    -- Check if rust-analyzer binary exists
    local rust_analyzer_path = vim.fn.expand("~/.local/share/nvim/mason/bin/rust-analyzer")
    print("\nrust-analyzer binary:")
    print("  Path:", rust_analyzer_path)
    print("  Exists:", vim.fn.executable(rust_analyzer_path) == 1 and "YES" or "NO")
end

-- Command to run the debug
vim.api.nvim_create_user_command('RustLspDebug', M.debug_info, {})

return M