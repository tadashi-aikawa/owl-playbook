return {
  'mg979/vim-visual-multi',
  init = function()
    local t = {}
    t["Find Under"] = "<C-k>"
    t["Find Subword Under"] = "<C-k>"
    vim.g.VM_maps = t
  end
}
