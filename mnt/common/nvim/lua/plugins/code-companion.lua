return {
  "olimorris/codecompanion.nvim",
  keys = {
    {
      "<Space>cf",
      ":CodeCompanion<CR>",
      mode = { "n", "v" },
      silent = true,
    },
    {
      "<Space>cc",
      ":CodeCompanionChat<CR>",
      mode = { "n", "v" },
      silent = true,
    },
    {
      "<Space>ca",
      ":CodeCompanionAction<CR>",
      mode = { "n", "v" },
      silent = true,
    },
  },
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-treesitter/nvim-treesitter",
  },
  opts = function(_, opts)
    -- 環境に依存しない設定
    local base_opts = {
      opts = {
        language = "Japanese",
      },
      display = {
        chat = {
          auto_scroll = false,
          show_header_separator = true,
        },
      },
      strategies = {
        chat = {
          roles = {
            llm = function(adapter)
              return " CodeCompanion (" .. adapter.formatted_name .. ")"
            end,
            user = " Me",
          },
          keymaps = {
            send = {
              modes = { n = "<F12>", i = "<F12>" }, -- Ctrl+Enter
            },
          },
        },
      },
    }
    -- 環境ごとに切り分けたい設定
    local env_opts = require("envs.code-companion").opts

    -- デフォルト設定 -> 環境に依存しない設定 -> 環境に依存する設定 の順にマージ
    return vim.tbl_deep_extend("force", opts, base_opts, env_opts)
  end,
}
