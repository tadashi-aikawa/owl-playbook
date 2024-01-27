local u = require("utils")

return {
  'neoclide/coc.nvim',
  branch = "release",
  event = { 'BufNewFile', 'BufRead' },
  keys = {
    -- 定義に移動
    { '<C-]>', '<Plug>(coc-definition)',                                                silent = true },
    -- import最適化
    { '<M-o>', ':call CocAction(\'runCommand\', \'editor.action.organizeImport\')<CR>', silent = true },
    -- 配下の定義を表示
    { '<M-s>', ':call CocActionAsync(\'doHover\')<CR>',                                 silent = true },
    {
      '<C-P>',
      '<C-\\><C-O>:call CocActionAsync(\'showSignatureHelp\')<CR>',
      mode = "i",
      silent = true
    },
    -- 前後のエラーや警告に移動
    { '<M-k>', '<Plug>(coc-diagnostic-prev)', silent = true },
    { '<M-j>', '<Plug>(coc-diagnostic-next)', silent = true },
    -- Enterキーで決定
    {
      "<cr>",
      [[coc#pum#visible() ? coc#pum#confirm() : "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"]],
      mode = "i",
      expr = true,
      silent = true,
      replace_keycodes = false
    },
    -- 上下で候補選択
    {
      "<down>",
      [[coc#pum#visible() ? coc#pum#next(1) : "<down>"]],
      mode = "i",
      expr = true,
      silent = true,
      replace_keycodes = false
    },
    {
      "<up>",
      [[coc#pum#visible() ? coc#pum#prev(1): "<up>"]],
      mode = "i",
      expr = true,
      silent = true,
      replace_keycodes = false
    },
    -- TABでsnippets展開とplaceholder移動
    {
      "<tab>",
      '<Plug>(coc-snippets-expand-jump)',
      mode = "i",
      silent = true,
    },
    -- code action
    { '<M-CR>',  '<Plug>(coc-codeaction-cursor)', silent = true },
    -- Rename
    { '<S-M-r>', '<Plug>(coc-rename)',            silent = true },
    -- Auto complete
    {
      "<F5>",
      [[coc#refresh()]],
      mode = "i",
      silent = true,
      expr = true
    },
  },
  config = function()
    local extensions = {
      "@yaegassy/coc-marksman",
      "@yaegassy/coc-volar",
      "@yaegassy/coc-tailwindcss3",
      "coc-biome",
      "coc-css",
      "coc-deno",
      "coc-elixir",
      "coc-go",
      "coc-html",
      "coc-highlight",
      "coc-java",
      "coc-json",
      "coc-prettier",
      "coc-pyright",
      "coc-rust-analyzer",
      "coc-snippets",
      "coc-tsserver",
      "coc-yaml",
    }
    if not u.is_windows then
      -- Windowsは未対応らしいので...
      table.insert(extensions, { "coc-lua" })
    end
    vim.g.coc_global_extensions = extensions

    vim.api.nvim_create_autocmd("BufWritePre", {
      pattern = { "*.go" },
      command = "call CocAction('runCommand', 'editor.action.organizeImport')"
    })

    -- coc-highlight
    vim.api.nvim_set_hl(0, "CocHighlightText", { fg = 'lightgray', bg = 'darkcyan' })
    vim.api.nvim_set_hl(0, "CocHighlightRead", { fg = 'lightgray', bg = 'darkgreen' })
    vim.api.nvim_set_hl(0, "CocHighlightWrite", { fg = 'lightgray', bg = 'darkred' })

    vim.api.nvim_create_autocmd("CursorHold", {
      pattern = "*",
      command = "call CocActionAsync('highlight')"
    })
  end
}
