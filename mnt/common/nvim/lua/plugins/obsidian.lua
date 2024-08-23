return {
  "epwalsh/obsidian.nvim",
  version = "*", -- recommended, use latest release instead of latest commit
  lazy = true,
  ft = "markdown",
  -- Replace the above line with this if you only want to load obsidian.nvim for markdown files in your vault:
  -- event = {
  --   -- If you want to use the home shortcut '~' here you need to call 'vim.fn.expand'.
  --   -- E.g. "BufReadPre " .. vim.fn.expand "~" .. "/my-vault/*.md"
  --   -- refer to `:h file-pattern` for more examples
  --   "BufReadPre path/to/my-vault/*.md",
  --   "BufNewFile path/to/my-vault/*.md",
  -- },
  dependencies = {
    -- Required.
    "nvim-lua/plenary.nvim",

    -- see below for full list of optional dependencies 👇
  },
  config = function()
    require("obsidian").setup({
      workspaces = {
        {
          name = "work",
          path = "~/work/pkm",
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
    vim.keymap.set("n", "<M-]>", ":ObsidianFollowLink vsplit<CR>", { silent = true })
    vim.keymap.set("n", "g<C-]>", ":ObsidianFollowLink hsplit<CR>", { silent = true })
  end,
}
