return {
  -- TODO: oil.nvimから起動すると開く場所がおかしい
  "folke/snacks.nvim",
  -- stylua: ignore start
  keys = {
    {"<Space>q", function() Snacks.bufdelete() end, silent = true},
    {"<Space>z", function() Snacks.zen() end, silent = true},
    { "<C-j>f", function() Snacks.picker.files() end, silent = true },
    { "<C-j>e", function() Snacks.picker.smart() end, silent = true },
    { "<C-j>r", function() Snacks.picker.recent() end, silent = true },
    { "<C-j>t", function() Snacks.picker.explorer() end, silent = true },
    { "<C-j>g", function() Snacks.picker.grep() end, silent = true },
    {
      "<C-j>G",
      function()
        local curdir = vim.bo.filetype == "oil" and require("oil").get_current_dir() or vim.fn.expand("%:p:h")
        Snacks.picker.grep({ dirs = { curdir } })
      end,
      silent = true
    },
    { "<C-j>l", function() Snacks.picker.lines() end, silent = true },
    -- TODO: sort順をマッチ順ではなく時間順にしたい
    { "<C-j>:", function() Snacks.picker.command_history() end, silent = true },
    { "<C-j>c", function() Snacks.picker.git_status() end, silent = true },
    { "<C-j>b", function() Snacks.picker.git_log_line() end, silent = true },
    { "<C-j>m", function() Snacks.picker.todo_comments() end, silent = true },
    { "<C-j>j", function() Snacks.picker.resume() end, silent = true },
    { "<C-j>o", function() Snacks.picker.treesitter() end, silent = true },
    { "<C-j>p", function() Snacks.picker.pickers() end, silent = true },
  },
  -- stylua: ignore end
  opts = {
    styles = {
      zen = {
        width = 180,
        backdrop = { transparent = true, blend = 10 },
      },
    },
    picker = {
      sources = {
        lines = {
          layout = { preview = true },
        },
        explorer = {
          focus = "input",
          auto_close = true,
          layout = { preview = true },
          matcher = { sort_empty = false, fuzzy = true },
          win = {
            list = {
              keys = {
                ["<c-q>"] = false,
                ["<c-d>"] = { "preview_scroll_down", mode = { "i", "n" } },
                ["<c-]>"] = { "toggle_live", mode = { "i", "n" } },
                ["<F12>"] = { "edit_vsplit", mode = { "i", "n" } },
                ["<C-w>t"] = { "tab", mode = { "i", "n" } },
                -- TODO: そのままoil.nvimで対象を開く
                -- ["<C-o>"] = { mode = { "i", "n" }, },
              },
            },
          },
        },
      },
      win = {
        input = {
          keys = {
            ["<esc>"] = { "close", mode = { "i", "n" } },
            ["<c-q>"] = false,
            ["<c-o>"] = { "qflist", mode = { "i", "n" } },
            ["<c-d>"] = { "preview_scroll_down", mode = { "i", "n" } },
            ["<c-]>"] = { "toggle_live", mode = { "i", "n" } },
            ["<F12>"] = { "edit_vsplit", mode = { "i", "n" } },
            ["<C-w>t"] = { "tab", mode = { "i", "n" } },
          },
        },
      },
      layout = {
        cycle = true,
        preset = "vertical",
        layout = {
          backdrop = false,
          width = 120,
          min_width = 80,
          height = 0.9,
          min_height = 30,
          box = "vertical",
          border = "rounded",
          title = "{title} {live} {flags}",
          title_pos = "center",
          { win = "preview", title = "{preview}", height = 0.5, border = "bottom" },
          { win = "input", height = 1, border = "bottom" },
          { win = "list", border = "none" },
        },
      },
      formatters = {
        file = {
          filename_first = true,
          truncate = 100,
        },
      },
      -- TODO: linesの設定を返る
      -- TODO: explorerの設定を返る
    },
  },
}
