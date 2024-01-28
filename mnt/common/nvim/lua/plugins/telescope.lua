return {
  'nvim-telescope/telescope.nvim',
  branch = '0.1.x',
  dependencies = {
    'nvim-lua/plenary.nvim',
    "nvim-telescope/telescope-frecency.nvim",
    'fannheyward/telescope-coc.nvim',
    'tom-anders/telescope-vim-bookmarks.nvim'
  },
  keys = {
    { '<C-j>f', ':Telescope find_files find_command=rg,--files,--hidden,--glob,!*.git <CR>', silent = true },
    { '<C-j>z', ':Telescope frecency<CR>',                                                   silent = true },
    { '<C-j>e', ':Telescope oldfiles<CR>',                                                   silent = true },
    { '<C-j>g', ':Telescope live_grep<CR>',                                                  silent = true },
    { '<C-j>l', ':Telescope current_buffer_fuzzy_find<CR>',                                  silent = true },
    { '<C-j>p', ':Telescope commands<CR>',                                                   silent = true },
    { '<C-j>:', ':Telescope command_history<CR>',                                            silent = true },
    { '<C-j>m', ':Telescope vim_bookmarks all<CR>',                                          silent = true },
    { '<C-j>i', ':Telescope coc implementations<CR>',                                        silent = true },
    { '<C-j>h', ':Telescope coc references_used<CR>',                                        silent = true },
    { '<C-j>s', ':Telescope coc workspace_symbols<CR>',                                      silent = true },
    { '<C-j>c', ":lua require'telescope.builtin'.git_status{}<CR>",                          silent = true },
  },
  config = function()
    local actions = require("telescope.actions")
    require("telescope").setup {
      defaults = {
        mappings = {
          i = {
            ["<esc>"] = actions.close,
            ["<C-a>"] = actions.smart_add_to_qflist + actions.open_qflist,
            ["<C-o>"] = actions.smart_send_to_qflist + actions.open_qflist,
            -- Ctrl+Enterがマッピングされている
            ["<F12>"] = actions.select_vertical,
          },
          n = { ["q"] = actions.close },
        },
        sorting_strategy = "ascending",
        layout_strategy = "vertical",
        layout_config = {
          vertical = { width = 0.9 },
          prompt_position = "top",
          preview_cutoff = 1,
        },
      },
      extensions = {
        frecency = {
          show_scores = true
        },
        coc = {
          -- trueだと常にpreviewを経由する
          prefer_locations = false,
        }
      }
    }

    require("telescope").load_extension("frecency")
    require('telescope').load_extension('coc')
    require('telescope').load_extension('vim_bookmarks')
  end
}