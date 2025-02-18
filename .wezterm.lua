local wezterm = require("wezterm")
local config = wezterm.config_builder()

config.color_scheme = "Batman"
config.font = wezterm.font("JetBrains Mono")
config.window_background_opacity = 0.92

return config
