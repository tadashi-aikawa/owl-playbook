vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("UserLspConfig", {}),
  callback = function(ev)
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
    vim.keymap.set("n", "<M-j>", "<cmd>Lspsaga diagnostic_jump_next<CR>", opts)
    -- 前の診断へ移動
    vim.keymap.set("n", "<M-k>", "<cmd>Lspsaga diagnostic_jump_prev<CR>", opts)

    -- LSP再起動
    vim.keymap.set("n", "<C-j>r", "<cmd>LspRestart<CR>", opts)

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
  end,
})
