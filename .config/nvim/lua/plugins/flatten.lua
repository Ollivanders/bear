return {
  {
    "willothy/flatten.nvim",
    config = true,
    lazy = false,
    priority = 1001,
    opts = function()
      return {
        window = {
          open = "smart",
          diff = "tab_vsplit",
          focus = "first",
        },
        integrations = {
          wezterm = true,
        },
      }
    end,
  },
}
