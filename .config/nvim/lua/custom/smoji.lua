return {
  dir = "~/.config/nvim/lua/local/smoji.nvim",
  name = "smoji.nvim",
  cmd = "Smoji",
  keys = {
    { "<leader>ue", "<cmd>Smoji<cr>", desc = "Git[e]moji" },
    { "<C-e>",      "<cmd>Smoji<cr>", desc = "Git[e]moji", mode = "i" },
    { "<C-e>",      "<cmd>Smoji<cr>", desc = "Git[e]moji", mode = "t" },
  },
  config = function()
    require("smoji")
  end,
}
