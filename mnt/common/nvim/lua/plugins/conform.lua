return {
  "stevearc/conform.nvim",
  event = "VeryLazy",
  opts = function()
    local function is_deno_project()
      local cwd = vim.fn.getcwd()
      return vim.fn.filereadable(cwd .. "/deno.json") == 1 or vim.fn.filereadable(cwd .. "/deno.jsonc") == 1
    end

    local web_formatter = function()
      if is_deno_project() then
        -- Denoプロジェクトの場合はLSP(denols)のフォーマットを使う (fallback)
        return {}
      end
      return { "biome-check", "prettierd", stop_after_first = true }
    end

    local python_formatter = function()
      -- ルートディレクトリ名がaster-bffのときだけBlack、isortを使う
      local cwd = vim.fn.getcwd()
      local root_dir = vim.fn.fnamemodify(cwd, ":t")
      if root_dir == "aster-bff" then
        return { "black", "isort" }
      end

      return { "ruff_organize_imports", "ruff_fix" }
    end
    return {
      formatters_by_ft = {
        lua = { "stylua" },
        go = { "goimports" },
        bash = { "shfmt" },
        python = python_formatter,
        sql = { "sleek" },

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
        -- conformで定義したformatterが存在しないならLSPのフォーマッターを使う
        lsp_format = "fallback",
      },
    }
  end,
}
