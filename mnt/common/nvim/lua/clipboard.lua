local u = require("utils")

if u.is_windows then
  vim.opt.clipboard = "unnamed"
else
  vim.opt.clipboard = "unnamedplus"
  vim.g.clipboard = {
    name = "WslClipboard",
    copy = {
      ["+"] = "xsel -bi",
    },
    paste = {
      ["+"] = "xsel -bo",
      ["*"] = function()
        return vim.fn.systemlist('xsel -bo | tr -d "\r"')
      end,
    },
    cache_enabled = 1,
  }
end
