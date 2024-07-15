return {
  "MeanderingProgrammer/markdown.nvim",
  name = "render-markdown", -- Only needed if you have another plugin named markdown.nvim
  dependencies = { "nvim-treesitter/nvim-treesitter" },
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
