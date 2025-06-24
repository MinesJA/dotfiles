return {
  'nvimdev/lspsaga.nvim',
  config = function()
    require('lspsaga').setup({
      lightbulb = {
        enable = false
      }
    })
    vim.keymap.set('n', 'K', '<cmd>Lspsaga hover_doc')
    vim.keymap.set('n', '<leader>k', '<cmd>Lspsaga go_to_type_definition')
  end,

  dependencies = {
      'nvim-treesitter/nvim-treesitter', -- optional
      'nvim-tree/nvim-web-devicons',     -- optional
  }
}