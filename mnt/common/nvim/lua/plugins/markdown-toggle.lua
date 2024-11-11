return {
  "roodolv/markdown-toggle.nvim",
  config = function()
    require("markdown-toggle").setup({
      cycle_box_table = true,
      box_table = { "x" },
      list_before_box = true,
    })

    vim.api.nvim_create_autocmd("FileType", {
      desc = "markdown-toggle.nvim keymaps",
      pattern = { "markdown", "markdown.mdx" },
      callback = function(args)
        local opts = { silent = true, noremap = true, buffer = args.buf }
        local toggle = require("markdown-toggle")

        -- F12はCtrl+Enter
        vim.keymap.set({ "n", "v" }, "<F12>", function()
          toggle.checkbox()
          local cline = vim.api.nvim_get_current_line()
          if string.find(cline, "- %[x%] .+ ``") then
            vim.cmd([[
              SilhouettePushTimer
              GhostwriterWrite
            ]])
          end
        end, opts)
        vim.keymap.set({ "i" }, "<F12>", function()
          vim.api.nvim_command("stopinsert")
          vim.schedule(function()
            toggle.checkbox()
          end)
          vim.schedule(function()
            vim.api.nvim_command("startinsert")
          end)
        end, opts)
      end,
    })
  end,
}
