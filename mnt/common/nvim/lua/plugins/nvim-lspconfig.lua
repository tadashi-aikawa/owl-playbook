return {
  "neovim/nvim-lspconfig",
  dependencies = { "saghen/blink.cmp", "b0o/schemastore.nvim" },
  event = { "BufReadPre", "BufNewFile" },
  config = function()
    local util = require("lspconfig.util")
    local lspconfig = require("lspconfig")
    require("lspconfig.ui.windows").default_options.border = "single"

    local capabilities = require("blink.cmp").get_lsp_capabilities({
      textDocument = {
        completion = {
          completionItem = {
            snippetSupport = true,
          },
        },
        foldingRange = {
          dynamicRegistration = false,
          lineFoldingOnly = true,
        },
      },
    })

    lspconfig.ruff.setup({
      capabilities = capabilities,
      single_file_support = false,
      root_dir = function(fname)
        return util.root_pattern("pyproject.toml", ".git")(fname)
          or vim.fs.dirname(vim.fs.find(".git", { path = fname, upward = true })[1])
      end,
    })
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

    lspconfig.sqls.setup({
      capabilities = capabilities,
      on_attach = function(client, bufnr)
        require("sqls").on_attach(client, bufnr)
      end,
    })

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

    lspconfig.eslint.setup({
      capabilities = capabilities,
      on_attach = function(_, bufnr)
        vim.api.nvim_create_autocmd("BufWritePre", {
          buffer = bufnr,
          command = "EslintFixAll",
        })
      end,
    })

    lspconfig.yamlls.setup({
      capabilities = capabilities,
      settings = {
        yaml = {
          customTags = {
            "!ENV scalar",
            "!ENV sequence",
          },
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
  end,
}
