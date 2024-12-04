return {
  "iamcco/markdown-preview.nvim",
  keys = {
    { "<M-p>", ":MarkdownPreviewToggle<CR>", silent = true },
  },
  build = function()
    vim.fn["mkdp#util#install"]()
  end,
}
