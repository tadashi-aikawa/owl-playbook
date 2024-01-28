# FIXME: format

return {
  "williamboman/mason-lspconfig.nvim",
  dependencies = {
    { "williamboman/mason.nvim" },
    { "neovim/nvim-lspconfig" },
    { "hrsh7th/cmp-nvim-lsp" },
    { "hrsh7th/nvim-cmp" },
  },
  config = function()
    -- mason.nvim setup
    require("mason").setup()

    local packages = {
      "typescript-language-server",
      "lua-language-server",
      "gopls",
    }

    -- https://github.com/williamboman/mason.nvim/issues/1309#issuecomment-1555018732
    local registry = require "mason-registry"
    registry.refresh(function()
      for _, pkg_name in ipairs(packages) do
        local pkg = registry.get_package(pkg_name)
        if not pkg:is_installed() then
          pkg:install()
        end
      end
    end)

    require("mason-lspconfig").setup()

    -- Loading nvim-cmp
    local capabilities = require("cmp_nvim_lsp").default_capabilities()
    local lspconfig = require('lspconfig')

    local servers = {
      "tsserver",
      "lua_ls",
      "gopls",
    }

    for _, lsp in ipairs(servers) do
      lspconfig[lsp].setup {
        -- on_attach = my_custom_on_attach,
        capabilities = capabilities,
      }
    end

    -- nvim-cmp key bindings
    local cmp = require("cmp")
    cmp.setup {
      mapping = cmp.mapping.preset.insert({
        ['<F5>'] = cmp.mapping.complete(),
        ['<CR>'] = cmp.mapping.confirm {
          behavior = cmp.ConfirmBehavior.Replace,
          select = true,
        },
        ['<C-p>'] = cmp.mapping.abort(),
      }),
      sources = {
        { name = 'nvim_lsp' },
      },
    }

    -- LSP key bindings
    vim.api.nvim_create_autocmd('LspAttach', {
      group = vim.api.nvim_create_augroup('UserLspConfig', {}),
      callback = function(ev)
        -- Enable completion triggered by <c-x><c-o>
        vim.bo[ev.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'

        local opts = { buffer = ev.buf }
        -- 定義に移動
        vim.keymap.set('n', '<C-]>', vim.lsp.buf.definition, opts)
        -- 定義をホバー
        vim.keymap.set('n', '<M-s>', vim.lsp.buf.hover, opts)
        -- 実装へ移動
        vim.keymap.set('n', '<C-j>i', vim.lsp.buf.implementation, opts)
        -- 関数の引数表示
        vim.keymap.set({ 'n', 'i' }, '<C-p>', vim.lsp.buf.signature_help, opts)
        -- リネーム
        vim.keymap.set({ 'n', 'i' }, '<S-M-r>', vim.lsp.buf.rename, opts)
        -- Code action (TODO: 楽にしたい)
        vim.keymap.set({ 'n', 'i' }, '<M-CR>', vim.lsp.buf.code_action, opts)
        -- 呼び出し元一覧 (qflist)
        vim.keymap.set('n', '<C-j>h', vim.lsp.buf.references, opts)
        -- 次の診断へ移動
        vim.keymap.set('n', '<M-j>', vim.diagnostic.goto_next, opts)
        -- 前の診断へ移動
        vim.keymap.set('n', '<M-k>', vim.diagnostic.goto_prev, opts)
        -- TODO: 一旦このまま
        vim.keymap.set('n', '<space>f', function()
          vim.lsp.buf.format { async = true }
        end, opts)
      end,
    })

    -- -- import最適化
    -- { '<M-o>', ':call CocAction(\'runCommand\', \'editor.action.organizeImport\')<CR>', silent = true },

    -- -- TABでsnippets展開とplaceholder移動
    -- {
    --   "<tab>",
    --   '<Plug>(coc-snippets-expand-jump)',
    --   mode = "i",
    --   silent = true,
    -- },
  end
}


-- ['<Tab>'] = cmp.mapping(function(fallback)
--   if cmp.visible() then
--     cmp.select_next_item()
--   elseif luasnip.expand_or_jumpable() then
--     luasnip.expand_or_jump()
--   else
--     fallback()
--   end
-- end, { 'i', 's' }),
-- ['<S-Tab>'] = cmp.mapping(function(fallback)
--   if cmp.visible() then
--     cmp.select_prev_item()
--   elseif luasnip.jumpable(-1) then
--     luasnip.jump(-1)
--   else
--     fallback()
--   end
-- end, { 'i', 's' }),
