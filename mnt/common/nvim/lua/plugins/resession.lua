return {
  "stevearc/resession.nvim",
  config = function()
    local resession = require("resession")
    resession.setup()

    vim.keymap.set("n", "<C-j>y", function()
      resession.save("last")
    end)
    vim.keymap.set("n", "<C-j>p", function()
      resession.load("last")
    end)
  end,
}
