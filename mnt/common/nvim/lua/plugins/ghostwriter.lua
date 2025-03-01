return {
  dir = "~/git/github.com/tadashi-aikawa/ghostwriter.nvim",
  ft = "markdown",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-telescope/telescope.nvim",
  },
  keys = {
    { "gsw", ":GhostwriterWrite<CR>", silent = true },
    { "gsp", ":GhostwriterPost ", mode = { "v" } },
    { "gsm", ":GhostwriterRecentMessages" },
    { "gsy", ":GhostwriterCopy<CR>", mode = { "v" }, silent = true },
  },
  opts = function(_, opts)
    return vim.tbl_deep_extend("force", opts, {
      check = {
        { mark = "~", emoji = "loading" },
        { mark = "x", emoji = "ok_green" },
        { mark = "_", emoji = "circle_to_be_continued" },
        { mark = "-", emoji = "circle-failure" },
        { mark = " ", emoji = "circle-success" },
      },
    }, require("envs.ghostwriter").opts)
  end,
}
