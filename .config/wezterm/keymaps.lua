local wt = require("wezterm")
local act = wt.action
local funcs = require("functions")

return {
  {
    key = "o",
    mods = "CTRL|SHIFT",
    action = wt.action { PaneSelect = {} }
  },
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
    mods = 'LEADER',
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
    action = act.EmitEvent 'choose-project',
  },
  {
    key = 'e',
    mods = 'LEADER',
    action = act.EmitEvent 'trigger-vim-with-scrollback',
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
  funcs.split_nav('move', 'h'),
  funcs.split_nav('move', 'j'),
  funcs.split_nav('move', 'k'),
  funcs.split_nav('move', 'l'),
  -- resize panes
  funcs.split_nav('resize', 'h'),
  funcs.split_nav('resize', 'j'),
  funcs.split_nav('resize', 'k'),
  funcs.split_nav('resize', 'l'),
}

