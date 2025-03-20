return {
  "olimorris/codecompanion.nvim",
  keys = {
    {
      "<Space>cp",
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
    {
      "<Space>ct",
      function()
        require("codecompanion").prompt("trans_to_en")
      end,
      mode = { "v" },
      silent = true,
    },
  },
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-treesitter/nvim-treesitter",
    "j-hui/fidget.nvim",
  },
  init = function()
    require("codecompanion.fidget-spinner"):init()
  end,
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
      prompt_library = {
        ["Translate to English"] = {
          strategy = "inline",
          description = "選択したテキストを英語に翻訳します",
          opts = {
            short_name = "trans_to_en",
            modes = { "v" },
            adapter = {
              name = "copilot",
              model = "gpt-4o",
            },
            -- INFO: コードを見るとstrategy = "inline" で対応してなさそう
            -- ignore_system_prompt = true,
          },
          prompts = {
            {
              role = "system",
              content = "あなたは優れた開発者であり、日本語と英語のプロ翻訳者でもあります。",
            },
            {
              role = "user",
              content = "<user_prompt>選択したコードドキュメントを英語に変換してください。</user_prompt>",
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
