return {
  "terrortylor/nvim-comment",
  opts = {
    hook = function()
      require("ts_context_commentstring").update_commentstring()
    end,
  },
}
