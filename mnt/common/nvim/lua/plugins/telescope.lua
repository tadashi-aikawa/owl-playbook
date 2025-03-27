return {
  "nvim-telescope/telescope.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
  },
  keys = {
    "<C-j>h", -- dummy. markdownだとghostwriter.nvimで起動するので問題ない
  },
  config = function()
    local actions = require("telescope.actions")

    require("telescope").setup({
      defaults = {
        mappings = {
          i = {
            ["<esc>"] = actions.close,
            ["<C-a>"] = actions.smart_add_to_qflist + actions.open_qflist,
            ["<C-o>"] = actions.smart_send_to_qflist + actions.open_qflist,
            ["<C-s>"] = actions.select_horizontal,
            -- Ctrl+Enterがマッピングされている
            ["<F12>"] = actions.select_vertical,
            ["<C-w>t"] = actions.select_tab,
          },
          n = { ["q"] = actions.close },
        },
        sorting_strategy = "ascending",
        layout_strategy = "vertical",
        layout_config = {
          vertical = {
            width = 120,
          },
          prompt_position = "top",
          preview_cutoff = 1,
        },
        file_ignore_patterns = {
          "node_modules",
        },
        path_display = {
          filename_first = {
            reverse_directories = false,
          },
        },
      },
    })
  end,
}
