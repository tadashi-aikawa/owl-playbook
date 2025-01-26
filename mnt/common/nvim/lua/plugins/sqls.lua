return {
  "nanotee/sqls.nvim",
  ft = "sql",
  config = function()
    vim.keymap.set({ "n", "i" }, "<F12>", "<cmd>SqlsExecuteQuery<CR>", { silent = true })
    vim.keymap.set({ "x" }, "<F12>", ":'<,'>SqlsExecuteQuery<CR>", { silent = true })
    vim.keymap.set({ "n", "i" }, "g<F12>", "<cmd>SqlsExecuteQueryVertical<CR>", { silent = true })
    vim.keymap.set({ "x" }, "g<F12>", ":'<,'>SqlsExecuteQueryVertical<CR>", { silent = true })
  end,
}
