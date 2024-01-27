return {
  'romgrk/barbar.nvim',
  dependencies = { 'nvim-web-devicons' },
  event = { 'BufNewFile', 'BufRead' },
  opts = {
    animation = false,
    sidebar_filetypes = {
      NvimTree = true
    }
  }
}
