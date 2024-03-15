local path_sep = package.config:sub(1, 1)

local is_windows = path_sep == "\\"

return {
  is_windows = is_windows,
}
