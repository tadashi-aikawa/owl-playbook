return {
  "stevearc/conform.nvim",
  event = "VeryLazy",
  opts = function()
    local web_formatter = { "biome-check", "prettierd", stop_after_first = true }
    return {
      formatters_by_ft = {
        lua = { "stylua" },
        go = { "goimports" },
        bash = { "shfmt" },
        python = { "ruff_organize_imports", "ruff_fix" },

        -- Web
        typescript = web_formatter,
        javascript = web_formatter,
        typescriptreact = web_formatter,
        javascriptreact = web_formatter,
        vue = web_formatter,
        svelte = web_formatter,
        json = web_formatter,
        jsonc = web_formatter,
        yaml = { "prettierd" },
        html = web_formatter,
        css = web_formatter,
        scss = web_formatter,
        less = web_formatter,
      },
      format_on_save = {
        timeout_ms = 1500,
        lsp_format = "fallback",
      },
    }
  end,
}
