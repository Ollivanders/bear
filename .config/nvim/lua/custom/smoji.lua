return {
  dir = "~/projects/smoji.nvim",
  name = "smoji.nvim",
  cmd = "Smoji",
  keys = {
    { "<leader><leader>e", "<cmd>Smoji<cr>", desc = "Git[e]moji" },
    { "<C-e>", "<cmd>Smoji<cr>", desc = "Git[e]moji", mode = "i" },
    { "<C-e>", "<cmd>Smoji<cr>", desc = "Git[e]moji", mode = "t" },
  },
  config = function()
    require("smoji")
  end,
}
