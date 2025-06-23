vim.g.mapleader = " "
vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)

-- When highlighted move a block up and down
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

-- Takes line below you and appends to line you're on with a space
vim.keymap.set("n", "J", "mzJ`z")

vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

-- greatest remap ever
vim.keymap.set("x", "<leader>p", [["_dP]])

-- next greatest remap ever : asbjornHaland
vim.keymap.set({"n", "v"}, "<leader>y", [["+y]])
vim.keymap.set("n", "<leader>Y", [["+Y]])


vim.keymap.set({"n", "v"}, "<leader>d", [["_d]])

-- This is going to get me cancelled
vim.keymap.set("i", "<C-c>", "<Esc>")

vim.keymap.set("n", "<C-f>", "<cmd>silent !tmux neww tmux-sessionizer<CR>")
vim.keymap.set("n", "<leader>f", vim.lsp.buf.format)

vim.keymap.set("n", "<C-k>", "<cmd>cnext<CR>zz")
vim.keymap.set("n", "<C-j>", "<cmd>cprev<CR>zz")
vim.keymap.set("n", "<leader>k", "<cmd>lnext<CR>zz")
vim.keymap.set("n", "<leader>j", "<cmd>lprev<CR>zz")

-- Format whole file and go back to cursor
vim.keymap.set("n", "<leader>ft", "[gg=G'']")


vim.keymap.set("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])
vim.keymap.set("n", "<leader>x", "<cmd>!chmod +x %<CR>", { silent = true })

vim.keymap.set("n", "<leader>vpp", "<cmd>e ~/.dotfiles/nvim/.config/nvim/lua/theprimeagen/packer.lua<CR>");
vim.keymap.set("n", "<leader>mr", "<cmd>CellularAutomaton make_it_rain<CR>");

vim.keymap.set("n", "<leader><leader>", function()
    vim.cmd("so")
end)

vim.keymap.set("n", "<leader>e", ":w | :!zsh 'rubocop -a'")

-- Copilot
vim.keymap.set("n", "<leader>cca", ":CopilotChatAgent<CR>", { desc = "Start Copilot Agent" })

-- Open URL under cursor
vim.keymap.set("n", "gx", function()
    local url = vim.fn.expand("<cWORD>")
    -- Try to extract URL from the current line if the word doesn't look like a URL
    if not url:match("^https?://") then
        local line = vim.fn.getline(".")
        -- Match URLs in the current line (improved regex for better URL matching)
        local matched_url = line:match("https?://[%w-_%.%?%.:/%+=&%#%%~!%$'%(%)%*,;@]+")
        if matched_url then
            url = matched_url
        end
    end
    
    if url:match("^https?://") then
        vim.fn.jobstart({"open", url}, {detach = true})
        print("Opening URL: " .. url)
    else
        print("No URL found under cursor")
    end
end, { desc = "Open URL under cursor" })

-- Search selected text in browser
vim.keymap.set("v", "gx", function()
    -- Get the visual selection
    local start_pos = vim.fn.getpos("'<")
    local end_pos = vim.fn.getpos("'>")
    local lines = vim.fn.getline(start_pos[2], end_pos[2])
    
    if #lines == 0 then
        return
    end
    
    -- Handle single line selection
    if #lines == 1 then
        lines[1] = string.sub(lines[1], start_pos[3], end_pos[3])
    else
        -- Handle multi-line selection
        lines[1] = string.sub(lines[1], start_pos[3])
        lines[#lines] = string.sub(lines[#lines], 1, end_pos[3])
    end
    
    local text = table.concat(lines, " ")
    
    -- Check if the selection is a URL
    if text:match("^https?://") then
        vim.fn.jobstart({"open", text}, {detach = true})
        print("Opening URL: " .. text)
    else
        -- Otherwise, search for the text in the default browser
        local search_url = "https://www.google.com/search?q=" .. vim.fn.escape(text, " ")
        vim.fn.jobstart({"open", search_url}, {detach = true})
        print("Searching for: " .. text)
    end
end, { desc = "Open URL or search selected text" })
