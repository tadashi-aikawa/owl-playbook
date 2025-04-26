return {
  "stevearc/aerial.nvim",
  opts = {
    layout = {
      default_direction = "float",
      min_width = 50,
    },
    keymaps = {
      ["<ESC>"] = "actions.close",
      ["o"] = "actions.scroll",
    },
  },
  dependencies = {
    "nvim-treesitter/nvim-treesitter",
  },
  keys = {
    { "<C-j>o", ":AerialOpen<CR>", silent = true },
  },
  init = function()
    vim.api.nvim_create_autocmd("ColorScheme", {
      callback = function()
        vim.api.nvim_set_hl(0, "AerialLine", { fg = "#efef33", bg = "#565612", bold = true })
      end,
    })
  end,
}
