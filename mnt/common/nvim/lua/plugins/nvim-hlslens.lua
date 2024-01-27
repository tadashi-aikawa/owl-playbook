return {
  "kevinhwang91/nvim-hlslens",
  event = { 'BufNewFile', 'BufRead' },
  config = function()
    require("scrollbar.handlers.search").setup({
      override_lens = function(render, posList, nearest, idx)
        local text, chunks
        ---@diagnostic disable-next-line: deprecated
        local lnum, col = unpack(posList[idx])
        local cnt = #posList
        text = ('[%d/%d]'):format(idx, cnt)
        if nearest then
          chunks = { { ' ', 'Ignore' }, { text, 'HlSearchLensNear' } }
        else
          chunks = { { ' ', 'Ignore' }, { text, 'HlSearchLens' } }
        end
        render.setVirt(0, lnum - 1, col - 1, chunks, nearest)
      end
    })
    local kopts = { noremap = true, silent = true }

    vim.api.nvim_set_keymap('n', 'n',
      [[<Cmd>execute('normal! ' . v:count1 . 'n')<CR><Cmd>lua require('hlslens').start()<CR>]],
      kopts)
    vim.api.nvim_set_keymap('n', 'N',
      [[<Cmd>execute('normal! ' . v:count1 . 'N')<CR><Cmd>lua require('hlslens').start()<CR>]],
      kopts)
    vim.api.nvim_set_keymap('n', '*', [[*<Cmd>lua require('hlslens').start()<CR>]], kopts)
    vim.api.nvim_set_keymap('n', '#', [[#<Cmd>lua require('hlslens').start()<CR>]], kopts)
    vim.api.nvim_set_keymap('n', 'g*', [[g*<Cmd>lua require('hlslens').start()<CR>]], kopts)
    vim.api.nvim_set_keymap('n', 'g#', [[g#<Cmd>lua require('hlslens').start()<CR>]], kopts)

    vim.api.nvim_set_keymap('n', '<Leader>l', '<Cmd>noh<CR>', kopts)

    vim.cmd [[
        highlight HlSearchLensNear guifg=white guibg=olive
        highlight HlSearchLens guifg=#777777 guibg=#FFFFFFFF
      ]]
  end
}
