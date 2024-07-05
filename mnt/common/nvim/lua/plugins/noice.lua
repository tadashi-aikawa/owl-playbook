return {
  "folke/noice.nvim",
  event = "VeryLazy",
  opts = {},
  dependencies = {
    "MunifTanjim/nui.nvim",
    "rcarriga/nvim-notify",
  },
  config = function()
    require("noice").setup({
      lsp = {
        signature = {
          enabled = false,
        },
      },
      presets = {
        command_palette = true,
      },
      messages = {
        enabled = true,
        view = "mini",
        view_error = "notify",
        view_warn = "notify",
        view_history = "messages",
        view_search = false,
      },
      routes = {
        {
          filter = {
            any = {
              { event = "msg_show", error = true, find = "E486:" },
              { event = "msg_show", find = "No lines in buffer" },
              { event = "msg_show", find = "%d+ lines? yanked" },
              { event = "msg_show", find = "%d+ more lines?" },
              { event = "msg_show", find = "%d+ less lines?" },
              { event = "msg_show", find = "fewer line" },
              { event = "msg_show", find = "lines >ed 1 time" },
              { event = "msg_show", find = "changes?; before" },
              { event = "msg_show", find = "changes?; after" },
            },
          },
          opts = { skip = true },
        },
        {
          filter = {
            any = {
              { event = "msg_show", error = true, find = "E20:" },
              { event = "msg_show", error = true, find = "E42:" },
              { event = "msg_show", error = true, find = "E492:" },
              { event = "msg_show", error = true, find = "E5107:" },
              { event = "msg_show", warning = true, find = "search hit BOTTOM, continuing at TOP" },
              { event = "msg_show", warning = true, find = "search hit TOP, continuing at BOTTOM" },
              { event = "notify", kind = "info", find = "was properly created" },
              { event = "notify", kind = "info", find = "was properly removed" },
              { event = "notify", kind = "info", find = "added to clipboard" },
              { event = "notify", kind = "info", find = " -> " },
              { event = "notify", kind = "info", find = "No information available" },
              { event = "notify", kind = "info", find = "No code actions available" },
            },
          },
          view = "mini",
        },
      },
    })
  end,
}
