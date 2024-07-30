return {
  "MeanderingProgrammer/markdown.nvim",
  name = "render-markdown",
  dependencies = { "nvim-treesitter/nvim-treesitter", "echasnovski/mini.icons" },
  config = function()
    require("render-markdown").setup({
      markdown_query = [[
        (thematic_break) @dash

        (fenced_code_block) @code

        [
            (list_marker_plus)
            (list_marker_minus)
            (list_marker_star)
        ] @list_marker

        (task_list_marker_unchecked) @checkbox_unchecked
        (task_list_marker_checked) @checkbox_checked

        (block_quote) @quote

        (pipe_table) @table
    ]],
      fat_tables = false,
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
          default = 2,
          rendered = 2,
        },
        concealcursor = {
          default = "",
          rendered = "",
        },
      },
    })
  end,
}
