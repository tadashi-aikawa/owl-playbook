return {
  on_attach = function(client, bufnr)
    require("mnt.common.nvim.after.lsp.sqls").on_attach(client, bufnr)
  end,
}
