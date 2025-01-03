return {
  "neovim/nvim-lspconfig",
  dependencies = {
    "L3MON4D3/LuaSnip",
    "saadparwaiz1/cmp_luasnip",
    { "hrsh7th/cmp-nvim-lsp" },
    { "hrsh7th/nvim-cmp" },
    { "hrsh7th/cmp-buffer" },
    { "hrsh7th/cmp-path" },
    { "hrsh7th/cmp-cmdline" },
    {
      "MattiasMTS/cmp-dbee",
      dependencies = {
        { "kndndrj/nvim-dbee" },
      },
      ft = "sql",
      opts = {},
    },
    { "b0o/schemastore.nvim" },
    { "onsails/lspkind.nvim" },
  },
  event = "InsertEnter", -- Telescope起動時にロードされるが、逆にBufreadの負荷が分散されてGOOD
  config = function()
    ----------------------------------
    -- nvim-cmp
    ----------------------------------
    local cmp = require("cmp")
    local luasnip = require("luasnip")
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
          select = true,
        }),
        ["<C-p>"] = cmp.mapping.abort(),
        ["<Tab>"] = cmp.mapping(function(fallback)
          if luasnip.expand_or_locally_jumpable() then
            luasnip.expand_or_jump()
          else
            fallback()
          end
        end, { "i", "s" }),
        ["<S-Tab>"] = cmp.mapping(function(fallback)
          if luasnip.locally_jumpable(-1) then
            luasnip.jump(-1)
          else
            fallback()
          end
        end, { "i", "s" }),
      }),
      sources = cmp.config.sources({
        {
          name = "nvim_lsp",
          option = {
            markdown_oxide = {
              keyword_pattern = [[\(\k\| \|\/\|#\)\+]],
            },
          },
        },
        { name = "luasnip" },
        { name = "buffer" },
        { name = "path" },
        { name = "lazydev", group_index = 0 },
        { name = "cmp-dbee" },
      }),
      formatting = {
        format = function(entry, item)
          local color_item = require("nvim-highlight-colors").format(entry, { kind = item.kind })
          item = require("lspkind").cmp_format({
            mode = "symbol",
            maxwidth = 50,
            ellipsis_char = "...",
            show_labelDetails = true,
          })(entry, item)
          if color_item.abbr_hl_group then
            item.kind_hl_group = color_item.abbr_hl_group
            item.kind = color_item.abbr
          end
          return item
        end,
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
    local util = require("lspconfig.util")
    local lspconfig = require("lspconfig")
    require("lspconfig.ui.windows").default_options.border = "single"

    local capabilities = require("cmp_nvim_lsp").default_capabilities()
    capabilities.textDocument.completion.completionItem.snippetSupport = true
    -- ufo
    capabilities.textDocument.foldingRange = {
      dynamicRegistration = false,
      lineFoldingOnly = true,
    }

    -- lspconfig.markdown_oxide.setup({
    --   capabilities = vim.tbl_deep_extend("force", capabilities, {
    --     workspace = {
    --       didChangeWatchedFiles = {
    --         dynamicRegistration = true,
    --       },
    --     },
    --   }),
    -- })

    lspconfig.ruff.setup({ capabilities = capabilities })
    lspconfig.pyright.setup({ capabilities = capabilities })

    lspconfig.gopls.setup({
      capabilities = capabilities,
      settings = {
        gopls = {
          gofumpt = true,
        },
      },
    })
    lspconfig.golangci_lint_ls.setup({ capabilities = capabilities })
    lspconfig.cssls.setup({ capabilities = capabilities })
    lspconfig.html.setup({ capabilities = capabilities })
    lspconfig.emmet_language_server.setup({ capabilities = capabilities })
    lspconfig.bashls.setup({ capabilities = capabilities })
    lspconfig.svelte.setup({ capabilities = capabilities })
    lspconfig.jdtls.setup({ capabilities = capabilities })
    lspconfig.gleam.setup({ capabilities = capabilities })
    lspconfig.denols.setup({
      capabilities = capabilities,
      root_dir = util.root_pattern("deno.json", "deno.jsonc"),
    })

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

    -- VueだけでなくTypeScriptやReactもVolarを使う
    lspconfig.volar.setup({
      capabilities = capabilities,
      filetypes = { "typescript", "javascript", "javascriptreact", "typescriptreact", "vue" },
      init_options = {
        vue = {
          hybridMode = false,
        },
        typescript = {
          tsdk = os.getenv("HOME")
            .. "/.local/share/mise/installs/npm-typescript/latest/lib/node_modules/typescript/lib/",
        },
      },
      on_new_config = function(new_config, new_root_dir)
        local lib_path = vim.fs.find("node_modules/typescript/lib", { path = new_root_dir, upward = true })[1]
        if lib_path then
          new_config.init_options.typescript.tsdk = lib_path
        end
      end,
      root_dir = util.root_pattern(
        "package.json",
        "manifest.json" -- Chrome Extension
      ),
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
        if client.workspace_folders then
          local path = client.workspace_folders[1].name
          if vim.uv.fs_stat(path .. "/.luarc.json") or vim.uv.fs_stat(path .. "/.luarc.jsonc") then
            return
          end
        end

        client.config.settings.Lua = vim.tbl_deep_extend("force", client.config.settings.Lua, {
          runtime = {
            version = "LuaJIT",
          },
          workspace = {
            checkThirdParty = false,
            library = {
              vim.env.VIMRUNTIME,
            },
          },
          hint = {
            enable = true,
            arrayIndex = "Disable",
            paramName = "Disable",
            semicolon = "Disable",
          },
          diagnostics = {
            groupFileStatus = {
              await = "Opened",
            },
          },
        })
      end,
      settings = {
        Lua = {},
      },
    })

    -- LSP key bindings
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

    local signs = { Error = " ", Warn = " ", Hint = "󱩎 ", Info = " " }
    for type, icon in pairs(signs) do
      local hl = "DiagnosticSign" .. type
      vim.fn.sign_define(hl, { text = icon, texthl = hl })
    end
  end,
}
