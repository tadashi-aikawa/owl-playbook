return {
  dir = "~/git/github.com/tadashi-aikawa/ghostwriter.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
  },
  keys = {
    { "<C-j>m", ":GhostwriterWrite<CR>", silent = true },
    { "<C-j>p", ":GhostwriterPost times<CR>", mode = { "v" }, silent = true },
    { "<C-j>y", ":GhostwriterCopy<CR>", mode = { "v" }, silent = true },
  },
  config = function()
    require("ghostwriter").setup({
      replacers = {
        { pattern = " %[?%[?202%d+_", replaced = " " },
        { pattern = " %[?%[?MTG_202%d+_", replaced = " 📅 " },
        { pattern = " %[?%[?MTG_", replaced = " 📅 " },
        { pattern = " %d%d:%d%d ", replaced = " " },
      },
      check = {
        { mark = "~", emoji = "loading" },
        { mark = "x", emoji = "ok_green" },
        { mark = "_", emoji = "rip" },
        { mark = "-", emoji = "togowl_pause" },
        { mark = " ", emoji = "circle-success" },
      },
      channel = {
        { name = "times", id = "C1J80C5MF" },
        { name = "task", id = "C06J0RG1V2L" },
      },
    })
  end,
}
