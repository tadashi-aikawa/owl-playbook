return {
  "stevearc/oil.nvim",
  keys = {
    { "<Space>o", ":Oil<CR>", silent = true },
  },
  opts = {
    skip_confirm_for_simple_edits = true,
    keymaps = {
      ["<C-s>"] = "actions.select_split",
      ["<F12>"] = "actions.select_vsplit",
    },
    view_options = {
      show_hidden = true,
    },
  },
}
