local ls = require("luasnip")
local s = ls.snippet
local i = ls.insert_node
local d = ls.dynamic_node
local t = ls.text_node
local sn = ls.snippet_node

local function today()
  return sn(nil, { i(1, os.date("%Y%m%d")) })
end

ls.add_snippets("markdown", {
  s("_mtg", {
    t("- [ ] "),
    i(1, "10"),
    t(":"),
    i(2, "00"),
    t(" [[MTG_"),
    d(4, today),
    t("_"),
    i(3, "MTG名"),
    t("]]"),
  }),
})
