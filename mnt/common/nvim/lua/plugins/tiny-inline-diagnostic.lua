return {
  "rachartier/tiny-inline-diagnostic.nvim",
  event = "LspAttach",
  priority = 1000,
  opts = {
    options = {
      show_source = true,
      multilines = {
        enabled = true,
        always_show = false,
      },
    },
  },
}
