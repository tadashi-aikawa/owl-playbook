-- dashboard で picker を開いて移動する際に発生するチラツキを防止する
local preventFlicker = function(handler)
  vim.schedule(function()
    Snacks.bufdelete()
  end)
  vim.schedule(function()
    -- ここの順番が逆だとno-neck-painがエラーになる
    vim.cmd([[:NoNeckPain]])
    vim.cmd([[:BarbarEnable]])
  end)
  vim.schedule(function()
    handler()
  end)
end

local dashboardImagePath = vim.fn.stdpath("config") .. "/lua/snacks/dashboard.png"

return {
  "folke/snacks.nvim",
  priority = 1000,
  lazy = false,
  -- stylua: ignore start
  keys = {
    {"<Space>q", function() Snacks.bufdelete() end, silent = true},
    {"<Space>z", function() Snacks.zen.zoom() end, silent = true},
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
    { "<C-j>:", function() Snacks.picker.command_history() end, silent = true },
    { "<C-j>s", function() Snacks.picker.git_status() end, silent = true },
    { "<C-j>b", function() Snacks.picker.git_log_line() end, silent = true },
    { "<C-j>j", function() Snacks.picker.resume() end, silent = true },
    { "<C-j>k", function() Snacks.picker.pickers() end, silent = true },
    { "<C-j>p", function() Snacks.picker.projects() end, silent = true },
    --- @diagnostic disable-next-line: undefined-field todo_commentsはsnacks以外に定義があるため無視
    { "<C-j>m", function() Snacks.picker.todo_comments() end, silent = true },
  },
  -- stylua: ignore end
  ---@type snacks.Config
  opts = {
    dashboard = {
      row = 10,
      preset = {
        keys = {
          {
            icon = " ",
            key = "f",
            desc = "files",
            action = function()
              preventFlicker(Snacks.picker.files)
            end,
          },
          {
            icon = "󰧑 ",
            key = "e",
            desc = "smart",
            action = function()
              preventFlicker(Snacks.picker.smart)
            end,
          },
          {
            icon = " ",
            key = "r",
            desc = "recent",
            action = function()
              preventFlicker(Snacks.picker.recent)
            end,
          },
          {
            icon = " ",
            key = "t",
            desc = "explorer",
            action = function()
              preventFlicker(Snacks.picker.explorer)
            end,
          },
          {
            icon = "󰊢 ",
            key = "s",
            desc = "git status",
            action = function()
              preventFlicker(Snacks.picker.git_status)
            end,
          },
          {
            icon = " ",
            key = "p",
            desc = "project",
            action = function()
              preventFlicker(Snacks.picker.projects)
            end,
          },
          {
            icon = " ",
            key = "g",
            desc = "grep",
            action = function()
              preventFlicker(Snacks.picker.grep)
            end,
          },
          {
            icon = " ",
            key = "o",
            desc = "oil",
            action = function()
              vim.cmd([[:Oil]])
              vim.cmd([[:NoNeckPain]])
              vim.cmd([[:BarbarEnable]])
            end,
          },
          {
            icon = " ",
            key = "i",
            desc = "edit",
            action = function()
              preventFlicker(function()
                vim.cmd([[:startinsert]])
                vim.cmd([[:stopinsert]])
              end)
            end,
          },
          { icon = "󰒲 ", key = "l", desc = "Lazy", action = ":Lazy", enabled = package.loaded.lazy ~= nil },
          { icon = " ", key = "q", desc = "quit", action = ":qa" },
        },
      },
      sections = {
        {
          section = "terminal",
          cmd = "chafa " .. dashboardImagePath .. " --size 48 --symbols vhalf; sleep .1",
          height = 30,
          padding = 0,
        },
        {
          pane = 2,
          { section = "header" },
          { section = "keys", gap = 1, padding = 1 },
          { section = "startup" },
        },
      },
    },
    zen = {
      zoom = {
        show = { statusline = true, tabline = true },
        win = {
          backdrop = true,
          width = 180,
        },
      },
    },
    picker = {
      main = {
        current = true,
      },
      sources = {
        lines = {
          sort = { fields = { "idx", "score:desc" } },
          matcher = { fuzzy = false },
          ---@diagnostic disable-next-line: assign-type-mismatch 普通にプレビュー
          layout = { preview = true },
        },
        recent = {
          sort = { fields = { "idx", "score:desc" } },
          matcher = { fuzzy = false },
          hidden = true,
        },
        files = {
          hidden = true,
        },
        command_history = {
          sort = { fields = { "idx", "score:desc" } },
          matcher = { fuzzy = false },
        },
        explorer = {
          focus = "input",
          auto_close = true,
          matcher = { sort_empty = false },
          hidden = true,
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
          ---@diagnostic disable-next-line: assign-type-mismatch 普通にプレビュー
          layout = { preview = true },
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
            ["<C-j>"] = { "history_forward", mode = { "i", "n" } },
            ["<C-k>"] = { "history_back", mode = { "i", "n" } },
            ["<C-h>"] = { "toggle_help_input", mode = { "i", "n" } },
            -- TODO: 正規表現切り替えやignoredはなぜか効かない...
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
    },
  },
  init = function()
    vim.api.nvim_create_autocmd("ColorScheme", {
      callback = function()
        vim.api.nvim_set_hl(0, "SnacksPickerDir", { link = "LineNr" })
        vim.api.nvim_set_hl(0, "SnacksDashboardHeader", { fg = "#57A143" })
      end,
    })
  end,
}
