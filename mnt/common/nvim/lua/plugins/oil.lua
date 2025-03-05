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
      ["gy"] = "actions.copy_entry_path",
      -- ["<C-o>"] = { "actions.send_to_qflist", opts = { action = "a", only_matching_search = true } },
    },
    view_options = {
      show_hidden = true,
    },
  },
}
