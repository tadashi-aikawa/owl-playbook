return {
  dir = "~/git/github.com/tadashi-aikawa/ghostwriter.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
  },
  keys = {
    { "<C-j>w", ":GhostwriterWrite<CR>", silent = true },
    { "<C-j>p", ":GhostwriterPost ", mode = { "v" } },
    { "<C-j>y", ":GhostwriterCopy<CR>", mode = { "v" }, silent = true },
    { "<C-j>S", ":GhostwriterInsertChannelID<CR>", silent = true },
  },
  config = function()
    require("ghostwriter").setup({
      replacers = {
        { pattern = " %[%[202%d+_", replaced = " [[" },
        { pattern = " %[%[MTG_202%d+_", replaced = " [[📅 " },
        { pattern = " %[%[MTG_", replaced = " [[📅 " },
        { pattern = " 202%d+_", replaced = " " },
        { pattern = " MTG_202%d+_", replaced = " 📅 " },
        { pattern = " MTG_", replaced = " 📅 " },
        { pattern = "%d%d:%d%d ([^📅][^📅][^📅][^📅].*)$", replaced = "%1" },
        { pattern = "^%| 9f", replaced = ":vertical-line::to9f:" },
        { pattern = "^%| 8f", replaced = ":vertical-line::to8f:" },
        { pattern = "^%| 7f", replaced = ":vertical-line::to7f:" },
        { pattern = "^%| 6f", replaced = ":vertical-line::to6f:" },
        { pattern = "^%| 2f", replaced = ":vertical-line::to2f:" },
        { pattern = "^%| 1f", replaced = ":vertical-line::to1f:" },
        { pattern = "^%|", replaced = ":vertical-line:" },
      },
      check = {
        { mark = "~", emoji = "loading" },
        { mark = "x", emoji = "ok_green" },
        { mark = "-", emoji = "m" },
        { mark = " ", emoji = "circle-success" },
      },
      channel = {
        { name = "times", id = "C1J80C5MF" },
        { name = "task", id = "C06J0RG1V2L" },
        { name = "jh", id = "C072W42TPR7" },
      },
    })
  end,
}
