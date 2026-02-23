return {
  dir = "~/.config/nvim/lua/local/baredot.nvim",
  opts = {
    git_dir = "~/.cfg"
  },
  name= "baredot.nvim",
  config = function ()
    require("baredot").setup({
      git_dir = "~/.cfg"
    })
  end,
}
