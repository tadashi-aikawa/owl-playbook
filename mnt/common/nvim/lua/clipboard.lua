local u = require("utils")

if u.is_windows then
  vim.opt.clipboard = "unnamed"
else
  vim.opt.clipboard = "unnamedplus"
  vim.g.clipboard = {
    name = "WslClipboard",
    copy = {
      ["+"] = "wl-copy",
    },
    paste = {
      ["+"] = function()
        return vim.fn.systemlist('wl-paste | tr -d "\r"')
      end,
      ["*"] = "wl-paste",
    },
    cache_enabled = 1,
  }
end
