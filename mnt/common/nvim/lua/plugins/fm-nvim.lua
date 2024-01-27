return {
  "is0n/fm-nvim",
  keys = {
    { '<Space>g', ':Lazygit<CR>', silent = true },
    { '<C-j>r',   ':Broot<CR>',   silent = true },
  },
  config = function()
    require('fm-nvim').setup {
      ui = {
        float = {
          height = 0.99,
          width = 0.99,
        }
      },

      broot_conf = "~/.config/broot/conf.nvim.toml"
    }
  end
}
