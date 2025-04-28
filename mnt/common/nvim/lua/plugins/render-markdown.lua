return {
  "MeanderingProgrammer/render-markdown.nvim",
  dependencies = { "nvim-treesitter/nvim-treesitter", "echasnovski/mini.icons" },
  ft = { "markdown", "markdown.mdx", "codecompanion" },
  opts = {
    file_types = { "markdown", "codecompanion" },
    heading = {
      position = "inline",
      sign = false,
      icons = { "󰉫 ████ ", "󰉬 ██ ", "󰉭 █ ", "󰉮  ", "󰉯 ▌", "󰉰 " },
      width = { "full", "full", "block", "block", "block", "block" },
      setext = false,
    },
    fat_tables = false,
    dash = {
      icon = " ",
    },
    code = {
      sign = false,
      width = "block",
      border = "thin",
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
  init = function()
    vim.api.nvim_create_autocmd("ColorScheme", {
      callback = function()
        vim.api.nvim_set_hl(0, "RenderMarkdownCode", { bg = "#070707" })
        vim.api.nvim_set_hl(0, "ColorColumn", { bg = "#454545" })
        vim.api.nvim_set_hl(0, "RenderMarkdownDash", { fg = "lightgray" })
        vim.api.nvim_set_hl(0, "RenderMarkdownH1Bg", { fg = "#efef33", bg = "#3d59a1" })
        vim.api.nvim_set_hl(0, "RenderMarkdownH2Bg", { fg = "#FF9966", bg = "#665050" })
        vim.api.nvim_set_hl(0, "RenderMarkdownH3Bg", { fg = "#FFC777", bg = "#58535f" })
        vim.api.nvim_set_hl(0, "RenderMarkdownH4Bg", { fg = "#FFC777", bg = "#493e4a" })
        vim.api.nvim_set_hl(0, "RenderMarkdownH5Bg", { fg = "#FFC777", bg = nil })
        vim.api.nvim_set_hl(0, "RenderMarkdownH6Bg", { fg = "#FFC777", bg = nil })
      end,
    })
  end,
}
