return {
  "iamcco/markdown-preview.nvim",
  keys = {
    { "<M-p>", ":MarkdownPreviewToggle<CR>", silent = true },
  },
  ft = "markdown",
  build = function()
    vim.fn["mkdp#util#install"]()
  end,
}
