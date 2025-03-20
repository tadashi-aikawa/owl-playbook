-----------------------------------------------------
-- キーバインド
-----------------------------------------------------
-- プラグインのキーバインドはプラグインの方で行う

-- Hippie completion
vim.keymap.set("i", "<F18>", "<C-x><C-p>") -- Ubuntu(WSL)ではS-F6がF18となるため

-- cnext / cprevious
vim.keymap.set("n", "<Space>J", ":cnext<CR>", { silent = true })
vim.keymap.set("n", "<Space>K", ":cprevious<CR>", { silent = true })
-- quickfix list open
vim.keymap.set("n", "<Space>L", ":botright cw<CR>", { silent = true })
-- URLをブラウザで開く
vim.keymap.set("n", "go", ":ObsidianFollowLink<CR>", { silent = true })

-- バッファ切り替え
vim.keymap.set("n", "<Space>r", ":b#<CR>", { silent = true })
vim.keymap.set("n", "<Space>e", ":BufferPick<CR>", { silent = true })
vim.keymap.set("n", "<Space>l", ":BufferNext<CR>", { silent = true })
vim.keymap.set("n", "<Space>h", ":BufferPrevious<CR>", { silent = true })
vim.keymap.set("n", "<Space>q", ":Bdelete<CR>", { silent = true })
vim.keymap.set("n", "<Space>c", ":BufferCloseAllButVisible<CR>", { silent = true })

-- windows split
vim.keymap.set("n", "<C-w><F12>", ":vsplit<CR>", { silent = true })
-- tab split
vim.keymap.set("n", "<C-w>t", ":tab split<CR>", { silent = true })
-- 行補完
vim.keymap.set("i", "<C-l>", "<C-x><C-l>", { silent = true })

-- diff
local function update_diff_maps()
  local buf = vim.api.nvim_get_current_buf()

  if vim.o.diff then
    vim.keymap.set("n", "<Space>k", "[c", { buffer = buf, desc = "前の差分に移動" })
    vim.keymap.set("n", "<Space>j", "]c", { buffer = buf, desc = "次の差分に移動" })
  else
    pcall(function()
      vim.keymap.del("n", "<Space>k", { buffer = buf })
    end)
    pcall(function()
      vim.keymap.del("n", "<Space>j", { buffer = buf })
    end)
  end
end
vim.api.nvim_create_autocmd({ "BufEnter", "OptionSet" }, {
  pattern = { "*", "diff" },
  callback = update_diff_maps,
})

-- lazy.nvim
vim.keymap.set("n", "glp", ":Lazy profile<CR>", { silent = true })
vim.keymap.set("n", "gls", ":Lazy sync<CR>", { silent = true })

-- markdown装飾
vim.keymap.set("n", "<Space>b", function()
  vim.cmd("normal ysiW*.")
end, { silent = true })
vim.keymap.set("n", "<Space>@", function()
  vim.cmd("normal ysiW`")
end, { silent = true })

-- Marpの強調タスクを取り消しに変更
vim.keymap.set("n", "<Space>-", ":s/*/\\~/g<CR>", { silent = true })
-- ghostwriter.nvimのタスク状態を初期化
vim.keymap.set("n", "<Space>_", ":s/\\v- \\[.\\] (.+) `.+`/- [ ] \\1/<CR><Cmd>nohlsearch<CR>", { silent = true })

-- カレントウィンドウのファイル相対パスをコピー
vim.keymap.set("n", "<Space>y", function()
  local relative_path = vim.fn.expand("%:~:.")
  vim.fn.setreg("+", relative_path)
  vim.notify("Copy: " .. relative_path)
end, { silent = true })

-- Markdownファイルだけに発生するプラグイン間連携の特殊処理
vim.api.nvim_create_autocmd("FileType", {
  desc = "markdown-toggle.nvim keymaps",
  pattern = { "markdown", "markdown.mdx" },
  callback = function(args)
    local opts = { silent = true, noremap = true, buffer = args.buf }
    local toggle = require("markdown-toggle")

    -- F12はCtrl+Enter
    vim.keymap.set({ "n", "v" }, "<F12>", function()
      toggle.checkbox()
      local cline = vim.api.nvim_get_current_line()
      if string.find(cline, "- %[x%] .+ ``") then
        vim.cmd("SilhouettePushTimer")
      end
    end, opts)
    vim.keymap.set({ "i" }, "<F12>", function()
      vim.api.nvim_command("stopinsert")
      vim.schedule(function()
        toggle.checkbox()
      end)
      vim.schedule(function()
        vim.api.nvim_command("startinsert")
      end)
    end, opts)
  end,
})

-- avante.nvimのresults windowでESCを押すと閉じてしまう問題を防ぐ
-- https://github.com/yetone/avante.nvim/issues/917
vim.api.nvim_create_autocmd("FileType", {
  pattern = "Avante",
  callback = function()
    vim.keymap.set({ "n", "o" }, "<ESC>", "<Nop>", { buffer = true })
  end,
})
