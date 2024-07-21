return {
  "stevearc/resession.nvim",
  config = function()
    local resession = require("resession")
    resession.setup()

    vim.keymap.set("n", "gss", function()
      resession.save("last")
      vim.cmd("wa")
      vim.cmd("qa!")
    end)
    vim.keymap.set("n", "gsl", function()
      resession.load("last")
    end)
  end,
}
