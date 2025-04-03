return {
  "stevearc/oil.nvim",
  keys = {
    { "<Space>o", ":Oil<CR>", silent = true },
  },
  cmd = "Oil",
  opts = {
    skip_confirm_for_simple_edits = true,
    keymaps = {
      ["<C-s>"] = "actions.select_split",
      ["<F12>"] = "actions.select_vsplit",
      ["gy"] = "actions.yank_entry",
      ["gR"] = {
        callback = function()
          local oil = require("oil")
          local prefills = { paths = oil.get_current_dir() }

          local grug_far = require("grug-far")
          if not grug_far.has_instance("explorer") then
            grug_far.open({
              instanceName = "explorer",
              prefills = prefills,
            })
          else
            grug_far.open_instance("explorer")
            grug_far.update_instance_prefills("explorer", prefills, false)
          end
        end,
        desc = "oil: Search in directory",
      },
    },
    view_options = {
      show_hidden = true,
    },
  },
}
