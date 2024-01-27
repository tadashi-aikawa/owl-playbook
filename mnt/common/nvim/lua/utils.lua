local path_sep = package.config:sub(1, 1)

local is_windows = path_sep == '\\'
local set = vim.opt
local key = vim.keymap.set

return {
  is_windows = is_windows, key = key, set = set
}
