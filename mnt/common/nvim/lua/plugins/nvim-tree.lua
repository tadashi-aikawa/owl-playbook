vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

return {
  "nvim-tree/nvim-tree.lua",
  dependencies = {
    "nvim-tree/nvim-web-devicons",
  },
  keys = {
    { "<M-w>",  ":NvimTreeToggle<CR>",   silent = true },
    { "<C-j>w", ":NvimTreeFindFile<CR>", silent = true },
  },
  config = function()
    require("nvim-tree").setup({
      view = {
        preserve_window_proportions = true,
      },
      renderer = {
        icons = {
          glyphs = {
            git = {
              unstaged = "",
              staged = "󰆼",
              unmerged = "",
              renamed = "󰮆",
              untracked = "",
              deleted = "",
              ignored = "",
            },
          },
        },
      },

      diagnostics = {
        enable = true,
        show_on_dirs = true,
        show_on_open_dirs = true,
        icons = {
          hint = " ",
          info = " ",
          warning = " ",
          error = " ",
        },
      },

      on_attach = function(bufnr)
        local api = require("nvim-tree.api")
        local function opts(desc)
          return { desc = "nvim-tree: " .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
        end
        -- api.config.mappings.default_on_attach(bufnr)

        vim.keymap.set("n", ">", api.tree.change_root_to_node, opts("CD"))
        vim.keymap.set("n", "<", api.tree.change_root_to_parent, opts("Up"))
        vim.keymap.set("n", "<M-s>", api.node.show_info_popup, opts("Info"))
        vim.keymap.set("n", "<C-r>", api.fs.rename_sub, opts("Rename: Omit Filename"))
        vim.keymap.set("n", "gi", api.node.open.vertical, opts("Open: Vertical Split"))
        vim.keymap.set("n", "g-", api.node.open.horizontal, opts("Open: Horizontal Split"))
        vim.keymap.set("n", "<CR>", api.node.open.edit, opts("Open"))
        vim.keymap.set("n", "<Tab>", api.node.open.preview, opts("Open Preview"))
        vim.keymap.set("n", "a", api.fs.create, opts("Create File Or Directory"))
        vim.keymap.set("n", "bd", api.marks.bulk.delete, opts("Delete Bookmarked"))
        vim.keymap.set("n", "bt", api.marks.bulk.trash, opts("Trash Bookmarked"))
        vim.keymap.set("n", "bmv", api.marks.bulk.move, opts("Move Bookmarked"))
        vim.keymap.set("n", "<Space>k", api.node.navigate.git.prev, opts("Prev Git"))
        vim.keymap.set("n", "<Space>j", api.node.navigate.git.next, opts("Next Git"))
        vim.keymap.set("n", "d", api.fs.remove, opts("Delete"))
        vim.keymap.set("n", "F", api.live_filter.clear, opts("Live Filter: Clear"))
        vim.keymap.set("n", "f", api.live_filter.start, opts("Live Filter: Start"))
        vim.keymap.set("n", "g?", api.tree.toggle_help, opts("Help"))
        vim.keymap.set("n", "gy", api.fs.copy.relative_path, opts("Copy Relative Path"))
        vim.keymap.set("n", "gY", api.fs.copy.absolute_path, opts("Copy Absolute Path"))
        vim.keymap.set("n", "H", api.tree.toggle_hidden_filter, opts("Toggle Filter: Dotfiles"))
        vim.keymap.set("n", "I", api.tree.toggle_gitignore_filter, opts("Toggle Filter: Git Ignore"))
        vim.keymap.set("n", "m", api.marks.toggle, opts("Toggle Bookmark"))
        vim.keymap.set("n", "M", api.tree.toggle_no_bookmark_filter, opts("Toggle Filter: No Bookmark"))
        vim.keymap.set("n", "y", api.fs.copy.node, opts("Copy"))
        vim.keymap.set("n", "p", api.fs.paste, opts("Paste"))
        vim.keymap.set("n", "r", api.fs.rename, opts("Rename"))
        vim.keymap.set("n", "R", api.fs.rename_full, opts("Rename: Full Path"))
        vim.keymap.set("n", "U", api.tree.toggle_custom_filter, opts("Toggle Filter: Hidden"))
        vim.keymap.set("n", "<C-j><C-l>", api.tree.expand_all, opts("Expand All"))
        vim.keymap.set("n", "<C-j><C-h>", api.tree.collapse_all, opts("Collapse"))
        vim.keymap.set("n", "x", api.fs.cut, opts("Cut"))
        vim.keymap.set("n", "<2-LeftMouse>", api.node.open.edit, opts("Open"))
      end,
    })

    -- Git statusに変更があったときにNvimtreeの表示を変更させるために必要
    -- XXX: ここではないかも...
    vim.api.nvim_create_autocmd("User", {
      pattern = "NeogitStatusRefreshed",
      command = ":NvimTreeRefresh<CR>",
    })
  end,
}
