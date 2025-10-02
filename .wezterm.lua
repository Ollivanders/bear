local wt = require("wezterm")
local config = wt.config_builder()
local mux = wt.mux
local act = wt.action

local project_dir = wt.home_dir .. "/projects"

local function project_dirs()
  local projects = { wt.home_dir, wt.home_dir .. '/scratch' }
  for _, dir in ipairs(wt.glob(project_dir .. '/*')) do
    table.insert(projects, dir)
  end
  return projects
end

local function choose_project()
  local choices = {}
  for _, value in ipairs(project_dirs()) do
    table.insert(choices, { label = value })
  end

  return wt.action.InputSelector {
    title = "Projects",
    choices = choices,
    fuzzy = true,
    action = wt.action_callback(function(window, pane, id, label)
      if not label then return end
      local name = label:match("([^/]+)$")

      wt.log_info('you selected ', id, label)
      window:perform_action(
        wt.action.SpawnCommandInNewTab({
          cwd = label,
          -- args = {  "nvim" },
        }), pane)
    end),
  }
end

local function wait(throttle, last_update)
  local current_time = os.time()
  return current_time - last_update < throttle
end


local stored_playback = ""
local function get_currently_playing()
  local ok, stdout, stderr = wt.run_child_process {
    "/usr/bin/osascript",
    "-e",
    'tell application "Spotify" to if player state is playing then artist of current track & " – " & name of current track'
  }
  stored_playback = stdout
  wt.time.call_after(5, get_currently_playing)
end
get_currently_playing()

wt.on("gui-startup", function()
  local tab, pane, window = mux.spawn_window({})
  window:gui_window():maximize()
end)

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

config.leader = { key = "Space", mods = "CTRL", timeout_milliseconds = 1000 }

-- if you are *NOT* lazy-loading smart-splits.nvim (recommended)
local function is_vim(pane)
  -- this is set by the plugin, and unset on ExitPre in Neovim
  return pane:get_user_vars().IS_NVIM == 'true'
end

-- if you *ARE* lazy-loading smart-splits.nvim (not recommended)
-- you have to use this instead, but note that this will not work
-- in all cases (e.g. over an SSH connection). Also note that
-- `pane:get_foreground_process_name()` can have high and highly variable
-- latency, so the other implementation of `is_vim()` will be more
-- performant as well.
local function is_vim(pane)
  -- This gsub is equivalent to POSIX basename(3)
  -- Given "/foo/bar" returns "bar"
  -- Given "c:\\foo\\bar" returns "bar"
  local process_name = string.gsub(pane:get_foreground_process_name(), '(.*[/\\])(.*)', '%2')
  return process_name == 'nvim' or process_name == 'vim'
end

local direction_keys = {
  h = 'Left',
  j = 'Down',
  k = 'Up',
  l = 'Right',
}

local function split_nav(resize_or_move, key)
  return {
    key = key,
    mods = resize_or_move == 'resize' and 'META' or 'CTRL',
    action = wt.action_callback(function(win, pane)
      if is_vim(pane) then
        -- pass the keys through to vim/nvim
        win:perform_action({
          SendKey = { key = key, mods = resize_or_move == 'resize' and 'META' or 'CTRL' },
        }, pane)
      else
        if resize_or_move == 'resize' then
          win:perform_action({ AdjustPaneSize = { direction_keys[key], 3 } }, pane)
        else
          win:perform_action({ ActivatePaneDirection = direction_keys[key] }, pane)
        end
      end
    end),
  }
end

