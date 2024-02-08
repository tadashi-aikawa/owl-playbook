return {
  "karb94/neoscroll.nvim",
  config = function()
    require("neoscroll").setup({})

    local t = {}
    t["<C-u>"] = { "scroll", { "-vim.wo.scroll", "false", "150" } }
    t["<C-d>"] = { "scroll", { "vim.wo.scroll", "false", "150" } }
    t["zt"] = { "zt", { "150" } }
    t["zz"] = { "zz", { "150" } }
    t["zb"] = { "zb", { "150" } }

    require("neoscroll.config").set_mappings(t)
  end,
}
