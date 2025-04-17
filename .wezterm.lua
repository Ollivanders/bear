local wezterm = require("wezterm")
local config = wezterm.config_builder()
local mux = wezterm.mux
local act = wezterm.action

wezterm.on("gui-startup", function()
  local tab, pane, window = mux.spawn_window({})
  window:gui_window():maximize()
end)

config.inactive_pane_hsb = {
  saturation = 0.8,
  brightness = 0.7,
}

config.window_decorations = "RESIZE"
config.color_scheme = "Darkside"
config.font_size = 14

config.font = wezterm.font("JetBrains Mono")
config.window_background_opacity = 0.92

config.adjust_window_size_when_changing_font_size = false
config.hide_tab_bar_if_only_one_tab = true

config.window_frame = {
  font = wezterm.font({ family = "Noto Sans", weight = "Bold" }),
  font_size = 13,
}

config.keys = {
  {
    key = "w",
    mods = "CMD",
    action = wezterm.action.CloseCurrentPane({ confirm = false }),
  },
  {
    key = 'T',
    mods = 'CTRL',
    action = wezterm.action.TogglePaneZoomState,
  },
  { key = '-', mods = 'CTRL', action = wezterm.action.DisableDefaultAssignment },
  { key = '=', mods = 'CTRL', action = wezterm.action.DisableDefaultAssignment },
}

local function segments_for_right_status(window)
  return {
    window:active_workspace(),
    wezterm.strftime("%a %b %-d %H:%M:%S"),
    wezterm.hostname(),
  }
end

wezterm.on("update-status", function(window, _)
  local SOLID_LEFT_ARROW = utf8.char(0xe0b2)
  local segments = segments_for_right_status(window)

  local color_scheme = window:effective_config().resolved_palette
  -- Note the use of wezterm.color.parse here, this returns
  -- a Color object, which comes with functionality for lightening
  -- or darkening the colour (amongst other things).
  local bg = wezterm.color.parse(color_scheme.background)
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
  local gradient = wezterm.color.gradient(
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

  window:set_right_status(wezterm.format(elements))
end)

return config