config.keys = {
  {
    key = "F12",
    action = wt.action_callback(function(_, pane)
      local tab = pane:tab()
      local panes = tab:panes_with_info()
      if #panes == 1 then
        pane:split({
          direction = "Right",
          size = 0.4,
        })
      elseif not panes[1].is_zoomed then
        panes[1].pane:activate()
        tab:set_zoomed(true)
      elseif panes[1].is_zoomed then
        tab:set_zoomed(false)
        panes[2].pane:activate()
      end
    end),
  },
  {
    key = '@',
    mods = "CTRL|SHIFT",
    action = wt.action.QuickSelect,
  },
  {
    key = 'T',
    mods = 'CTRL',
    action = wt.action.TogglePaneZoomState,
  },
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
    action = wt.action.SendString("\x1bw"),
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
    action = wt.action.CloseCurrentPane({ confirm = true }),
  },
  { key = "-", mods = "CTRL", action = wt.action.DisableDefaultAssignment },
  { key = "=", mods = "CTRL", action = wt.action.DisableDefaultAssignment },
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
    key = ';',
    mods = 'LEADER',
    action = act.ActivatePaneDirection('Prev'),
  },
  {
    key = ':',
    mods = 'LEADER',
    action = act.ActivatePaneDirection('Next'),
  },
  {
    -- |
    key = '{',
    mods = 'LEADER|SHIFT',
    action = act.PaneSelect { mode = 'SwapWithActiveKeepFocus' }
  },
  {
    key = "t",
    mods = "LEADER",
    action = act.ShowTabNavigator,
  },
  {
    key = "r",
    mods = "LEADER",
    action = act.ActivateKeyTable({
      name = "resize_pane",
      one_shot = false,
    }),
  },
  {
    key = "a",
    mods = "LEADER",
    action = act.ActivateKeyTable({
      name = "activate_pane",
      timeout_milliseconds = 1000,
    }),
  },
  {
    key = 'p',
    mods = 'LEADER',
    action = choose_project(),
  },
  {
    key = 'f',
    mods = 'LEADER',
    action = wt.action.ShowLauncherArgs { flags = 'FUZZY|WORKSPACES' },
  },
  {
    key = 'w',
    mods = 'LEADER',
    action = wt.action_callback(function(win, pane)
      local tab, window = pane:move_to_new_window()
    end),
  },
  -- move between split panes
  split_nav('move', 'h'),
  split_nav('move', 'j'),
  split_nav('move', 'k'),
  split_nav('move', 'l'),
  -- resize panes
  split_nav('resize', 'h'),
  split_nav('resize', 'j'),
  split_nav('resize', 'k'),
  split_nav('resize', 'l'),
}
config.key_tables = {
  -- Defines the keys that are active in our resize-pane mode.
  -- Since we're likely to want to make multiple adjustments,
  -- we made the activation one_shot=false. We therefore need
  -- to define a key assignment for getting out of this mode.
  -- 'resize_pane' here corresponds to the name="resize_pane" in
  -- the key assignments above.
  resize_pane = {
    { key = "LeftArrow",  action = act.AdjustPaneSize({ "Left", 1 }) },
    { key = "h",          action = act.AdjustPaneSize({ "Left", 1 }) },

    { key = "RightArrow", action = act.AdjustPaneSize({ "Right", 1 }) },
    { key = "l",          action = act.AdjustPaneSize({ "Right", 1 }) },

    { key = "UpArrow",    action = act.AdjustPaneSize({ "Up", 1 }) },
    { key = "k",          action = act.AdjustPaneSize({ "Up", 1 }) },

    { key = "DownArrow",  action = act.AdjustPaneSize({ "Down", 1 }) },
    { key = "j",          action = act.AdjustPaneSize({ "Down", 1 }) },

    -- Cancel the mode by pressing escape
    { key = "Escape",     action = "PopKeyTable" },
  },

  -- Defines the keys that are active in our activate-pane mode.
  -- 'activate_pane' here corresponds to the name="activate_pane" in
  -- the key assignments above.
  activate_pane = {
    { key = "LeftArrow",  action = act.ActivatePaneDirection("Left") },
    { key = "h",          action = act.ActivatePaneDirection("Left") },

    { key = "RightArrow", action = act.ActivatePaneDirection("Right") },
    { key = "l",          action = act.ActivatePaneDirection("Right") },

    { key = "UpArrow",    action = act.ActivatePaneDirection("Up") },
    { key = "k",          action = act.ActivatePaneDirection("Up") },

    { key = "DownArrow",  action = act.ActivatePaneDirection("Down") },
    { key = "j",          action = act.ActivatePaneDirection("Down") },
  },
}

local function segments_for_right_status(window)
  local bat = ''
  for _, b in ipairs(wt.battery_info()) do
    bat = '🔋 ' .. string.format('%.0f%%', b.state_of_charge * 100)
  end

  return {
    window:active_workspace(),
    wt.strftime("%a %b %-d %H:%M"),
    wt.hostname(),
    bat,
    stored_playback,
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
