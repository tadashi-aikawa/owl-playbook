return {
  dir = "~/git/github.com/tadashi-aikawa/silhouette.nvim",
  -- "tadashi-aikawa/silhouette.nvim",
  ft = "markdown",
  dependencies = {
    "vim-denops/denops.vim",
  },
  keys = {
    { "<Space>.", ":SilhouetteMoveToProgress<CR>", silent = true },
    {
      "<A-a>",
      function()
        vim.cmd([[
        SilhouettePushTimer
        GhostwriterWrite
      ]])
      end,
      silent = true,
    },
  },
  config = function()
    -- denops.nvimが起動し終わる前に実行されるとエラーになるためwaitを入れる
    -- マシンスペックや環境によって1000(ms)の値を調整する必要あり
    vim.defer_fn(function()
      require("silhouette").setup({
        task = {
          repetition_tasks_path = "./workspace/repetition-tasks.md",
          holidays_path = "./workspace/holidays.md",
        },
        timer = {
          time_storage_path = "./workspace/time-storage.json",
        },
      })
    end, 1000)
  end,
}
