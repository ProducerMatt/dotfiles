return {
  'ShinKage/idris2-nvim',
  requires = {'neovim/nvim-lspconfig', 'MunifTanjim/nui.nvim'},
  config = function ()
    require('idris2').setup({})
  end
}
