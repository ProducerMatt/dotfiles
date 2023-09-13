return {
  { 'rose-pine/neovim', name = 'rose-pine' },
--  {
--    'sonph/onehalf',
--    config = function(plugin)
--      vim.opt.rtp:append(plugin.dir .. "vim/")
--    end
--  },
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "rose-pine",
    },
  },
}
