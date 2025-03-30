-- 挨拶メッセージを非表示
vim.opt.shortmess:append("I")

-----------------------------------------------------
-- 挙動
-----------------------------------------------------

-- 文字コード自動判別
vim.opt.fileencodings = "utf-8,sjis"
-- 改行コード自動判別
vim.opt.fileformats = "unix,dos,mac"
-- swapfileを作成しない
vim.opt.swapfile = false

-- タブを基本2文字に
vim.opt.tabstop = 2
vim.opt.shiftwidth = 0
-- タブの代わりにスペースを挿入する
vim.opt.expandtab = true
-- 行末の1文字先までカーソルを移動できるように
vim.opt.virtualedit = "onemore"
-- 検索文字列が小文字の場合は大文字小文字を区別なく検索する
vim.opt.ignorecase = true
-- 検索時に大文字を含んでいたら大/小を区別
vim.opt.smartcase = true
-- スクロールした時 常に下に表示するバッファ行の数
vim.opt.scrolloff = 5
-- 分割方向
vim.opt.splitright = true
vim.opt.splitbelow = true

-- 最後に開いていた行を開く
vim.cmd([[
  augroup vimrcEx
    au BufRead * if line("'\"") > 0 && line("'\"") <= line("$") | exe "normal g`\"" | endif
  augroup END
]])

-- 外部からファイルを変更されたら反映する
vim.api.nvim_create_autocmd({ "WinEnter", "FocusGained" }, {
  pattern = "*",
  command = "checktime",
})

-- quick fix listは横に最大で開く
vim.api.nvim_create_autocmd("FileType", {
  pattern = "qf",
  callback = function()
    vim.cmd("wincmd J")
  end,
})

-- LSPアタッチされたあとの設定
-- TODO: 分離できる? group指定はいる?
vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("UserLspConfig", {}),
  callback = function(ev)
    if vim.bo[ev.buf].filetype == "markdown" then
      return
    end

    -- Enable completion triggered by <c-x><c-o>
    vim.bo[ev.buf].omnifunc = "v:lua.vim.lsp.omnifunc"

    local opts = { buffer = ev.buf }
    -- 定義に移動 (Lspsaga goto_definition は期待しない定義に飛んでしまうことがある)
    vim.keymap.set("n", "<C-]>", vim.lsp.buf.definition, opts)
    vim.keymap.set("n", "<M-]>", function()
      vim.cmd([[ vsplit ]])
      vim.lsp.buf.definition()
    end, opts)
    vim.keymap.set("n", "g<C-]>", function()
      vim.cmd([[ split ]])
      vim.lsp.buf.definition()
    end, opts)
    -- 定義をホバー
    vim.keymap.set("n", "<M-s>", "<cmd>Lspsaga hover_doc<CR>", opts)
    -- 実装へ移動
    vim.keymap.set("n", "<C-j>i", vim.lsp.buf.implementation, opts)
    -- 実装をホバー
    vim.keymap.set("n", "<M-d>", "<cmd>Lspsaga peek_definition<CR>", opts)
    -- 型の実装をホバー
    vim.keymap.set("n", "<M-i>", "<cmd>Lspsaga peek_type_definition<CR>", opts)
    -- 呼び出し元の表示
    vim.keymap.set("n", "<C-j>u", "<cmd>Lspsaga finder ref<CR>", opts)
    -- リネーム
    vim.keymap.set({ "n", "i" }, "<S-M-r>", "<cmd>Lspsaga rename<CR>", opts)
    -- ファイルリネーム
    vim.keymap.set("n", "<C-j>2", vim.lsp.buf.rename, opts)
    -- Code action
    vim.keymap.set({ "n", "i" }, "<M-CR>", "<cmd>Lspsaga code_action<CR>", opts)

    -- 次の診断へ移動
    vim.keymap.set("n", "<M-j>", function()
      vim.diagnostic.goto_next({ float = false })
    end, opts)
    -- 前の診断へ移動
    vim.keymap.set("n", "<M-k>", function()
      vim.diagnostic.goto_prev({ float = false })
    end, opts)

    -- 診断をフローティングウィンドウで表示する
    vim.keymap.set("n", "<M-w>", function()
      vim.diagnostic.open_float({
        scope = "cursor",
        focusable = true,
        border = "rounded",
      })
    end, opts)

    -- LSP再起動
    vim.keymap.set("n", "<C-j><C-r>", "<cmd>LspRestart<CR>", opts)

    local client = vim.lsp.get_client_by_id(ev.data.client_id)
    if client == nil then
      return
    end

    -- 保存時に自動フォーマット
    local augroup = vim.api.nvim_create_augroup("LspFormatting", {})
    if client.supports_method("textDocument/formatting") then
      local set_auto_format = function(lsp_name, pattern)
        if client.name == lsp_name then
          print(string.format("[%s] Enable auto-format on save", lsp_name))
          vim.api.nvim_clear_autocmds({ group = augroup })
          vim.api.nvim_create_autocmd("BufWritePre", {
            group = augroup,
            pattern = pattern,
            callback = function()
              print("[LSP] " .. client.name .. " format")
              vim.lsp.buf.format({ buffer = ev.buf, async = false })
            end,
          })
        end
      end

      set_auto_format("rust_analyzer", { "*.rs" })
      set_auto_format("denols", { "*.ts", "*.js" })
      set_auto_format("gopls", { "*.go" })
    end

    -- inlay hint
    if client.supports_method("textDocument/inlayHint") then
      vim.lsp.inlay_hint.enable()
    end

    -- 深刻度が高い方を優先して表示
    vim.diagnostic.config({ severity_sort = true })

    local signs = { Error = "●", Warn = "●", Hint = "●", Info = "●" }
    vim.diagnostic.config({
      signs = {
        text = {
          [vim.diagnostic.severity.ERROR] = signs.Error,
          [vim.diagnostic.severity.WARN] = signs.Warn,
          [vim.diagnostic.severity.INFO] = signs.Info,
          [vim.diagnostic.severity.HINT] = signs.Hint,
        },
      },
    })
  end,
})
