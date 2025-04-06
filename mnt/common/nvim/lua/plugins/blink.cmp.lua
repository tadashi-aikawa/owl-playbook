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
        lsp = {
          opts = {
            tailwind_color_icon = "",
          },
        },
        snippets = {
          transform_items = function(ctx, items)
            local ch = string.sub(ctx.get_keyword(), 1, 1)
            if ch == "_" then
              return items
            end
            return {}
          end,
        },
      },
    },
  },

  opts_extend = { "sources.default" },
}
