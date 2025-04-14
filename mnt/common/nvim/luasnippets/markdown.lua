---@diagnostic disable: undefined-global

local function today()
  return sn(nil, { i(1, os.date("%Y%m%d")) })
end
local function today_with_hypens()
  return sn(nil, { i(1, os.date("%Y-%m-%d")) })
end


-- stylua: ignore
return {
  s("_mtg", {
    t("- [ ] "),
    i(1, "10"), t(":"), i(2, "00"),
    t(" [[MTG_"), d(3, today), t("_"), i(4, "MTG名"), t("]]"),
  }),
  s("_activity", {
    t("- [ ] "),
    t("[["), d(1, today), t("_"), i(2, "作業名"), t("]]"),
  }),
  s("_fm", {
    t({
      "---",
      "created: "
    }),
    d(1, today_with_hypens),
    t({
      "",
      "refer: "
    }),
    i(0, ""),
    t({
      "",
      "---",
      ""
    }),
  }),
  s("_fmp", {
    t({
      "---",
      "created: "
    }),
    d(1, today_with_hypens),
    t({
      "",
      "participants:",
      "  - tadashi-aikawa",
      "  - ",
    }),
    i(2),
    t({
      "",
      "refer: "
    }),
    i(0, ""),
    t({
      "",
      "---",
      ""
    }),
  }),
}
