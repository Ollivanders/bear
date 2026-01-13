local wt = require("wezterm")
local config = wt.config_builder()
local io = require 'io'
local os = require 'os'

local funcs = require("functions")
require("events").setup()
funcs.get_currently_playing()

config.show_new_tab_button_in_tab_bar = false
config.show_tabs_in_tab_bar = true
config.tab_and_split_indices_are_zero_based = false
config.send_composed_key_when_left_alt_is_pressed = true

config.inactive_pane_hsb = {
  saturation = 0.8,
  brightness = 0.7,
}

config.window_decorations = "RESIZE"
config.color_scheme = "Darkside"
config.font_size = 16

config.use_fancy_tab_bar = true
config.font = wt.font("JetBrains Mono")
config.window_background_opacity = 0.9
-- config.macos_window_background_blur = 2

config.colors = {
  tab_bar = {
    active_tab = {
      fg_color = '#073642',
      bg_color = '#2aa198'
    }
  }
}
config.ssh_backend = "Ssh2"
config.enable_tab_bar = true
config.tab_max_width = 40
config.switch_to_last_active_tab_when_closing_tab = true
config.adjust_window_size_when_changing_font_size = false
config.hide_tab_bar_if_only_one_tab = true
config.pane_focus_follows_mouse = true
config.scrollback_lines = 5000

config.window_frame = {
  font = wt.font({ family = "Noto Sans", weight = "Bold" }),
  font_size = 13,
}
config.set_environment_variables = {
  PATH = "/opt/homebrew/bin:" .. os.getenv("PATH") .. ":/usr/local/bin/",
}

config.leader = { key = "Space", mods = "CTRL", timeout_milliseconds = 2000 }
config.keys = require("keymaps")
config.key_tables = require("keytables")

return config
