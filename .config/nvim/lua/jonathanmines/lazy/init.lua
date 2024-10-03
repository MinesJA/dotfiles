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

    {
      "ray-x/lsp_signature.nvim",
      event = "VeryLazy",
      opts = {},
      config = function(_, opts)

        vim.keymap.set({ 'n' }, '<Leader>k', function()
          vim.lsp.buf.signature_help()
        end, { silent = true, noremap = true, desc = 'toggle signature' })
      end
    }
    --"onsails/lspkind-nvim",
    --{
     -- "lazyvim.plugins.extras.formatting.prettier"
    --}
}
