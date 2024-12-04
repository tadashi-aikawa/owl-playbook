return {
  "MeanderingProgrammer/markdown.nvim",
  name = "render-markdown",
  dependencies = { "nvim-treesitter/nvim-treesitter", "echasnovski/mini.icons" },
  ft = { "markdown", "markdown.mdx" },
  opts = {
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
        progress = { raw = "[~]", rendered = "󰲼 ", highlight = "RenderMarkdownTodo" },
        pending = { raw = "[_]", rendered = "󰮢 ", highlight = "RenderMarkdownWait" },
        todo = { raw = "[-]", rendered = " ", highlight = "RenderMarkdownWarn" },
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
  },
}
