return {
  dir = vim.fn.stdpath("config") .. "/lua/local/smoji.nvim",
  name = "smoji.nvim",
  cmd = "Smoji",
  keys = {
    { "<C-e>", "<cmd>Smoji<cr>", desc = "Git[e]moji", mode = { "i", "t" } },
  },
  config = function()
    require("smoji")
  end,
}
