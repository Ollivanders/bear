local wt = require("wezterm")
local act = wt.action

local move_pane_to_new_window = wt.action_callback(function(_, pane)
  pane:move_to_new_window()
end)

return {
  { key = "o", mods = "CTRL|SHIFT", action = act.PaneSelect({}) },
  { key = "@", mods = "CTRL|SHIFT", action = act.QuickSelect },
  { key = "t", mods = "CTRL|SHIFT", action = act.TogglePaneZoomState },
  { key = "!", mods = "CTRL|SHIFT", action = move_pane_to_new_window },
  {
    key = "F12",
    action = wt.action_callback(function(_, pane)
      local tab = pane:tab()
      local panes = tab:panes_with_info()
      if #panes == 1 then
        pane:split({ direction = "Right", size = 0.4 })
      elseif not panes[1].is_zoomed then
        panes[1].pane:activate()
        tab:set_zoomed(true)
      else
        tab:set_zoomed(false)
        panes[2].pane:activate()
      end
    end),
  },
  {
    key = ",",
    mods = "CMD",
    action = act.SpawnCommandInNewTab({ cwd = wt.home_dir, args = { "nvim", wt.config_file } }),
  },
  { key = "w", mods = "CMD", action = act.CloseCurrentPane({ confirm = true }) },

  -- word jumps (readline/zsh: Meta-b backward-word, Meta-f forward-word)
  { key = "LeftArrow", mods = "OPT", action = act.SendString("\x1bb") },
  { key = "RightArrow", mods = "OPT", action = act.SendString("\x1bf") },

  { key = "-", mods = "CTRL", action = act.DisableDefaultAssignment },
  { key = "=", mods = "CTRL", action = act.DisableDefaultAssignment },

  -- leader (Ctrl+Space)
  {
    key = ",",
    mods = "LEADER",
    action = act.PromptInputLine({
      description = "Enter new name for tab",
      action = wt.action_callback(function(window, _, line)
        if line then
          window:active_tab():set_title(line)
        end
      end),
    }),
  },
  { key = ";", mods = "LEADER", action = act.ActivatePaneDirection("Prev") },
  { key = ":", mods = "LEADER", action = act.ActivatePaneDirection("Next") },
  { key = "{", mods = "LEADER", action = act.PaneSelect({ mode = "SwapWithActiveKeepFocus" }) },
  { key = "t", mods = "LEADER", action = act.ShowTabNavigator },
  { key = "r", mods = "LEADER", action = act.ActivateKeyTable({ name = "resize_pane", one_shot = false }) },
  { key = "a", mods = "LEADER", action = act.ActivateKeyTable({ name = "activate_pane", timeout_milliseconds = 1000 }) },
  { key = "p", mods = "LEADER", action = act.EmitEvent("choose-project") },
  { key = "e", mods = "LEADER", action = act.EmitEvent("trigger-vim-with-scrollback") },
  { key = "f", mods = "LEADER", action = act.ShowLauncherArgs({ flags = "FUZZY|WORKSPACES" }) },
  { key = "w", mods = "LEADER", action = move_pane_to_new_window },

  -- pane move/resize (Ctrl/Alt+hjkl) handled by smart-splits backend-wezterm, see wezterm.lua
}
