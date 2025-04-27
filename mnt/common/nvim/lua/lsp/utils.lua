local M = {}

-- https://github.com/neovim/nvim-lspconfig/blob/88d0824d85c0f74a012521d25678a5b01c76feb1/lua/lspconfig/util.lua#L47C1-L61C4
local function insert_package_json(config_files, field, fname)
  local path = vim.fn.fnamemodify(fname, ":h")
  local root_with_package = vim.fs.find({ "package.json", "package.json5" }, { path = path, upward = true })[1]

  if root_with_package then
    -- only add package.json if it contains field parameter
    for line in io.lines(root_with_package) do
      if line:find(field) then
        config_files[#config_files + 1] = vim.fs.basename(root_with_package)
        break
      end
    end
  end
  return config_files
end

-- @param markers: root dirとしてマークするファイル一覧
-- FIXME: package
function M.root_dir_patterns(markers, package)
  return function(bufnr, callback)
    local fname = vim.api.nvim_buf_get_name(bufnr)
    local root_files = package and insert_package_json(markers, "tailwindcss", fname) or markers

    local found_dirs = vim.fs.find(root_files, {
      upward = true,
      path = vim.fs.dirname(vim.fs.normalize(vim.api.nvim_buf_get_name(bufnr))),
    })
    if #found_dirs > 0 then
      return callback(vim.fs.dirname(found_dirs[1]))
    end
  end
end

return M
