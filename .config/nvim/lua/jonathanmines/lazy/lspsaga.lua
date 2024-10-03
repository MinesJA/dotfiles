return {
  'nvimdev/lspsaga.nvim',
  config = function()
    require('lspsaga').setup({})
    vim.keymap.set('n', 'K', '<cmd>Lspsaga hover_doc')
  end,

  dependencies = {
      'nvim-treesitter/nvim-treesitter', -- optional
      'nvim-tree/nvim-web-devicons',     -- optional
  }
}
