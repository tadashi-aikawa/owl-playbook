return {
  "windwp/nvim-autopairs",
  event = "InsertEnter",
  config = function()
    -- optsとconfigに分けると動かなかった
    local p = require("nvim-autopairs")
    p.setup({
      disable_filetype = { "TelescopePrompt", "vim" },
    })

    -- クォーテーションは無効化
    p.remove_rule('"')
    p.remove_rule("'")
    p.remove_rule("`")
    p.remove_rule("```")
  end,
}
