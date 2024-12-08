return {
  "kndndrj/nvim-dbee",
  dependencies = {
    "MunifTanjim/nui.nvim",
  },
  build = function()
    require("dbee").install("go")
  end,
  keys = {
    {
      "<C-j>d",
      function()
        local dbee = require("dbee")
        if dbee.is_open() then
          dbee.close()
        else
          -- 2回目だけエラーになるのでなんとか回避できないか...?
          require("no-neck-pain").disable()
          vim.defer_fn(function()
            dbee.open()
          end, 200)
        end
      end,
    },
  },
  config = function()
    require("dbee").setup({
      sources = {
        require("dbee.sources").MemorySource:new({
          {
            id = "mydb",
            name = "mydb",
            type = "mysql",
            url = "user:password@tcp(localhost:13306)/mydb",
          },
        }),
      },
      result = {
        window_options = {
          number = true,
        },
      },
    })
  end,
}
