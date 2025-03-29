return {
  "MeanderingProgrammer/render-markdown.nvim",
  dependencies = { "nvim-treesitter/nvim-treesitter", "echasnovski/mini.icons" },
  ft = { "markdown", "markdown.mdx", "codecompanion" },
  opts = {
    file_types = { "markdown", "codecompanion" },
    heading = {
      position = "inline",
      sign = false,
    },
    fat_tables = false,
    dash = {
      icon = " ",
    },
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
        pending = { raw = "[-]", rendered = " ", highlight = "RenderMarkdownError" },
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
