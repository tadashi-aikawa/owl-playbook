return {
  'terrortylor/nvim-comment',
  config = function()
    require('nvim_comment').setup()
  end,
  hook = function()
    if vim.api.nvim_buf_get_option(0, "filetype") == "vue" then
      require("ts_context_commentstring.internal").update_commentstring()
    end
  end,
}
