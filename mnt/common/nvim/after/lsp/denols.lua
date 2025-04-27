return {
  root_dir = require("lsp.utils").root_dir_patterns({
    "deno.json",
    "deno.jsonc",
    "deps.ts",
  }),
}
