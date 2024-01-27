return {
  'jedrzejboczar/possession.nvim',
  dependencies = { 'nvim-lua/plenary.nvim' },
  config = function()
    -----------------------------------------------------
    -- 状態を保存して終了するRestartコマンド
    -- https://zenn.dev/nazo6/articles/neovim-restart-command
    -----------------------------------------------------
    local restart_cmd = nil

    vim.api.nvim_create_user_command("Restart", function()
      if vim.fn.has "gui_running" then
        if restart_cmd == nil then
          vim.notify("Restart command not found", vim.log.levels.WARN)
        end
      end

      require("possession.session").save("restart", { no_confirm = true })
      vim.cmd [[silent! bufdo bwipeout]]

      vim.g.NVIM_RESTARTING = true

      if restart_cmd then
        vim.cmd(restart_cmd)
      end

      vim.cmd [[qa!]]
    end, {})

    -- Restartコマンドで現状を維持したまま再起動するのに必要 (他にも設定箇所あり)
    vim.api.nvim_create_autocmd("VimEnter", {
      nested = true,
      callback = function()
        if vim.g.NVIM_RESTARTING then
          vim.g.NVIM_RESTARTING = false
          require("possession.session").load "restart"
          require("possession.session").delete("restart", { no_confirm = true })
          vim.opt.cmdheight = 1
        end
      end,
    })
  end
}
