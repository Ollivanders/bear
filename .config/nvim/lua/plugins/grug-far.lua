return {
  "MagicDuck/grug-far.nvim",
  opts = { headerMaxWidth = 80 },
  cmd = "GrugFar",
  config = function()
    require("grug-far").setup({})
  end,
  keys = {
    {
      "<leader>sr",
      function()
        local grug = require("grug-far")
        local ext = vim.bo.buftype == "" and vim.fn.expand("%:e")
        grug.open({
          transient = true,
          instanceName = "Main",
          staticTitle = "Main",
          prefills = {
            flags = "-F --hidden",
            -- filesFilter = ext and ext ~= "" and "*." .. ext or nil,
          },
        })
      end,
      mode = { "n", "v" },
      desc = "Search and Replace",
    },
    {
      "<leader>rt",
      function()
        local grug = require("grug-far")
        grug.toggle_instance({
          instanceName = "Toggle",
          staticTitle = "Toggle",
          prefills = {
            flags = "-F --hidden",
          },
        })
      end,
      mode = { "n", "v" },
      desc = "Search and Replace",
    },
  },
}
