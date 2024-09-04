return {
  -- 細かい挙動が色々気になるのでfork版
  dir = "~/git/github.com/tadashi-aikawa/obsidian.nvim",
  version = "*",
  lazy = true,
  ft = "markdown",
  dependencies = {
    "nvim-lua/plenary.nvim",
  },
  config = function()
    local forward_seek_gf = function()
      local line = vim.api.nvim_get_current_line()
      local row = vim.fn.line(".")
      local col = vim.fn.col(".")

      local get_cursor = function(pattern)
        local cur = 1
        while true do
          local st, ed = string.find(line, pattern, cur)
          if not st then
            return nil
          end
          if col < st then
            return st - 1
          end
          if col <= ed then
            return col - 1
          end
          cur = ed + 1
        end
      end

      local wiki_link_cursor = get_cursor("%[%[.-%]%]")
      local url_cursor = get_cursor("https?://[%w-_%.%?%.:/%+=&]+")
      if wiki_link_cursor == nil and url_cursor == nil then
        return
      end

      if wiki_link_cursor ~= nil and url_cursor == nil then
        vim.api.nvim_win_set_cursor(vim.api.nvim_get_current_win(), { row, wiki_link_cursor })
      end
      if wiki_link_cursor == nil and url_cursor ~= nil then
        vim.api.nvim_win_set_cursor(vim.api.nvim_get_current_win(), { row, url_cursor })
      end
      if wiki_link_cursor ~= nil and url_cursor ~= nil then
        vim.api.nvim_win_set_cursor(vim.api.nvim_get_current_win(), { row, math.min(wiki_link_cursor, url_cursor) })
      end

      if require("obsidian").util.cursor_on_markdown_link(nil, nil, true) then
        vim.cmd([[ :ObsidianFollowLink ]])
      else
        vim.cmd([[ gf ]])
      end
    end

    require("obsidian").setup({
      workspaces = {
        {
          name = "work",
          path = "~/work/pkm",
          ---@diagnostic disable-next-line: missing-fields
          overrides = {
            notes_subdir = "notes",
          },
        },
      },

      new_notes_location = "notes_subdir",
      -- 見た目の変更はしない
      ui = { enable = false },
      -- フロントマターの自動設定はしない
      disable_frontmatter = true,
      -- リンクの文字列をそのままファイル名に使う
      note_id_func = function(title)
        return title
      end,
      -- WindowsのChromeからURLを開く
      follow_url_func = function(url)
        vim.fn.jobstart({ "windows-chrome", url })
      end,
      -- <C-]>でリンク先を開く
      mappings = {
        ["<C-]>"] = {
          action = forward_seek_gf,
          opts = { noremap = false, expr = false, buffer = true },
        },
        ["<C-j>n"] = {
          action = function()
            vim.cmd([[
              vnew
              ObsidianNew
            ]])
          end,
          opts = { noremap = false, expr = false, buffer = true },
        },
        ["<C-j>h"] = {
          action = "<cmd>ObsidianBacklinks<CR>",
          opts = { noremap = false, expr = false, buffer = true },
        },
        ["<C-j>e"] = {
          mode = { "n", "i" },
          action = "<cmd>ObsidianQuickSwitch<CR>",
          opts = { noremap = false, expr = false, buffer = true },
        },
      },

      picker = {
        note_mappings = {
          new = "<F11>", -- Shift + Enter
          insert_link = "<M-CR>",
        },
        tag_mappings = {
          tag_note = "<F11>", -- Shift + Enter
          insert_tag = "<M-CR>",
        },
      },
    })

    vim.keymap.set("n", "<M-]>", function()
      vim.cmd([[ vsplit ]])
      forward_seek_gf()
    end, { silent = true })
    vim.keymap.set("n", "g<C-]>", function()
      vim.cmd([[ split ]])
      forward_seek_gf()
    end, { silent = true })
  end,
}
