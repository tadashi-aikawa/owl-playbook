vim.g.clipboard = {
    name = 'WslClipboard',
    copy = {
        ['+'] = 'xsel -bi',
        ['*'] = 'xsel -bi',
    },
    paste = {
        ['+'] = 'xsel -bo',
        ['*'] = 'win32yank.exe -o --lf',
    },
    cache_enabled = 1,
}

