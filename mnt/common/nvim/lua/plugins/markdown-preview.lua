return {
  "iamcco/markdown-preview.nvim",
  cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
  ft = { "markdown" },
  keys = {
    { "<M-p>", ":MarkdownPreviewToggle<CR>", silent = true },
  },
  build = function()
    vim.fn["mkdp#util#install"]()
  end,
}
