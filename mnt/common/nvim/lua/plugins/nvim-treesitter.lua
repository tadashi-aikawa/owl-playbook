return {
  "nvim-treesitter/nvim-treesitter",
  event = { "BufNewFile", "BufRead" },
  build = ":TSUpdate",
  config = function()
    require("nvim-treesitter.configs").setup({
      ensure_installed = {
        "bash",
        "css",
        "diff",
        "dockerfile",
        "elixir",
        "gitignore",
        "go",
        "html",
        "http",
        "javascript",
        "json",
        "lua",
        "markdown",
        "markdown_inline",
        "python",
        "rust",
        "scss",
        "svelte",
        "toml",
        "tsx",
        "typescript",
        "vim",
        "vimdoc",
        "vue",
        "yaml",
      },
      highlight = {
        enable = true,
        disable = { "ini" },
      },
      -- texobjectsはパフォーマンスの問題から利用しない
    })
  end,
}
