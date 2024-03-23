return {
  "MattesGroeger/vim-bookmarks",
  config = function()
    vim.g.bookmark_sign = "󰃀 "
    vim.g.bookmark_annotation_sign = "󱖯 "

    vim.keymap.set("n", "mm", "<Plug>BookmarkToggle", { silent = true })
    vim.keymap.set("n", "mi", "<Plug>BookmarkAnnotate", { silent = true })
    vim.keymap.set("n", "mo", "<Plug>BookmarkShowAll", { silent = true })
    vim.keymap.set("n", "mj", "<Plug>BookmarkNext", { silent = true })
    vim.keymap.set("n", "mk", "<Plug>BookmarkPrev", { silent = true })
    vim.keymap.set("n", "md", "<Plug>BookmarkClear", { silent = true })
    vim.keymap.set("n", "mD", "<Plug>BookmarkClearAll", { silent = true })
  end,
}
