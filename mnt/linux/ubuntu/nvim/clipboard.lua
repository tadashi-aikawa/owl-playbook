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

