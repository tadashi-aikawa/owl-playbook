return {
  "nvimtools/none-ls.nvim",
  config = function()
    local null_ls = require("null-ls")
    local augroup = vim.api.nvim_create_augroup("LspFormatting", {})

    null_ls.setup({
      sources = {
        null_ls.builtins.formatting.biome.with({
          only_local = "node_modules/.bin",
        }),
        null_ls.builtins.formatting.prettierd.with({
          prefer_local = "node_modules/.bin",
          extra_filetypes = { "svelte" },
          disabled_filetypes = { "markdown" },
          condition = function(utils)
            local biome_support_filetypes =
              { "javascript", "typescript", "javascriptreact", "typescriptreact", "json", "jsonc" }
            -- biome.json が対応していなければprettier
            if not vim.tbl_contains(biome_support_filetypes, vim.bo.filetype) then
              return true
            end
            -- biome.json が対応しててもbiome.jsonがなければprettier
            return not utils.root_has_file({ "biome.json" })
          end,
        }),
        null_ls.builtins.formatting.stylua,
        null_ls.builtins.formatting.ruff,
        null_ls.builtins.formatting.gofumpt,
        null_ls.builtins.formatting.goimports,
        null_ls.builtins.code_actions.shellcheck,
        null_ls.builtins.formatting.shfmt,
        null_ls.builtins.formatting.rustfmt,
      },
      on_attach = function(client, bufnr)
        if client.supports_method("textDocument/formatting") then
          vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
          vim.api.nvim_create_autocmd("BufWritePre", {
            group = augroup,
            buffer = bufnr,
            callback = function()
              vim.lsp.buf.format({
                async = false,
                filter = function(c)
                  return c.name == "null-ls"
                end,
              })
            end,
          })
        end
      end,
    })
  end,
}
