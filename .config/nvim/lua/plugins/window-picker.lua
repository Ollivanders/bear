return {
  's1n7ax/nvim-window-picker',
  name = 'window-picker',
  event = 'VeryLazy',
  version = '2.*',
  config = function()
    require 'window-picker'.setup({
      hint = "floating-big-letter",
      autoselect_one = true,
      filter_rules = {
        bo = {
          filetype = { "neo-tree", "neo-tree-popup", "notify", "minifiles" },
          buftype = { "terminal", "quickfix" },
        },
      },
      other_win_hl_color = "#900000",
    })
  end,
}
