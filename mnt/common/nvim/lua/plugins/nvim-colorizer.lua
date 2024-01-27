local u = require("utils")

u.set.termguicolors = true

return {
  'norcalli/nvim-colorizer.lua',
  config = function()
    require 'colorizer'.setup()
  end
}
