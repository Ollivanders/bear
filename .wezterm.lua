local wt = require("wezterm")
local config = wt.config_builder()
local mux = wt.mux
local act = wt.action

wt.on("gui-startup", function()
	local tab, pane, window = mux.spawn_window({})
	window:gui_window():maximize()
end)

config.inactive_pane_hsb = {
	saturation = 0.8,
	brightness = 0.7,
}

config.window_decorations = "RESIZE"
config.color_scheme = "Darkside"
config.font_size = 13

config.use_fancy_tab_bar = true
config.font = wt.font("JetBrains Mono")
config.window_background_opacity = 0.9
-- config.macos_window_background_blur = 2

config.enable_tab_bar = true
config.tab_max_width = 40
config.switch_to_last_active_tab_when_closing_tab = true
config.adjust_window_size_when_changing_font_size = false
config.hide_tab_bar_if_only_one_tab = true

config.window_frame = {
	font = wt.font({ family = "Noto Sans", weight = "Bold" }),
	font_size = 13,
}

config.leader = {
	key = "Space",
	mods = "CTRL|SHIFT",
	timeout_milliseconds = 2000,
}
config.set_environment_variables = {
	PATH = "/opt/homebrew/bin:" .. os.getenv("PATH") .. ":/usr/local/bin/",
}

config.keys = {
	{
		key = ",",
		mods = "SUPER",
		action = wt.action.SpawnCommandInNewTab({
			cwd = wt.home_dir,
			args = { "nvim", wt.config_file },
		}),
	},
	{
		key = "LeftArrow",
		mods = "OPT",
		action = wt.action.SendString("\x1bb"),
	},
	{
		key = "RightArrow",
		mods = "OPT",
		action = wt.action.SendString("\x1bf"),
	},
	{
		key = "!",
		mods = "CTRL|SHIFT",
		action = wt.action_callback(function(win, pane)
			local tab, window = pane:move_to_new_window()
		end),
	},
	{
		key = "w",
		mods = "CMD",
		action = wt.action.CloseCurrentPane({ confirm = false }),
	},
	{
		key = "T",
		mods = "CTRL",
		action = wt.action.TogglePaneZoomState,
	},
	{ key = "-", mods = "CTRL", action = wt.action.DisableDefaultAssignment },
	{ key = "=", mods = "CTRL", action = wt.action.DisableDefaultAssignment },
	{
		key = "n",
		mods = "LEADER",
		action = wt.action.ActivateTabRelative(1),
	},
	{
		key = "p",
		mods = "LEADER",
		action = wt.action.ActivateTabRelative(-1),
	},
	{
		key = ",",
		mods = "LEADER",
		action = act.PromptInputLine({
			description = "Enter new name for tab",
			action = wt.action_callback(function(window, pane, line)
				if line then
					window:active_tab():set_title(line)
				end
			end),
		}),
	},
	{
		key = "w",
		mods = "LEADER",
		action = act.ShowTabNavigator,
	},
	{
		key = "&",
		mods = "LEADER|SHIFT",
		action = act.CloseCurrentTab({ confirm = true }),
	},
}

local function segments_for_right_status(window)
	return {
		window:active_workspace(),
		wt.strftime("%a %b %-d %H:%M:%S"),
		wt.hostname(),
	}
end

wt.on("update-right-status", function(window, pane)
	local name = window:active_key_table()
	if name then
		name = "TABLE: " .. name
	end
	window:set_right_status(name or "")
end)

wt.on("update-status", function(window, _)
	local SOLID_LEFT_ARROW = utf8.char(0xe0b2)
	local segments = segments_for_right_status(window)

	local color_scheme = window:effective_config().resolved_palette
	-- Note the use of wezterm.color.parse here, this returns
	-- a Color object, which comes with functionality for lightening
	-- or darkening the colour (amongst other things).
	local bg = wt.color.parse(color_scheme.background)
	local fg = color_scheme.foreground

	-- Each powerline segment is going to be coloured progressively
	-- darker/lighter depending on whether we're on a dark/light colour
	-- scheme. Let's establish the "from" and "to" bounds of our gradient.
	local gradient_to, gradient_from = bg
	gradient_from = gradient_to:lighten(0.2)

	-- Yes, WezTerm supports creating gradients, because why not?! Although
	-- they'd usually be used for setting high fidelity gradients on your terminal's
	-- background, we'll use them here to give us a sample of the powerline segment
	-- colours we need.
	local gradient = wt.color.gradient(
		{
			orientation = "Horizontal",
			colors = { gradient_from, gradient_to },
		},
		#segments -- only gives us as many colours as we have segments.
	)

	-- We'll build up the elements to send to wezterm.format in this table.
	local elements = {}

	for i, seg in ipairs(segments) do
		local is_first = i == 1

		if is_first then
			table.insert(elements, { Background = { Color = "none" } })
		end
		table.insert(elements, { Foreground = { Color = gradient[i] } })
		table.insert(elements, { Text = SOLID_LEFT_ARROW })

		table.insert(elements, { Foreground = { Color = fg } })
		table.insert(elements, { Background = { Color = gradient[i] } })
		table.insert(elements, { Text = " " .. seg .. " " })
	end

	window:set_right_status(wt.format(elements))
end)

return config
