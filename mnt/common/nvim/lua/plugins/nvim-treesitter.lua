return {
  'nvim-treesitter/nvim-treesitter',
  event = { 'BufNewFile', 'BufRead' },
  build = ":TSUpdate",
  config = function()
    require('nvim-treesitter.configs').setup {
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
        "python",
        "rust",
        "svelte",
        "toml",
        "typescript",
        "vim",
        "vue",
        "yaml",
      },
      highlight = {
        enable = true,
        disable = { "ini" }
      },
      autotag = {
        enable = true,
      },
      -- texobjectsはパフォーマンスの問題から利用しない
    }
  end
}
