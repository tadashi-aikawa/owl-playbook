return {
  "saghen/blink.cmp",
  dependencies = { "L3MON4D3/LuaSnip" },
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
      default = { "dictionary", "lazydev", "lsp", "path", "snippets", "buffer" },
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
      },
    },
  },

  opts_extend = { "sources.default" },
}
