return {
  "windwp/nvim-autopairs",
  event = "InsertEnter",
  config = function()
    -- optsとconfigに分けると動かなかった
    local p = require("nvim-autopairs")
    p.setup({
      disable_filetype = { "vim" },
    })

    -- 閉じ括弧補完を無効化
    p.get_rule("("):with_pair(function()
      return false
    end)
    p.get_rule("{"):with_pair(function()
      return false
    end)
    p.get_rule("["):with_pair(function()
      return false
    end)

    -- クォーテーションは無効化
    p.remove_rule('"')
    p.remove_rule("'")
    p.remove_rule("`")
    p.remove_rule("```")
  end,
}
