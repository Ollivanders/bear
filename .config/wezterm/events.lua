local wt = require("wezterm")
local io = require 'io'
local os = require 'os'
local mux = wt.mux
local act = wt.action
local funcs = require("functions")

local M = {}

M.setup = function()
  wt.on("gui-startup", function()
    local tab, pane, window = mux.spawn_window({})
    window:gui_window():maximize()
  end)

  wt.on('trigger-vim-with-scrollback', function(window, pane)
    -- Retrieve the text from the pane
    local text = pane:get_lines_as_text(pane:get_dimensions().scrollback_rows)

    -- Create a temporary file to pass to vim
    local name = os.tmpname()
    local f = io.open(name, 'w+')
    f:write(text)
    f:flush()
    f:close()

    -- Open a new window running vim and tell it to open the file
    window:perform_action(
      act.SpawnCommandInNewWindow {
        args = { 'nvim', name },
      },
      pane
    )

    -- Wait "enough" time for vim to read the file before we remove it.
    -- The window creation and process spawn are asynchronous wrt. running
    -- this script and are not awaitable, so we just pick a number.
    --
    -- Note: We don't strictly need to remove this file, but it is nice
    -- to avoid cluttering up the temporary directory.
    wt.sleep_ms(1000)
    os.remove(name)
  end)


  wt.on("update-right-status", function(window, pane)
    local name = window:active_key_table()
    if name then
      name = "TABLE: " .. name
    end
    window:set_right_status(name or "")
  end)

  wt.on("update-status", function(window, _)
    local SOLID_LEFT_ARROW = utf8.char(0xe0b2)
    local segments = funcs.segments_for_right_status(window)

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

  wt.on("format-tab-title",
    function(tab, tabs, panes, config, hover, max_width)
      local title = funcs.get_tab_title(tab)
      return {
        { Text = ' ' .. title .. '*' },
      }
    end
  )

  wt.on("choose-project", function(window, pane)
    local choices = {}
    for _, value in ipairs(funcs.project_dirs()) do
      table.insert(choices, { label = value })
    end

    window:perform_action(
      wt.action.InputSelector {
        title = "Projects",
        choices = choices,
        fuzzy = true,
        action = wt.action_callback(function(win, p, id, label)
          if not label then return end
          wt.log_info("you selected ", id, label)
          win:perform_action(
            wt.action.SpawnCommandInNewTab { cwd = label },
            p
          )
        end),
      },
      pane
    )
  end)
end

return M
