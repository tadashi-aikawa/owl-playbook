return {
  "epwalsh/obsidian.nvim",
  version = "*",
  lazy = true,
  ft = "markdown",
  dependencies = {
    "nvim-lua/plenary.nvim",
  },
  config = function()
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
          action = function()
            return require("obsidian").util.gf_passthrough()
          end,
          opts = { noremap = false, expr = true, buffer = true },
        },
      },
    })

    vim.keymap.set("n", "<C-j>h", ":ObsidianBacklinks<CR>", { silent = true })
    vim.keymap.set("n", "<M-]>", function()
      vim.cmd([[ vsplit ]])
      vim.cmd([[ :ObsidianFollowLink ]])
    end, { silent = true })
    vim.keymap.set("n", "g<C-]>", ":ObsidianFollowLink hsplit<CR>", { silent = true })
  end,
}
