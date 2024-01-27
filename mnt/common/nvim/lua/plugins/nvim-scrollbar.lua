return {
    'petertriho/nvim-scrollbar',
    config = function()
      require("scrollbar").setup({
        handle = {
          color = "gray"
        },
        marks = {
          Search = { color = "lime" },
          Error = { color = "red" },
          Warn = { color = "orange" },
          Info = { color = "cyan" },
          Hint = { color = "gray" },
          Misc = { color = "purple" },
        }
      })
    end
  }
