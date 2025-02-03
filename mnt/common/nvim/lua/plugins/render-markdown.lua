return {
  "MeanderingProgrammer/render-markdown.nvim",
  dependencies = { "nvim-treesitter/nvim-treesitter", "echasnovski/mini.icons" },
  ft = { "markdown", "markdown.mdx", "Avante", "codecompanion" },
  opts = {
    file_types = { "markdown", "Avante", "codecompanion" },
    heading = {
      position = "inline",
    },
    fat_tables = false,
    code = {
      sign = false,
      width = "block",
    },
    checkbox = {
      unchecked = { icon = "󰄰 " },
      checked = { icon = "󰄳 " },
      custom = {
        progress = { raw = "[~]", rendered = "󱥸 ", highlight = "RenderMarkdownUnchecked" },
        todo = { raw = "[_]", rendered = "󰳜 ", highlight = "RenderMarkdownChecked" },
        pending = { raw = "[-]", rendered = "󰄰 ", highlight = "RenderMarkdownError" },
      },
    },
    win_options = {
      conceallevel = {
        default = 0,
        rendered = 2,
      },
      concealcursor = {
        default = "",
        rendered = "",
      },
    },
    html = {
      comment = {
        conceal = false,
      },
    },
  },
}
