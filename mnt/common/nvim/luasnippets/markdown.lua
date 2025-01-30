---@diagnostic disable: undefined-global

local function today()
  return sn(nil, { i(1, os.date("%Y%m%d")) })
end

-- stylua: ignore
return {
  s("_mtg", {
    t("- [ ] "),
    i(1, "10"), t(":"), i(2, "00"),
    t(" [[MTG_"), d(3, today), t("_"), i(4, "MTG名"), t("]]"),
  }),
}
