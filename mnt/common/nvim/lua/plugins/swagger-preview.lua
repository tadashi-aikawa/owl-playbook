return {
  "vinnymeller/swagger-preview.nvim",
  config = function()
    require("swagger-preview").setup({
      port = 8000,
      host = "localhost",
    })
  end
}
