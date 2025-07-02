return {
  {
    "williamboman/mason.nvim",
      enabled = false,
  },
  {
    "williamboman/mason-lspconfig.nvim",
      enabled = false,
  },
  {
    "jay-babu/mason-nvim-dap.nvim",
      enabled = false,
  },
  {
    "prabirshrestha/vim-lsp",
      enabled = false,
  },
  -- {
  --   "neovim/nvim-lspconfig",
  --   opts = {
  --     servers = {
  --       nil_ls = {
  --         mason = false
  --       },
  --     },
  --     setup = {
  --       nil_ls = function()
  --       --require("mason").setup()
  --       --require("mason-lspconfig").setup()
  --       --require("lazyvim.util").on_attach(function(_, buffer)
  --           require'lspconfig'.nil_ls.setup{}
  --           local lsp_mappings = {
  --           { 'gD', vim.lsp.buf.declaration },
  --           { 'gd', vim.lsp.buf.definition },
  --           { 'gi', vim.lsp.buf.implementation },
  --           { 'gr', vim.lsp.buf.references },
  --           { '[d', vim.diagnostic.goto_prev },
  --           { ']d', vim.diagnostic.goto_next },
  --           { ' ch' , vim.lsp.buf.hover },
  --           { ' cs', vim.lsp.buf.signature_help },
  --           { ' cd', vim.diagnostic.open_float },
  --           { ' cq', vim.diagnostic.setloclist },
  --           { ' cr', vim.lsp.buf.rename },
  --           { ' ca', vim.lsp.buf.code_action },
  --           }
  --           for i, map in pairs(lsp_mappings) do
  --             vim.keymap.set('n', map[1], function() map[2]() end)
  --           end
  --           vim.keymap.set('x', '\\a', function() vim.lsp.buf.code_action() end)

  --           -- https://github.com/neovim/nvim-lspconfig/wiki/Autocompletion
  --           -- https://github.com/hrsh7th/cmp-nvim-lsp/issues/42#issuecomment-1283825572
  --           local caps = vim.tbl_deep_extend(
  --             'force',
  --             vim.lsp.protocol.make_client_capabilities(),
  --             require('cmp_nvim_lsp').default_capabilities(),
  --             -- File watching is disabled by default for neovim.
  --             -- See: https://github.com/neovim/neovim/pull/22405
  --             { workspace = { didChangeWatchedFiles = { dynamicRegistration = true } } }
  --           );
  --           return true
  --         --end)
  --       end,
  --     }
  --   }
  -- },
}
