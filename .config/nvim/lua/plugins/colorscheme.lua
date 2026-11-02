return {
  { "ellisonleao/gruvbox.nvim", lazy = true },
  { "rebelot/kanagawa.nvim", lazy = true, opts = { transparent = true } },
  {
    "EdenEast/nightfox.nvim",
    lazy = true,
    opts = {
      options = {
        transparent = true,
        styles = {
          comments = "italic",
          keywords = "bold",
          types = "italic,bold",
        },
      },
    },
  },
  {
    "loctvl842/monokai-pro.nvim",
    lazy = false,
    priority = 1000,
    opts = {
      transparent_background = true,
      background_clear = {
        "float_win",
        "toggleterm",
        "telescope",
        "which-key",
        "renamer",
        "notify",
        "nvim-tree",
        "bufferline",
        "term",
      },
      filter = "machine",
      override_palette = function()
        return {
          dimmed1 = "#c1c0c0",
          dimmed2 = "#939293",
          dimmed3 = "#727072",
          dimmed4 = "#5b595c",
          dimmed5 = "#403e41",
        }
      end,
    },
    config = function(_, opts)
      require("monokai-pro").setup(opts)
      local function transparent_floats()
        for _, group in ipairs({ "NormalFloat", "FloatBorder", "FloatTitle", "SnacksNormal", "SnacksNormalNC" }) do
          vim.api.nvim_set_hl(0, group, { bg = "NONE" })
        end
      end
      vim.api.nvim_create_autocmd("ColorScheme", {
        group = vim.api.nvim_create_augroup("user_transparent_floats", { clear = true }),
        callback = transparent_floats,
      })
      transparent_floats()
    end,
  },
}
