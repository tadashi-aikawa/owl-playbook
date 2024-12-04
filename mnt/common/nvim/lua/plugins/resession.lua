return {
  "stevearc/resession.nvim",
  opts = {},
  keys = {
    {
      "gss",
      function()
        require("resession").save("last")
        vim.cmd("wa")
        vim.cmd("qa!")
      end,
    },
    {
      "gsl",
      function()
        require("resession").load("last")
      end,
    },
  },
}
