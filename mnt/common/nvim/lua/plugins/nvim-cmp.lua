return {
  "hrsh7th/nvim-cmp",
  dependencies = {
    "L3MON4D3/LuaSnip",
    "saadparwaiz1/cmp_luasnip",
    { "hrsh7th/cmp-buffer" },
    { "hrsh7th/cmp-path" },
    { "hrsh7th/cmp-cmdline" },
    { "uga-rosa/cmp-dictionary" },
    { "b0o/schemastore.nvim" },
    { "onsails/lspkind.nvim" },
  },
  event = "InsertEnter", -- Telescope起動時にロードされるが、逆にBufreadの負荷が分散されてGOOD
  config = function()
    local cmp = require("cmp")
    local luasnip = require("luasnip")
    require("luasnip.loaders.from_snipmate").lazy_load()
    require("luasnip.loaders.from_lua").lazy_load()

    cmp.setup({
      enabled = function()
        local line = vim.api.nvim_get_current_line()
        local col = vim.fn.col(".") - 1
        if col <= 0 then
          return true
        end

        local char_before_cursor = line:sub(col, col)
        -- LuaSnipが暴発するので括弧に対しては補完が出ないようにする
        if char_before_cursor:match("[{}()%[%]]") then
          return false
        end

        return true
      end,
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
        },
        { name = "luasnip" },
        { name = "buffer" },
        { name = "path" },
        { name = "lazydev", group_index = 0 },
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

    -- markdownの場合だけdictionaryを有効にする
    cmp.setup.filetype("markdown", {
      sources = cmp.config.sources({
        {
          name = "nvim_lsp",
        },
        { name = "luasnip" },
        { name = "buffer" },
        { name = "path" },
        {
          name = "dictionary",
          keyword_length = 2,
        },
      }),
    })

    require("cmp_dictionary").setup({
      paths = { vim.fn.stdpath("config") .. "/lua/envs/cmp-dictionary.txt" },
      exact_length = 2,
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
  end,
}
