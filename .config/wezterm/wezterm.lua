local wt = require("wezterm")
local config = wt.config_builder()

require("events").setup()
require("functions").start_playback_poller()

-- appearance
config.color_scheme = "Darkside"
config.font = wt.font("JetBrains Mono")
config.font_size = 16
config.window_decorations = "RESIZE"
config.window_background_opacity = 0.9
-- config.macos_window_background_blur = 2
config.inactive_pane_hsb = {
  saturation = 0.8,
  brightness = 0.7,
}

-- tab bar
config.show_new_tab_button_in_tab_bar = false
config.hide_tab_bar_if_only_one_tab = true
config.tab_max_width = 40
config.window_frame = {
  font = wt.font({ family = "Noto Sans", weight = "Bold" }),
  font_size = 13,
}
config.colors = {
  tab_bar = {
    active_tab = {
      fg_color = "#073642",
      bg_color = "#2aa198",
    },
  },
}

-- behaviour
config.send_composed_key_when_left_alt_is_pressed = true
config.switch_to_last_active_tab_when_closing_tab = true
config.adjust_window_size_when_changing_font_size = false
config.scrollback_lines = 5000
config.ssh_backend = "Ssh2"
config.set_environment_variables = {
  PATH = "/opt/homebrew/bin:" .. os.getenv("PATH") .. ":/usr/local/bin",
}

-- keys
config.leader = { key = "Space", mods = "CTRL", timeout_milliseconds = 2000 }
config.keys = require("keymaps")
config.key_tables = require("keytables")

-- smart-splits: Ctrl+hjkl move, Alt+hjkl resize; passes through to nvim when IS_NVIM is set
local smart_splits = wt.plugin.require("https://github.com/smart-splits-nvim/backend-wezterm")
smart_splits.apply_to_config(config, {
  direction_keys = { "h", "j", "k", "l" },
  modifiers = { move = "CTRL", resize = "META" },
  at_edge = "stop",
})

-- Alt+hjkl belongs to AeroSpace (window focus), so resize lives on Ctrl+Shift+hjkl instead.
-- In nvim panes it's forwarded as Alt+hjkl (internal SendKey, AeroSpace never sees it) so nvim
-- splits resize first; elsewhere it resizes the WezTerm pane 3 cells (plugin default is 1).
-- NOTE: relies on the plugin appending bindings with mods = "META"; recheck after plugin updates.
local resize_dirs = { h = "Left", j = "Down", k = "Up", l = "Right" }
for _, binding in ipairs(config.keys) do
  if binding.mods == "META" and resize_dirs[binding.key] then
    local key = binding.key
    binding.mods = "CTRL|SHIFT"
    binding.action = wt.action_callback(function(window, pane)
      if pane:get_user_vars().IS_NVIM == "true" then
        window:perform_action(wt.action.SendKey({ key = key, mods = "META" }), pane)
      else
        window:perform_action(wt.action.AdjustPaneSize({ resize_dirs[key], 3 }), pane)
      end
    end)
  end
end

-- nvim terminal tabs: Ctrl+Shift+] / [ sent to nvim as Alt+. / Alt+, (explicit META, so macOS
-- Option composition can't turn them into characters); other panes get the key unchanged
for phys, nvim_key in pairs({ RightBracket = ".", LeftBracket = "," }) do
  table.insert(config.keys, {
    key = "phys:" .. phys,
    mods = "CTRL|SHIFT",
    action = wt.action_callback(function(window, pane)
      if pane:get_user_vars().IS_NVIM == "true" then
        window:perform_action(wt.action.SendKey({ key = nvim_key, mods = "META" }), pane)
      else
        window:perform_action(wt.action.SendKey({ key = phys == "RightBracket" and "]" or "[", mods = "CTRL|SHIFT" }), pane)
      end
    end),
  })
end

return config
