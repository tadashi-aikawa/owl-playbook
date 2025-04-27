return {
  root_dir = require("lsp.utils").root_dir_patterns({
    "tsconfig.json",
  }),
  init_options = {
    plugins = {
      {
        name = "@vue/typescript-plugin",
        location = os.getenv("HOME")
          .. "/.local/share/mise/installs/npm-vue-typescript-plugin/latest/lib/node_modules/@vue/typescript-plugin ",
        languages = { "javascript", "typescript", "vue" },
      },
    },
  },
  filetypes = {
    "javascript",
    "typescript",
    "vue",
  },
}
