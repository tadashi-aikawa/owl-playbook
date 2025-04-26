return {
  "saghen/blink.cmp",
  dependencies = {
    "L3MON4D3/LuaSnip",
    { "saghen/blink.compat", lazy = true, version = "*" },
  },
  event = { "InsertEnter", "CmdlineEnter" },
  version = "*",
  ---@module 'blink.cmp'
  ---@type blink.cmp.Config
  opts = {
    keymap = {
      preset = "enter",
      ["<F5>"] = { "show", "show_documentation", "hide_documentation" },
    },
    completion = {
      documentation = { auto_show = true, window = { border = "rounded" } },
      menu = {
        border = "rounded",
        draw = {
          treesitter = { "lsp" },
          components = {
            kind_icon = {
              text = function(ctx)
                local icon = ctx.kind_icon
                if ctx.item.source_name == "LSP" then
                  local color_item =
                    require("nvim-highlight-colors").format(ctx.item.documentation, { kind = ctx.kind })
                  if color_item and color_item.abbr ~= "" then
                    icon = color_item.abbr
                  end
                end
                return icon .. ctx.icon_gap
              end,
              highlight = function(ctx)
                local highlight = "BlinkCmpKind" .. ctx.kind
                if ctx.item.source_name == "LSP" then
                  local color_item =
                    require("nvim-highlight-colors").format(ctx.item.documentation, { kind = ctx.kind })
                  if color_item and color_item.abbr_hl_group then
                    highlight = color_item.abbr_hl_group
                  end
                end
                return highlight
              end,
            },
          },
        },
      },
    },
    signature = { window = { border = "rounded" } },
    snippets = { preset = "luasnip" },
    sources = {
      default = { "dictionary", "lsp", "path", "snippets", "buffer" },
      per_filetype = {
        lua = { "dictionary", "lazydev", "lsp", "path", "snippets", "buffer" },
        markdown = { "obsidian", "dictionary", "path", "snippets" },
      },
      providers = {
        lazydev = {
          name = "LazyDev",
          module = "lazydev.integrations.blink",
          score_offset = 100,
        },
        dictionary = {
          module = "blink-cmp-dictionary",
          name = "Dict",
          min_keyword_length = 3,
          opts = {
            dictionary_files = {
              vim.fn.stdpath("config") .. "/lua/envs/cmp-dictionary.txt",
            },
          },
        },
        obsidian = {
          name = "obsidian",
          module = "blink.compat.source",
          score_offset = 1000,
        },
        -- FIXME: 初回に表示されないことがある問題
        -- snippets = {
        --   transform_items = function(ctx, items)
        --     local ch = string.sub(ctx.get_keyword(), 1, 1)
        --     if ch == "_" then
        --       return items
        --     end
        --     return {}
        --   end,
        -- },
      },
    },
  },
  opts_extend = { "sources.default" },
  init = function()
    vim.api.nvim_create_autocmd("ColorScheme", {
      callback = function()
        vim.api.nvim_set_hl(0, "BlinkCmpMenuBorder", { fg = "#565656" })
        vim.api.nvim_set_hl(0, "BlinkCmpDocBorder", { fg = "#565656" })
        vim.api.nvim_set_hl(0, "BlinkCmpSignatureBorder", { fg = "#565656" })
        vim.api.nvim_set_hl(0, "FloatBorder", { fg = "#565656" })
      end,
    })
  end,
}
