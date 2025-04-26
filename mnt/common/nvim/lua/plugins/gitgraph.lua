return {
  "isakbm/gitgraph.nvim",
  dependencies = { "sindrets/diffview.nvim" },
  opts = {
    symbols = {
      merge_commit = "○",
      commit = "●",
      merge_commit_end = "○",
      commit_end = "●",

      -- Advanced symbols
      GVER = "│",
      GHOR = "─",
      GCLD = "╮",
      GCRD = "╭",
      GCLU = "╯",
      GCRU = "╰",
      GLRU = "┴",
      GLRD = "┬",
      GLUD = "┤",
      GRUD = "├",
      GFORKU = "┼",
      GFORKD = "┼",
      GRUDCD = "├",
      GRUDCU = "┡",
      GLUDCD = "┪",
      GLUDCU = "┩",
      GLRDCL = "┬",
      GLRDCR = "┬",
      GLRUCL = "┴",
      GLRUCR = "┴",
    },
    format = {
      timestamp = " %y/%m/%d %H:%M",
      fields = { "branch_name", "tag", "timestamp", "author", "hash" },
    },
    hooks = {
      -- Check diff of a commit
      on_select_commit = function(commit)
        vim.notify("DiffviewOpen " .. commit.hash .. "^!")
        vim.cmd(":DiffviewOpen " .. commit.hash .. "^!")
      end,
      -- Check diff from commit a -> commit b
      on_select_range_commit = function(from, to)
        vim.notify("DiffviewOpen " .. from.hash .. "~1.." .. to.hash)
        vim.cmd(":DiffviewOpen " .. from.hash .. "~1.." .. to.hash)
      end,
    },
  },
  keys = {
    {
      "<space>G",
      function()
        require("gitgraph").draw({}, { all = true, max_count = 500 })
      end,
      desc = "GitGraph - Draw",
    },
  },
  init = function()
    vim.api.nvim_create_autocmd("ColorScheme", {
      callback = function()
        vim.api.nvim_set_hl(0, "GitGraphHash", { fg = "#777777" })
        vim.api.nvim_set_hl(0, "GitGraphTimestamp", { fg = "#facbcb" })
        vim.api.nvim_set_hl(0, "GitGraphAuthor", { fg = "#45cd78" })
        vim.api.nvim_set_hl(0, "GitGraphBranchName", { bg = "#888888", fg = "#efef33" })
        vim.api.nvim_set_hl(0, "GitGraphBranchTag", { bg = "#3d59a1" })
        vim.api.nvim_set_hl(0, "GitGraphBranchMsg", { fg = "lightgray" })
      end,
    })
  end,
}
