return {
  "stevearc/oil.nvim",
  keys = {
    { "<Space>o", ":Oil<CR>", silent = true },
  },
  opts = {
    skip_confirm_for_simple_edits = true,
    keymaps = {
      ["<F12>"] = "actions.select_split",
    },
    view_options = {
      show_hidden = true,
    },
  },
  dependencies = { "nvim-tree/nvim-web-devicons" },
}
