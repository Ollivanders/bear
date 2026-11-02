local wt = require("wezterm")
local act = wt.action

return {
  -- LEADER r (keymaps.lua). one_shot = false, so exit with Escape/q/Enter.
  resize_pane = {
    { key = "LeftArrow",  action = act.AdjustPaneSize({ "Left", 1 }) },
    { key = "h",          action = act.AdjustPaneSize({ "Left", 1 }) },

    { key = "RightArrow", action = act.AdjustPaneSize({ "Right", 1 }) },
    { key = "l",          action = act.AdjustPaneSize({ "Right", 1 }) },

    { key = "UpArrow",    action = act.AdjustPaneSize({ "Up", 1 }) },
    { key = "k",          action = act.AdjustPaneSize({ "Up", 1 }) },

    { key = "DownArrow",  action = act.AdjustPaneSize({ "Down", 1 }) },
    { key = "j",          action = act.AdjustPaneSize({ "Down", 1 }) },

    { key = "Escape",     action = act.PopKeyTable },
    { key = "q",          action = act.PopKeyTable },
    { key = "Enter",      action = act.PopKeyTable },
  },

  -- LEADER a (keymaps.lua). Times out after 1s.
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
