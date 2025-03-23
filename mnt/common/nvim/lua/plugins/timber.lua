return {
  "Goose97/timber.nvim",
  event = "LspAttach",
  keys = {
    {
      "gld",
      function()
        require("timber.actions").clear_log_statements({ global = false })
      end,
    },
    {
      "glt",
      function()
        require("timber.actions").search_log_statements()
      end,
    },
  },
  opts = {
    log_templates = {
      default = {
        javascript = [[console.log("%log_marker L%line_number %log_target", %log_target)]],
        typescript = [[console.log("%log_marker L%line_number %log_target", %log_target)]],
        lua = [[print("%log_marker L%line_number %log_target " .. %log_target)]],
        go = [[log.Printf("%log_marker L%line_number %log_target: %v\n", %log_target)]],
        rust = [[println!("%log_marker L%line_number %log_target: {:#?}", %log_target);]],
        python = [[print(f"%log_marker L%line_number {%log_target=}")]],
      },
    },
    batch_log_templates = {
      default = {
        javascript = [[console.log("%log_marker L%line_number", { %repeat<"%log_target": %log_target><, > })]],
        typescript = [[console.log("%log_marker L%line_number", { %repeat<"%log_target": %log_target><, > })]],
        lua = [[print(string.format("%log_marker L%line_number %repeat<%log_target=%s><, >", %repeat<%log_target><, >))]],
        go = [[log.Printf("%log_marker L%line_number %repeat<%log_target: %v><, >\n", %repeat<%log_target><, >)]],
        rust = [[println!("%log_marker L%line_number %repeat<%log_target: {:#?}><, >", %repeat<%log_target><, >);]],
        python = [[print(f"%log_marker L%line_number %repeat<{%log_target=}><, >")]],
      },
    },
  },
}
