local colors = require("colors")
local settings = require("settings")
local app_icons = require("helpers.app_icons")
local sbar = require("sketchybar")

sbar.add("event", "aerospace_workspace_change")

local workspaces = {}
local set_icon_line

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

  space:subscribe({ "space_windows_change" }, function()
    set_icon_line(workspace_id)
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

function set_icon_line(workspace_id)
  sbar.exec(
    "aerospace list-windows --format %{app-name} --workspace " .. tostring(workspace_id),
    function(app_names)
      local no_app = true
      local icon_line = ""
      for app_name in app_names:gmatch("[^\r\n]+") do
        local trimmed_app_name = app_name:match("^%s*(.-)%s*$")
        if trimmed_app_name ~= "" then
          no_app = false
          local lookup = app_icons[trimmed_app_name]
          local icon = ((lookup == nil) and app_icons["default"] or lookup)
          icon_line = icon_line .. " " .. icon
        end
      end

      if no_app then
        icon_line = " —"
      end

      local workspace = workspaces[tonumber(workspace_id)]
      if workspace ~= nil then
        sbar.animate("tanh", 10, function()
          workspace:set({ label = icon_line })
        end)
      end
    end
  )
end

local space_window_observer = sbar.add("item", {
  drawing = false,
  updates = true,
})

space_window_observer:subscribe({ "aerospace_workspace_change" }, function(env)
  set_icon_line(env.FOCUSED_WORKSPACE)
end)

-- initial run
local ok, ws = pcall(function()
  return execute_command("aerospace list-workspaces --focused"):gsub("%s+", "")
end)
local focused_workspace = ok and tonumber(ws) or -1

for workspace_id, _ in pairs(workspaces) do
  set_icon_line(workspace_id)
end

sbar.trigger("aerospace_workspace_change", { FOCUSED_WORKSPACE = focused_workspace })
