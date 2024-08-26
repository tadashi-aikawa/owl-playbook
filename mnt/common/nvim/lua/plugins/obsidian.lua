return {
  "epwalsh/obsidian.nvim",
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

      local cur = 1
      while true do
        local st, ed = string.find(line, "%[%[.-%]%]", cur)
        if not st then
          break
        end
        if col < st then
          vim.api.nvim_win_set_cursor(vim.api.nvim_get_current_win(), { row, st + 1 })
          break
        end
        if col <= ed then
          break
        end
        cur = ed + 1
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

      -- 新規ノートは常にVault rootに
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

    vim.keymap.set("n", "<C-j>h", ":ObsidianBacklinks<CR>", { silent = true })
  end,
}
