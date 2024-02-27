return {
  "neovim/nvim-lspconfig",
  dependencies = {
    { "hrsh7th/cmp-nvim-lsp" },
    { "hrsh7th/nvim-cmp" },
    { "hrsh7th/cmp-buffer" },
    { "hrsh7th/cmp-path" },
    { "hrsh7th/cmp-cmdline" },
    { "b0o/schemastore.nvim" },
    { "onsails/lspkind.nvim" },
    { "L3MON4D3/LuaSnip" },
    { "saadparwaiz1/cmp_luasnip" },
  },
  config = function()
    ----------------------------------
    -- nvim-cmp
    ----------------------------------
    local cmp = require("cmp")
    local luasnip = require("luasnip")
    local lspkind = require("lspkind")
    require("luasnip.loaders.from_snipmate").lazy_load()

    cmp.setup({
      completion = {
        completeopt = "menu,menuone,noinsert",
      },
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
        ["<F5>"] = cmp.mapping.complete(),
        ["<CR>"] = cmp.mapping.confirm({
          behavior = cmp.ConfirmBehavior.Replace,
          select = true,
        }),
        ["<C-p>"] = cmp.mapping.abort(),
        ["<Tab>"] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_next_item()
          elseif luasnip.expand_or_jumpable() then
            luasnip.expand_or_jump()
          else
            fallback()
          end
        end, { "i", "s" }),
        ["<S-Tab>"] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_prev_item()
          elseif luasnip.jumpable(-1) then
            luasnip.jump(-1)
          else
            fallback()
          end
        end, { "i", "s" }),
      }),
      sources = cmp.config.sources({
        { name = "nvim_lsp" },
        { name = "luasnip" },
        { name = "buffer" },
        { name = "path" },
      }),
      formatting = {
        format = lspkind.cmp_format({
          mode = "symbol",
          maxwidth = 50,
          ellipsis_char = "...",
          show_labelDetails = true,
        }),
      },
    })

    cmp.setup.cmdline(":", {
      completion = {
        completeopt = "menu,menuone,noinsert,noselect",
      },
      mapping = cmp.mapping.preset.cmdline(),
      sources = cmp.config.sources({
        { name = "path" },
      }, {
        {
          name = "cmdline",
          option = {
            ignore_cmds = { "Man", "!" },
          },
        },
      }),
    })

    ----------------------------------
    -- lspconfig
    ----------------------------------
    local lspconfig = require("lspconfig")
    require("lspconfig.ui.windows").default_options.border = "single"

    local capabilities = require("cmp_nvim_lsp").default_capabilities()
    capabilities.textDocument.completion.completionItem.snippetSupport = true

    -- TODO: 整理
    lspconfig.ruff_lsp.setup({ capabilities = capabilities })
    -- lspconfig.pyright.setup({ capabilities = capabilities })

    lspconfig.gopls.setup({ capabilities = capabilities })
    lspconfig.cssls.setup({ capabilities = capabilities })
    lspconfig.html.setup({ capabilities = capabilities })
    lspconfig.emmet_language_server.setup({ capabilities = capabilities })
    lspconfig.marksman.setup({ capabilities = capabilities })
    lspconfig.bashls.setup({ capabilities = capabilities })
    lspconfig.svelte.setup({ capabilities = capabilities })

    lspconfig.rust_analyzer.setup({
      capabilities = capabilities,
      settings = {
        ["rust-analyzer"] = {
          check = {
            command = "clippy",
          },
        },
      },
    })

    lspconfig.biome.setup({
      capabilities = capabilities,
      cmd = { "npx", "biome", "lsp-proxy" },
    })

    lspconfig.jsonls.setup({
      capabilities = capabilities,
      settings = {
        json = {
          schemas = require("schemastore").json.schemas(),
          validate = { enable = true },
        },
      },
    })

    lspconfig.yamlls.setup({
      capabilities = capabilities,
      settings = {
        yaml = {
          schemaStore = {
            enable = false,
            url = "",
          },
          schemas = require("schemastore").yaml.schemas({
            extra = {
              {
                description = "Bitbucke Pipelines",
                fileMatch = "bitbucket-pipelines.yml",
                name = "bitbucket-pipelines.yml",
                url = "https://bitbucket.org/atlassianlabs/intellij-bitbucket-references-plugin/raw/f9f41a5d1e7b3d25236b15296eb26eba426c6895/src/main/resources/schemas/bitbucket-pipelines.schema.json",
              },
            },
          }),
        },
      },
    })

    -- [Volar] localのnode_modulesを優先する
    local util = require("lspconfig.util")

    local function get_typescript_server_path(root_dir)
      local home = os.getenv("HOME")
      local global_ts = home .. "/.local/share/mise/installs/node/18/lib/node_modules/typescript/lib"
      local found_ts = ""
      local function check_dir(path)
        found_ts = util.path.join(path, "node_modules", "typescript", "lib")
        if util.path.exists(found_ts) then
          return path
        end
      end
      if util.search_ancestors(root_dir, check_dir) then
        return found_ts
      else
        return global_ts
      end
    end

    -- VueやNuxtのプロジェクトでのみ有効にする
    lspconfig.volar.setup({
      filetypes = { "typescript", "javascript", "javascriptreact", "typescriptreact", "vue", "json" },
      capabilities = capabilities,
      root_dir = util.root_pattern("vite.config.ts", "nuxt.config.ts", "nuxt.config.js"),
      on_new_config = function(new_config, new_root_dir)
        new_config.init_options.typescript.tsdk = get_typescript_server_path(new_root_dir)
      end,
    })
    -- VueやNuxtのプロジェクトでなければtsserverを使う
    lspconfig.tsserver.setup({
      capabilities = capabilities,
      single_file_support = false,
      root_dir = function(fname)
        -- VueやNuxtのプロジェクトではVolarに任せるので無効にする
        if util.root_pattern("vite.config.ts", "nuxt.config.ts")(fname) then
          return nil
        end
        return util.root_pattern("tsconfig.json")(fname)
      end,
    })

    lspconfig.tailwindcss.setup({
      capabilities = capabilities,
      root_dir = util.root_pattern(
        "tailwind.config.js",
        "tailwind.config.cjs",
        "tailwind.config.mjs",
        "tailwind.config.ts"
      ),
    })

    lspconfig.lua_ls.setup({
      capabilities = capabilities,
      on_init = function(client)
        local path = client.workspace_folders[1].name
        if not vim.loop.fs_stat(path .. "/.luarc.json") and not vim.loop.fs_stat(path .. "/.luarc.jsonc") then
          client.config.settings = vim.tbl_deep_extend("force", client.config.settings, {
            Lua = {
              runtime = {
                version = "LuaJIT",
              },
              workspace = {
                checkThirdParty = false,
                library = {
                  vim.env.VIMRUNTIME,
                },
              },
            },
          })

          client.notify("workspace/didChangeConfiguration", { settings = client.config.settings })
        end
        return true
      end,
    })

    -- LSP key bindings
    vim.api.nvim_create_autocmd("LspAttach", {
      group = vim.api.nvim_create_augroup("UserLspConfig", {}),
      callback = function(ev)
        -- Enable completion triggered by <c-x><c-o>
        vim.bo[ev.buf].omnifunc = "v:lua.vim.lsp.omnifunc"

        local opts = { buffer = ev.buf }
        -- 定義に移動
        vim.keymap.set("n", "<C-]>", vim.lsp.buf.definition, opts)
        vim.keymap.set("n", "<M-]>", function()
          vim.cmd([[ vsplit ]])
          vim.lsp.buf.definition()
        end, opts)
        -- 定義をホバー
        vim.keymap.set("n", "<M-s>", "<cmd>Lspsaga hover_doc<CR>", opts)
        -- 実装へ移動
        vim.keymap.set("n", "<C-j>i", vim.lsp.buf.implementation, opts)
        -- 実装をホバー
        vim.keymap.set("n", "<M-d>", "<cmd>Lspsaga peek_definition<CR>", opts)
        -- 呼び出し元一覧 (qflist)
        -- vim.keymap.set("n", "<C-j>h", vim.lsp.buf.references, opts)
        -- 実装と呼び出し元の同時表示
        vim.keymap.set("n", "<C-j>u", "<cmd>Lspsaga finder<CR>", opts)
        -- リネーム
        vim.keymap.set({ "n", "i" }, "<S-M-r>", "<cmd>Lspsaga rename<CR>", opts)
        -- Code action
        vim.keymap.set({ "n", "i" }, "<M-CR>", "<cmd>Lspsaga code_action<CR>", opts)
        -- 次の診断へ移動
        vim.keymap.set("n", "<M-j>", "<cmd>Lspsaga diagnostic_jump_next<CR>", opts)
        -- 前の診断へ移動
        vim.keymap.set("n", "<M-k>", "<cmd>Lspsaga diagnostic_jump_prev<CR>", opts)

        -- ターミナル (Lspsagaなのでここ)
        vim.keymap.set("n", "<Space>i", "<cmd>Lspsaga term_toggle<CR>", opts)

        -- 保存時に自動フォーマット
        vim.api.nvim_create_autocmd("BufWritePre", {
          pattern = { "*.rs", "*.py" },
          callback = function()
            vim.lsp.buf.format({
              buffer = ev.buf,
              async = false,
            })
          end,
        })
      end,
    })

    local signs = { Error = " ", Warn = " ", Hint = "󱩎 ", Info = " " }
    for type, icon in pairs(signs) do
      local hl = "DiagnosticSign" .. type
      vim.fn.sign_define(hl, { text = icon, texthl = hl })
    end

    -- -- import最適化
    -- { '<M-o>', ':call CocAction(\'runCommand\', \'editor.action.organizeImport\')<CR>', silent = true },
  end,
}
