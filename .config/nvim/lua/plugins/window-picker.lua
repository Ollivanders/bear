return {
  "s1n7ax/nvim-window-picker",
  name = "window-picker",
  version = "2.*",
  lazy = true,
  opts = {
    hint = "floating-big-letter",
    autoselect_one = true,
    filter_rules = {
      bo = {
        filetype = { "notify", "minifiles", "snacks_notif" },
        buftype = { "terminal", "quickfix" },
      },
    },
    other_win_hl_color = "#900000",
  },
}
