return {
    {
        "nvim-lua/plenary.nvim",
        name = "plenary"
    },

   "eandrju/cellular-automaton.nvim",
    {
        "iamcco/markdown-preview.nvim",
        cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
        ft = { "markdown" },
        build = function() vim.fn["mkdp#util#install"]() end,
    },
    {
        "pmizio/typescript-tools.nvim",
        dependencies = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
        opts = {},
    },
    --{
     -- "lazyvim.plugins.extras.formatting.prettier"
    --}
}
