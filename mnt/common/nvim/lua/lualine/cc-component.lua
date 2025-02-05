local M = require("lualine.component"):extend()

local spinner_symbols = {
  "🌑",
  "🌒",
  "🌓",
  "🌔",
  "🌕",
  "🌖",
  "🌗",
  "🌘",
}
local spinner_symbols_len = #spinner_symbols

M.spinner_index = 1

function M:init(options)
  M.super.init(self, options)

  local group = vim.api.nvim_create_augroup("CodeCompanionHooks", {})

  local companion_buf
  vim.api.nvim_create_autocmd({ "User" }, {
    pattern = "CodeCompanionRequest*",
    group = group,
    callback = function(request)
      local bufnr = vim.api.nvim_get_current_buf()
      if request.match == "CodeCompanionRequestStarted" then
        companion_buf = bufnr
        pcall(vim.api.nvim_buf_set_var, companion_buf, "cc_processing", true)
      elseif request.match == "CodeCompanionRequestFinished" then
        pcall(vim.api.nvim_buf_set_var, companion_buf, "cc_processing", false)
        companion_buf = nil
      end
    end,
  })
end

function M:update_status()
  local bufnr = vim.api.nvim_get_current_buf()
  local ok, cc_proc = pcall(vim.api.nvim_buf_get_var, bufnr, "cc_processing")

  if ok and cc_proc then
    self.spinner_index = (self.spinner_index % spinner_symbols_len) + 1
    return spinner_symbols[self.spinner_index]
  else
    return nil
  end
end

return M
