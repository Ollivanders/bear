local wt = require("wezterm")
local project_dir = wt.home_dir .. "/projects"
local stored_playback = ""

local M = {}


function M.get_currently_playing()
  local ok, stdout, stderr = wt.run_child_process {
    "/usr/bin/osascript",
    "-e",
    [[
      if application "Spotify" is running then
        tell application "Spotify"
          if player state is playing then
            artist of current track & " – " & name of current track
          end if
        end tell
      end if
    ]]
  }
  stored_playback = stdout
  wt.time.call_after(5, M.get_currently_playing)
end

-- if you are *NOT* lazy-loading smart-splits.nvim (recommended)
local function is_vim(pane)
  -- this is set by the plugin, and unset on ExitPre in Neovim
  return pane:get_user_vars().IS_NVIM == 'true'
end

local direction_keys = {
  h = 'Left',
  j = 'Down',
  k = 'Up',
  l = 'Right',
}
function M.split_nav(resize_or_move, key)
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

function M.segments_for_right_status(window)
  local bat = ''
  for _, b in ipairs(wt.battery_info()) do
    bat = '🔋 ' .. string.format('%.0f%%', b.state_of_charge * 100)
  end

  return {
    window:active_workspace(),
    wt.strftime("%a %b %-d %H:%M:%S"),
    wt.hostname(),
    bat,
    stored_playback,
  }
end

function M.get_tab_title(tab)
  -- prefer an explicitly-set tab title
  local title = tab.tab_title
  if title and #title > 0 then
    return title
  end

  local pane = tab.active_pane
  title = pane.title
  if string.find(title, "nvim") then
    return "nvim"
  end
  return title
end

function M.project_dirs()
  local projects = { wt.home_dir, wt.home_dir .. '/scratch', wt.home_dir .. '/nvim/config' }
  for _, dir in ipairs(wt.glob(project_dir .. '/*')) do
    table.insert(projects, dir)
  end
  return projects
end

return M
