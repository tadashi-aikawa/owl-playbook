return {
  'gen740/SmoothCursor.nvim',
  config = function()
    require('smoothcursor').setup({
      fancy = {
        enable = true,
        head = { cursor = "▷", texthl = "SmoothCursor", linehl = nil },
        body = {
          { cursor = "●", texthl = "SmoothCursorYellow" },
          { cursor = "●", texthl = "SmoothCursorGreen" },
          { cursor = "•", texthl = "SmoothCursorAqua" },
          { cursor = ".", texthl = "SmoothCursorBlue" },
          { cursor = ".", texthl = "SmoothCursorPurple" },
        },
        tail = { cursor = nil, texthl = "SmoothCursor" },
      },
      disable_float_win = true,
    })
  end
}
