return {
  'dhruvasagar/vim-table-mode',
  config = function()
    vim.api.nvim_set_keymap('n', '<A-;>', "<Cmd>:TableModeRealign<CR>", {})
  end
}
