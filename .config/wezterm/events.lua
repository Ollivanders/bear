local wt = require("wezterm")
local act = wt.action
local funcs = require("functions")

local M = {}

M.setup = function()
  wt.on("gui-startup", function()
    local _, _, window = wt.mux.spawn_window({})
    window:gui_window():maximize()
  end)

  wt.on("trigger-vim-with-scrollback", function(window, pane)
    local text = pane:get_lines_as_text(pane:get_dimensions().scrollback_rows)

    local name = os.tmpname()
    local f = io.open(name, "w+")
    f:write(text)
    f:close()

    window:perform_action(act.SpawnCommandInNewWindow({ args = { "nvim", name } }), pane)

    -- Spawn is async and not awaitable; give nvim time to read the file before
    -- removing it, without blocking the GUI thread.
    wt.time.call_after(5, function()
      os.remove(name)
    end)
  end)

  wt.on("update-status", function(window, pane)
    local SOLID_LEFT_ARROW = utf8.char(0xe0b2)
    local segments = funcs.segments_for_right_status(window)
    if #segments == 0 then
      window:set_right_status("")
      return
    end

    -- Powerline segments shade progressively from bg+20% down to bg.
    local palette = window:effective_config().resolved_palette
    local bg = wt.color.parse(palette.background)
    local fg = palette.foreground
    local gradient = wt.color.gradient({
      orientation = "Horizontal",
      colors = { bg:lighten(0.2), bg },
    }, #segments)

    local elements = { { Background = { Color = "none" } } }
    for i, seg in ipairs(segments) do
      table.insert(elements, { Foreground = { Color = gradient[i] } })
      table.insert(elements, { Text = SOLID_LEFT_ARROW })
      table.insert(elements, { Foreground = { Color = fg } })
      table.insert(elements, { Background = { Color = gradient[i] } })
      table.insert(elements, { Text = " " .. seg .. " " })
    end

    window:set_right_status(wt.format(elements))
  end)

  wt.on("format-tab-title", function(tab, tabs, panes, config, hover, max_width)
    local title = wt.truncate_right(funcs.get_tab_title(tab), max_width - 3)
    return { { Text = " " .. title .. (tab.is_active and "*" or "") .. " " } }
  end)

  wt.on("choose-project", function(window, pane)
    local choices = {}
    for _, value in ipairs(funcs.project_dirs()) do
      table.insert(choices, { label = value })
    end

    window:perform_action(
      act.InputSelector({
        title = "Projects",
        choices = choices,
        fuzzy = true,
        action = wt.action_callback(function(win, p, _, label)
          if not label then
            return
          end
          win:perform_action(act.SpawnCommandInNewTab({ cwd = label }), p)
        end),
      }),
      pane
    )
  end)
end

return M
