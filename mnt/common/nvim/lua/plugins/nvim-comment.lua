return {
  "terrortylor/nvim-comment",
  config = function()
    require("nvim_comment").setup({
      hook = function()
        require("ts_context_commentstring").update_commentstring()
      end,
    })
  end,
}
