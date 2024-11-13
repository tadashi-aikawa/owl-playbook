return {
  "akinsho/toggleterm.nvim",
  version = "*",
  config = function()
    require("toggleterm").setup({})
    vim.keymap.set("n", "<Space>i", ":ToggleTerm direction=float<CR>", { silent = true })
    vim.keymap.set("n", "<Space>,", ":ToggleTerm size=20<CR>", { silent = true })
    vim.keymap.set("n", "<Space>t", function()
      local curdir = require("oil").get_current_dir()
      if curdir then
        vim.cmd("ToggleTerm dir=" .. curdir)
      end
    end, { silent = true })
    vim.keymap.set("t", "<ESC>", [[<C-\><C-n>]], { silent = true })
  end,
}
