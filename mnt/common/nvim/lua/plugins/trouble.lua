return {
  "folke/trouble.nvim",
  cmd = "Trouble",
  keys = {
    {
      "<Space>w",
      "<cmd>Trouble diagnostics toggle<cr>",
    },
    {
      "<C-j>h",
      "<cmd>Trouble lsp_references<cr>",
    },
    {
      "<Space>n",
      function()
        ---@diagnostic disable-next-line: missing-parameter, missing-fields READMEと引数の数が違う...
        require("trouble").next({ skip_groups = true, jump = true })
      end,
    },
    {
      "<Space>p",
      function()
        ---@diagnostic disable-next-line: missing-parameter, missing-fields READMEと引数の数が違う...
        require("trouble").prev({ skip_groups = true, jump = true })
      end,
    },
  },
  opts = {
    focus = true,
    auto_refresh = false,
    keys = {
      ["<cr>"] = "jump_close",
      o = "jump",
      l = "fold_open",
      h = "fold_close",
      ["<F12>"] = "jump_vsplit",
      ["<esc>"] = "inspect",
      -- XXX: sはバインドしたくないが、fallbackの方法が分からず...
      s = function()
        require("flash").jump()
      end,
    },
    lsp_references = {
      params = {
        -- 呼び出し履歴(lsp_references)では宣言を表示しない
        include_declaration = false,
      },
    },
    modes = {
      lsp_base = {
        params = {
          -- 現在の項目が消えてしまうので...
          include_current = true,
        },
      },
    },
    signs = {
      error = "",
      warning = "",
      hint = "󱩎",
      information = "",
      other = "",
    },
  },
}
