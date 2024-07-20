return {
  "stevearc/resession.nvim",
  config = function()
    local resession = require("resession")
    resession.setup()

    vim.api.nvim_create_user_command("SS", function()
      resession.save("last")
      vim.cmd("qa!")
    end, {})

    vim.api.nvim_create_user_command("SL", function()
      resession.load("last")
    end, {})
  end,
}
