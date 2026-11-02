local wt = require("wezterm")
local project_dir = wt.home_dir .. "/projects"

local M = {}

-- Poll Spotify every 5s. Each config load bumps a generation counter in wt.GLOBAL; timers from
-- older loads see a stale generation and stop, so reloads neither stack nor kill the poller.
function M.start_playback_poller()
  local gen = (wt.GLOBAL.playback_poller_gen or 0) + 1
  wt.GLOBAL.playback_poller_gen = gen

  local function poll()
    if wt.GLOBAL.playback_poller_gen ~= gen then
      return
    end
    local called, ok, stdout = pcall(wt.run_child_process, {
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
      ]],
    })
    local playback = called and ok and stdout:gsub("%s+$", "") or ""
    wt.GLOBAL.playback = wt.truncate_right(playback, 40)
    wt.time.call_after(5, poll)
  end

  wt.time.call_after(0, poll)
end

function M.segments_for_right_status(window)
  local bat = ""
  for _, b in ipairs(wt.battery_info()) do
    bat = "🔋 " .. string.format("%.0f%%", b.state_of_charge * 100)
  end

  local key_table = window:active_key_table()

  local segments = {}
  for _, seg in ipairs({
    key_table and ("TABLE: " .. key_table) or "",
    wt.strftime("%a %b %-d %H:%M:%S"),
    wt.hostname(),
    bat,
    wt.GLOBAL.playback or "",
  }) do
    if seg ~= "" then
      table.insert(segments, seg)
    end
  end
  return segments
end

function M.get_tab_title(tab)
  -- prefer an explicitly-set tab title
  local title = tab.tab_title
  if title and #title > 0 then
    return title
  end

  title = tab.active_pane.title
  if string.find(title, "nvim") then
    return "nvim"
  end
  return title
end

function M.project_dirs()
  local projects = { wt.home_dir, wt.home_dir .. "/scratch", wt.home_dir .. "/.config/nvim" }
  for _, dir in ipairs(wt.glob(project_dir .. "/*")) do
    table.insert(projects, dir)
  end
  return projects
end

return M
