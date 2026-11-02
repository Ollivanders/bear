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

-- Nerd Font codepoints (kept as utf8.char so editors can't strip the private-use glyphs).
-- color = icon tint, so nvim and other tools stand out from plain shells.
local process_icons = {
  nvim = { icon = utf8.char(0xf36f), color = "#8bb35a" },
  vim = { icon = utf8.char(0xe62b), color = "#8bb35a" },
  zsh = { icon = utf8.char(0xf489) },
  bash = { icon = utf8.char(0xf489) },
  fish = { icon = utf8.char(0xf489) },
  ssh = { icon = utf8.char(0xf08c0), color = "#d08770" },
  python = { icon = utf8.char(0xe73c), color = "#ebcb8b" },
  python3 = { icon = utf8.char(0xe73c), color = "#ebcb8b" },
  node = { icon = utf8.char(0xe718), color = "#a3be8c" },
  git = { icon = utf8.char(0xe702), color = "#d08770" },
  lazygit = { icon = utf8.char(0xe702), color = "#d08770" },
  docker = { icon = utf8.char(0xf308), color = "#81a1c1" },
  kubectl = { icon = utf8.char(0xf10fe), color = "#81a1c1" },
  k9s = { icon = utf8.char(0xf10fe), color = "#81a1c1" },
  claude = { icon = utf8.char(0xf06a9), color = "#d4a27f" },
}
local default_icon = { icon = utf8.char(0xf489) }
local shells = { zsh = true, bash = true, fish = true }

local function basename(path)
  return (path or ""):gsub("/+$", ""):match("([^/]+)$") or path or ""
end

-- Returns { index, icon, icon_color, dir, process } for format-tab-title.
-- A manually set tab title replaces the dir; nvim's automatic "p: <dir>" title is ignored.
function M.get_tab_title(tab)
  local pane = tab.active_pane
  local process = basename(pane.foreground_process_name)
  local info = process_icons[process] or default_icon

  local dir = ""
  local cwd = pane.current_working_dir
  if cwd then
    local path = type(cwd) == "string" and cwd:gsub("^file://[^/]*", "") or cwd.file_path
    dir = path:gsub("/+$", "") == wt.home_dir and "~" or basename(path)
  end

  local title = tab.tab_title
  if title and #title > 0 and not title:match("^p: ") then
    dir = title
  elseif dir == "" then
    dir = (title or ""):gsub("^p: ", "")
    if dir == "" then
      dir = pane.title
    end
  end

  return {
    index = tab.tab_index + 1,
    icon = info.icon,
    icon_color = info.color,
    dir = dir,
    process = (not shells[process] and process ~= "") and process or nil,
  }
end

function M.project_dirs()
  local projects = { wt.home_dir, wt.home_dir .. "/scratch", wt.home_dir .. "/.config/nvim" }
  for _, dir in ipairs(wt.glob(project_dir .. "/*")) do
    table.insert(projects, dir)
  end
  return projects
end

return M
