vim.g.clipboard = {
    name = 'WslClipboard',
    copy = {
        ['+'] = 'xsel -bi',
        ['*'] = 'xsel -bi',
    },
    paste = {
        ['+'] = 'win32yank.exe -o --lf',
        ['*'] = 'win32yank.exe -o --lf',
    },
    cache_enabled = 0,
}

