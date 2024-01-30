# FIXME: format

return {
  "williamboman/mason-lspconfig.nvim",
  dependencies = {
    { "williamboman/mason.nvim" },
    { "neovim/nvim-lspconfig" },
    { "hrsh7th/cmp-nvim-lsp" },
    { "hrsh7th/nvim-cmp" },
    { "L3MON4D3/LuaSnip" },
    { "saadparwaiz1/cmp_luasnip" },
  },
  config = function()
    -- mason.nvim setup
    require("mason").setup()

    -- Auto install
    local packages = {
      "lua-language-server",
      "marksman"
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

    -- nvim-cmp
    local cmp = require("cmp")
    local luasnip = require("luasnip")
    require("luasnip.loaders.from_snipmate").lazy_load()
    cmp.setup {
      snippet = {
        expand = function(args)
          luasnip.lsp_expand(args.body)
        end,
      },
      window = {
        completion = cmp.config.window.bordered(),
        documentation = cmp.config.window.bordered(),
      },
      mapping = cmp.mapping.preset.insert({
        ['<F5>'] = cmp.mapping.complete(),
        ['<CR>'] = cmp.mapping.confirm {
          behavior = cmp.ConfirmBehavior.Replace,
          select = true,
        },
        ['<C-p>'] = cmp.mapping.abort(),
        ['<Tab>'] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_next_item()
          elseif luasnip.expand_or_jumpable() then
            luasnip.expand_or_jump()
          else
            fallback()
          end
        end, { 'i', 's' }),
        ['<S-Tab>'] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_prev_item()
          elseif luasnip.jumpable(-1) then
            luasnip.jump(-1)
          else
            fallback()
          end
        end, { 'i', 's' }),
      }),
      sources = cmp.config.sources({
        { name = 'nvim_lsp' },
        { name = 'luasnip' },
      }, { name = 'buffer' }),
    }

    -- Loading nvim-cmp
    local capabilities = require("cmp_nvim_lsp").default_capabilities()
    capabilities.textDocument.completion.completionItem.snippetSupport = true

    local lspconfig = require('lspconfig')
    require('lspconfig.ui.windows').default_options.border = 'single'

    lspconfig.biome.setup {
      capabilities = capabilities,
      cmd = { "npx", "biome", "lsp-proxy" }
    }
    lspconfig.volar.setup {
      filetypes = { 'typescript', 'javascript', 'javascriptreact', 'typescriptreact', 'vue', 'json' },
      capabilities = capabilities
    }
    lspconfig.gopls.setup {
      capabilities = capabilities
    }
    lspconfig.cssls.setup {
      capabilities = capabilities
    }
    lspconfig.marksman.setup {
      capabilities = capabilities
    }
    lspconfig.bashls.setup {
      capabilities = capabilities
    }

    -- For Neovim
    lspconfig.lua_ls.setup {
      capabilities = capabilities,
      on_init = function(client)
        local path = client.workspace_folders[1].name
        if not vim.loop.fs_stat(path .. '/.luarc.json') and not vim.loop.fs_stat(path .. '/.luarc.jsonc') then
          client.config.settings = vim.tbl_deep_extend('force', client.config.settings, {
            Lua = {
              runtime = {
                version = 'LuaJIT'
              },
              workspace = {
                checkThirdParty = false,
                library = {
                  vim.env.VIMRUNTIME
                }
              }
            }
          })

          client.notify("workspace/didChangeConfiguration", { settings = client.config.settings })
        end
        return true
      end
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
        vim.keymap.set('n', '<M-s>', "<cmd>Lspsaga hover_doc<CR>", opts)
        -- 実装へ移動
        vim.keymap.set('n', '<C-j>i', vim.lsp.buf.implementation, opts)
        -- 実装をホバー
        vim.keymap.set('n', '<M-d>', "<cmd>Lspsaga peek_definition<CR>", opts)
        -- 呼び出し元一覧 (qflist)
        vim.keymap.set('n', '<C-j>h', vim.lsp.buf.references, opts)
        -- 実装と呼び出し元の同時表示
        vim.keymap.set('n', '<C-j>u', "<cmd>Lspsaga finder<CR>", opts)
        -- 関数の引数表示
        vim.keymap.set({ 'n', 'i' }, '<C-p>', vim.lsp.buf.signature_help, opts)
        -- リネーム
        vim.keymap.set({ 'n', 'i' }, '<S-M-r>', "<cmd>Lspsaga rename<CR>", opts)
        -- Code action
        vim.keymap.set({ 'n', 'i' }, '<M-CR>', "<cmd>Lspsaga code_action<CR>", opts)
        -- 次の診断へ移動
        vim.keymap.set('n', '<M-j>', "<cmd>Lspsaga diagnostic_jump_next<CR>", opts)
        -- 前の診断へ移動
        vim.keymap.set('n', '<M-k>', "<cmd>Lspsaga diagnostic_jump_prev<CR>", opts)

        -- ターミナル (Lspsagaなのでここ)
        vim.keymap.set('n', '<Space>i', "<cmd>Lspsaga term_toggle<CR>", opts)

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
