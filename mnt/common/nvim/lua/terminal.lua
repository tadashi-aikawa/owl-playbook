local u = require("utils")

if u.is_windows then
  vim.opt.shell = "pwsh"
  -- https://github.com/neovim/neovim/issues/13893
  vim.opt.shellcmdflag = '-nologo -noprofile -ExecutionPolicy RemoteSigned -command'
  vim.opt.shellxquote = ''
end

u.key('n', '<C-j>t', ':split | wincmd j | resize 15 | terminal<CR>i', { noremap = true, silent = true })
u.key('t', '<ESC>', '<C-\\><C-n>', { noremap = true, silent = true }) -- ESCでノーマルモード
