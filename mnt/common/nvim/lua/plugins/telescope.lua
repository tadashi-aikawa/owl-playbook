return {
  "nvim-telescope/telescope.nvim",
  branch = "master",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "danielfalk/smart-open.nvim",
    "nvim-telescope/telescope-live-grep-args.nvim",
  },
  keys = {
    { "<C-j>f", ":Telescope find_files find_command=rg,--files,--hidden,--glob,!*.git <CR>", silent = true },
    { "<C-j>e", ":Telescope smart_open<CR>", silent = true },
    { "<C-j>g", ":lua require'telescope'.extensions.live_grep_args.live_grep_args()<CR>", silent = true },
    { "<C-j>l", ":Telescope current_buffer_fuzzy_find<CR>", silent = true },
    { "<C-j>:", ":Telescope command_history<CR>", silent = true },
    { "<C-j>s", ":Telescope lsp_dynamic_workspace_symbols<CR>", silent = true },
    { "<C-j>c", ":lua require'telescope.builtin'.git_status{}<CR>", silent = true },
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
      extensions = {
        live_grep_args = {
          auto_quoting = false,
        },
      },
    })

    require("telescope").load_extension("smart_open")
    require("telescope").load_extension("live_grep_args")
  end,
}
