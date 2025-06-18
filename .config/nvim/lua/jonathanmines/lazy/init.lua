return {
    {
        "nvim-lua/plenary.nvim"
    },

   "eandrju/cellular-automaton.nvim",
    {
        "iamcco/markdown-preview.nvim",
        cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
        ft = { "markdown" },
        build = function() vim.fn["mkdp#util#install"]() end,
        config = function()
          vim.cmd([[ do FileType]])
          vim.cmd([[
            function OpenMarkdownPreview (url)
              let cmd = "chromium --new-window " . shellescape(a:url) . " &"
              silent call system(cmd)
            endfunction
          ]])
          vim.g.mkdp_browserfunc = "OpenMarkdownPreview"
        end,
    },
    {
        "pmizio/typescript-tools.nvim",
        dependencies = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
        opts = {},
    },

    --{
    --  "ray-x/lsp_signature.nvim",
    --  event = "VeryLazy",
    --  opts = {},
    --  config = function(_, opts)

    --    vim.keymap.set({ 'n' }, '<Leader>k', function()
    --      vim.lsp.buf.signature_help()
    --    end, { silent = true, noremap = true, desc = 'toggle signature' })
    --  end
    --}
    --"onsails/lspkind-nvim",
    --{
     -- "lazyvim.plugins.extras.formatting.prettier"
    --}
}
