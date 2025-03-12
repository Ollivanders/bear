return {
  {
    "willothy/flatten.nvim",
    config = true,
    lazy = false,
    priority = 1001,
    opts = function()
      return {
        window = {
          open = "alternate",
        },
        integrations = {
          wezterm = true,
        },
      }
    end,
  },
}
