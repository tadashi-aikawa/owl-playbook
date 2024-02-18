return {
  "folke/trouble.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  config = function()
    require("trouble").setup({
      action_keys = {
        jump_close = { "<cr>" },
        jump = { "<tab>" },
        toggle_fold = { "l", "h" },
        cancel = {}, -- ESCには割り当てない
      },
      -- 診断結果が存在する場合・しない場合で自動開閉
      auto_open = true,
      auto_close = true,
      -- 呼び出し履歴(lsp_references)では宣言を表示しない
      include_declaration = { "lsp_implementations", "lsp_definitions" },
      signs = {
        error = "",
        warning = "",
        hint = "󱩎",
        information = "",
        other = "",
      },
    })

    local trouble = require("trouble")

    vim.keymap.set("n", "<C-j>h", function()
      trouble.open("lsp_references")
    end)
    vim.keymap.set("n", "<Space>w", function()
      trouble.toggle("workspace_diagnostics")
    end)
  end,
}
