return {
  { "ellisonleao/gruvbox.nvim" },
  {
    "EdenEast/nightfox.nvim",
    config = function()
      require("nightfox").setup({
        options = {
          -- Compiled file's destination location
          compile_path = vim.fn.stdpath("cache") .. "/nightfox",
          compile_file_suffix = "_compiled", -- Compiled file suffix
          transparent = true,                -- Disable setting background
          terminal_colors = true,            -- Set terminal colors (vim.g.terminal_color_*) used in `:terminal`
          dim_inactive = false,              -- Non focused panes set to alternative background
          module_default = true,             -- Default enable value for modules
          styles = {                         -- Style to be applied to different syntax groups
            comments = "italic",
            keywords = "bold",
            types = "italic,bold",
            conditionals = "NONE",
            constants = "NONE",
            functions = "NONE",
            numbers = "NONE",
            operators = "NONE",
            strings = "NONE",
            variables = "NONE",
          },
          inverse = { -- Inverse highlight for different types
            match_paren = false,
            visual = false,
            search = false,
          },
          modules = { -- List of various plugins and additional options
            -- ...
          },
        },
        palettes = {},
        specs = {},
        groups = {},
      }
      )
    end,
  },
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
            "bufferline",
            "term",
          },
          filter = "machine",
          overridePalette = function(filter)
            return {
              -- dark2 = "#101014",
              -- dark1 = "#16161E",
              -- background = "#1A1B26",
              -- text = "#C0CAF5",
              -- accent1 = "#f7768e",
              -- accent2 = "#7aa2f7",
              -- accent3 = "#e0af = "#737aa2",
              -- dimmed2 = "#787c99",
              -- dimmed3 = "#363b54",
              -- dimmed4 = "#363b54",
              -- dimmed5 = "#16161e",
              dimmed1 = "#c1c0c0",
              dimmed2 = "#939293",
              dimmed3 = "#727072",
              dimmed4 = "#5b595c",
              dimmed5 = "#403e41",
            }
          end
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
