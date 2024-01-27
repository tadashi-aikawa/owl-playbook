return {
  "iamcco/markdown-preview.nvim",
  lazy = false,
  keys = {
    { '<M-p>', ':MarkdownPreviewToggle<CR>', silent = true }
  },
  build = function() vim.fn["mkdp#util#install"]() end,
}
