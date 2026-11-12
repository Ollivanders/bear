local colors = require("colors")
local settings = require("settings")
local app_icons = require("helpers.app_icons")
local sbar = require("sketchybar")

sbar.add("event", "aerospace_workspace_change")
sbar.add("event", "aerospace_windows_change")

local workspaces = {}
local refresh_icons

-- Function to execute shell commands and return the output
local function execute_command(command)
  local handle = io.popen(command)
  local result = handle:read("*a")
  handle:close()
  return result
end

local function add_workspace(workspace_id)
  local space = sbar.add("item", "space." .. tostring(workspace_id), {
    icon = {
      font = { family = settings.font.numbers, size = 18 },
      string = workspace_id,
      padding_left = 15,
      padding_right = 8,
      color = colors.aerospace_label_color,
      highlight_color = colors.aerospace_label_highlight_color,
    },
    label = {
      padding_right = 20,
      color = colors.aerospace_label_color,
      highlight_color = colors.aerospace_label_highlight_color,
      font = "sketchybar-app-font:Regular:16.0",
      y_offset = -1,
    },
    padding_right = 1,
    padding_left = 1,
    background = {
      color = colors.bg1,
      border_width = 1,
      height = 26,
    },
    popup = { background = { border_width = 5, border_color = colors.black } },
  })

  workspaces[workspace_id] = space

  -- Single item bracket for space items to achieve double border on highlight
  local space_bracket = sbar.add("bracket", { space.name }, {
    background = {
      color = colors.transparent,
      height = 28,
      border_width = 2,
    },
  })

  -- Padding space
  sbar.add("item", "space.padding." .. tostring(workspace_id), {
    script = "",
    width = settings.group_paddings,
  })

  space:subscribe({ "aerospace_workspace_change" }, function(env)
    local selected = tonumber(env.FOCUSED_WORKSPACE) == workspace_id
    space:set({
      icon = { highlight = selected },
      label = { highlight = selected },
      background = { border_color = selected and colors.aerospace_label_highlight_color or colors.bg2 },
    })
    space_bracket:set({
      background = { border_color = selected and colors.aerospace_border_color or colors.bg2 },
    })
  end)

  space:subscribe("mouse.clicked", function()
    sbar.exec("aerospace workspace " .. tostring(workspace_id))
  end)

end

-- Show every configured Aerospace workspace, not just the ones currently assigned to a monitor.
local workspace_output = execute_command("aerospace list-workspaces --all")
for workspace_id in workspace_output:gmatch("[^\r\n]+") do
  local parsed_workspace_id = tonumber(workspace_id)
  if parsed_workspace_id ~= nil then
    add_workspace(parsed_workspace_id)
  end
end

-- Refresh every workspace's icons from a single aerospace call so windows
-- moved off a workspace don't leave stale icons behind.
refresh_icons = function()
  sbar.exec("aerospace list-windows --all --format '%{workspace}|%{app-name}'", function(output)
    local lines = {}
    for workspace_id, _ in pairs(workspaces) do
      lines[workspace_id] = ""
    end
    for line in output:gmatch("[^\r\n]+") do
      local ws, app_name = line:match("^%s*(.-)|(.-)%s*$")
      local id = tonumber(ws)
      if id ~= nil and lines[id] ~= nil and app_name ~= "" then
        local icon = app_icons[app_name] or app_icons["default"]
        lines[id] = lines[id] .. " " .. icon
      end
    end
    for workspace_id, icon_line in pairs(lines) do
      workspaces[workspace_id]:set({ label = icon_line == "" and " —" or icon_line })
    end
  end)
end

local space_window_observer = sbar.add("item", {
  drawing = false,
  updates = true,
})

space_window_observer:subscribe(
  { "aerospace_workspace_change", "aerospace_windows_change", "front_app_switched", "space_windows_change", "system_woke" },
  function()
    refresh_icons()
  end
)

-- initial run
local ok, ws = pcall(function()
  return execute_command("aerospace list-workspaces --focused"):gsub("%s+", "")
end)
local focused_workspace = ok and tonumber(ws) or -1

refresh_icons()

sbar.trigger("aerospace_workspace_change", { FOCUSED_WORKSPACE = focused_workspace })
