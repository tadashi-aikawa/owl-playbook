return {
  "ray-x/lsp_signature.nvim",
  event = { "BufNewFile", "BufRead" },
  opts = {
    hint_enable = false,
    toggle_key = "<C-p>",
  },
  config = function(_, opts)
    require("lsp_signature").setup(opts)
  end,
}
