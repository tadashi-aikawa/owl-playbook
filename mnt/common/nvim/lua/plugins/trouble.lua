return {
  "folke/trouble.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  opts = {},
  config = function()
    vim.keymap.set("n", "<C-j>h", function()
      require("trouble").open("lsp_references")
    end)
    vim.keymap.set("n", "<Space>w", function()
      require("trouble").toggle("workspace_diagnostics")
    end)
  end,
}
