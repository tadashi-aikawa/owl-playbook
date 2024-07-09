return {
  "monaqa/general-converter.nvim",
  dependencies = {
    "uga-rosa/utf8.nvim",
  },
  config = function()
    local utf8 = require("utf8")

    require("general_converter").setup({
      converters = {
        {
          desc = "ひらがなに変換する (「あ」 -> 「あ」, 「ア」 -> 「あ」)",
          converter = function(str)
            local ret = ""
            for i = 1, utf8.len(str) do
              local lead = utf8.offset(str, i)
              local trail = utf8.offset(str, i + 1) - 1
              local codepoint = utf8.codepoint(string.sub(str, lead, trail))

              if codepoint >= 0x30A0 and codepoint <= 0x30FF then
                ret = ret .. utf8.char(codepoint - 0x60)
              else
                ret = ret .. utf8.char(codepoint)
              end
            end
            return ret
          end,
          labels = { "hira" },
        },
        {
          desc = "カタカナに変換する (「あ」 -> 「あ」, 「あ」 -> 「ア」)",
          converter = function(str)
            local ret = ""
            for i = 1, utf8.len(str) do
              local lead = utf8.offset(str, i)
              local trail = utf8.offset(str, i + 1) - 1
              local codepoint = utf8.codepoint(string.sub(str, lead, trail))

              if codepoint >= 0x3040 and codepoint <= 0x309F then
                ret = ret .. utf8.char(codepoint + 0x60)
              else
                ret = ret .. utf8.char(codepoint)
              end
            end
            return ret
          end,
          labels = { "kana" },
        },
      },
    })

    vim.keymap.set({ "n", "x" }, "@k", require("general_converter").operator_convert("kana"), { expr = true })
    vim.keymap.set({ "n", "x" }, "@h", require("general_converter").operator_convert("hira"), { expr = true })
  end,
}
