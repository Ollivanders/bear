local wezterm = require("wezterm")
local config = wezterm.config_builder()

config.color_scheme = "Batman"
config.font = wezterm.font("JetBrains Mono")
config.window_background_opacity = 0.92

config.skip_close_confirmation_for_processes_named = {
	"bash",
	"sh",
	"zsh",
	"fish",
	"tmux",
	"nu",
	"cmd.exe",
	"pwsh.exe",
	"powershell.exe",
	"nvim",
}

return config
