local u = require("utils")

if u.is_windows then
  u.set.clipboard = 'unnamed'
else
  u.set.clipboard = 'unnamedplus'
  vim.g.clipboard = {
    name = 'WslClipboard',
    copy = {
      ['+'] = 'xsel -bi',
      ['*'] = 'xsel -bi',
    },
    paste = {
      ['+'] = 'xsel -bo',
      ['*'] = function() return vim.fn.systemlist('xsel -bo | tr -d "\r"') end,
    },
    cache_enabled = 1,
  }
end
