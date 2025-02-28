return {
  { "ellisonleao/gruvbox.nvim" },
  {
    "loctvl842/monokai-pro.nvim",
    config = function()
      require("monokai-pro").setup(
        {
          transparent_background = true,
          background_clear = {
            "float_win",
            "toggleterm",
            "telescope",
            "which-key",
            "renamer",
            "notify",
            "nvim-tree",
            "neo-tree",
            "bufferline", -- better used if background of `neo-tree` or `nvim-tree` is cleared
          },
          filter = "classic",
        }
      )
    end
  },
  {
    "rebelot/kanagawa.nvim",
    lazy = false,
    priority = 1000,
    opts = {
      transparent = true,
      styles = {
        sidebars = "transparent",
        floats = "transparent",
      },
    },
  },

  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "monokai-pro",
    },
  },
}
