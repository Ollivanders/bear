-- Tabbed terminal groups on top of snacks.nvim.
-- Snacks has no concept of "tabs" - each terminal is just a window keyed by
-- (cmd, cwd, env, count). This module tracks an ordered tab list + active
-- tab per named group, and always hides the current tab before showing the
-- next so snacks' stack-split behavior never kicks in (only one terminal
-- per group is ever visible at a time).
--
-- All actions except `toggle` accept an optional group name; when omitted
-- they operate on `M.current` (whichever group was touched most recently),
-- so global keymaps can drive tab switching without needing terminal focus.

local M = {}

M.groups = {}
M.current = nil

function M.setup(name, win_opts)
  win_opts = vim.deepcopy(win_opts)
  win_opts.wo = win_opts.wo or {}
  -- `v:lua.<path>(...)` only supports a plain dotted path - `require(...)` with
  -- parens mid-chain is NOT allowed (:help v:lua-call), so this must use the
  -- single-quote-no-parens require form or it silently renders nothing.
  win_opts.wo.winbar = string.format("%%{%%v:lua.require'custom.util.terminal_tabs'.tabline(%q)%%}", name)
  M.groups[name] = {
    win_opts = win_opts,
    tabs = {},
    active = nil,
    next_id = 1,
  }
end

local function get_group(name)
  name = name or M.current
  return name and M.groups[name]
end

local function get_term(count, win_opts, create)
  return require("snacks").terminal.get(nil, { count = count, win = win_opts, create = create })
end

function M.tabline(name)
  local group = M.groups[name]
  if not group or #group.tabs == 0 then
    return ""
  end
  local parts = { name .. " " }
  for i, count in ipairs(group.tabs) do
    if count == group.active then
      parts[#parts + 1] = "%#TabLineSel# " .. i .. " %#TabLine#"
    else
      parts[#parts + 1] = " " .. i .. " "
    end
  end
  return table.concat(parts)
end

-- Show a tab that's already in the group's list (creating its terminal if needed).
-- `snacks.terminal.get` only (re)shows a terminal when it creates it - a hidden
-- terminal still has a live buffer, so it's returned as-is without being shown.
-- `win:show()` is idempotent, so call it unconditionally.
local function show_tab(name, group, count)
  group.active = count
  M.current = name
  get_term(count, group.win_opts, true):show()
  vim.cmd("redrawstatus")
end

function M.toggle(name)
  local group = get_group(name)
  if not group then
    return
  end
  M.current = name

  if #group.tabs == 0 then
    return M.new(name)
  end

  local current = get_term(group.active, group.win_opts, false)
  if current and current:valid() then
    current:hide()
  else
    show_tab(name, group, group.active)
  end
end

function M.new(name)
  name = name or M.current
  local group = get_group(name)
  if not group then
    return
  end

  local current = get_term(group.active, group.win_opts, false)
  if current and current:valid() then
    current:hide()
  end

  local count = group.next_id
  group.next_id = group.next_id + 1
  table.insert(group.tabs, count)
  show_tab(name, group, count)
end

local function cycle(name, step)
  name = name or M.current
  local group = get_group(name)
  if not group or #group.tabs <= 1 then
    return
  end

  local idx
  for i, count in ipairs(group.tabs) do
    if count == group.active then
      idx = i
      break
    end
  end
  if not idx then
    return
  end

  local target = group.tabs[((idx - 1 + step) % #group.tabs) + 1]

  local current = get_term(group.active, group.win_opts, false)
  if current and current:valid() then
    current:hide()
  end

  show_tab(name, group, target)
end

function M.next(name)
  cycle(name, 1)
end

function M.prev(name)
  cycle(name, -1)
end

function M.close(name)
  name = name or M.current
  local group = get_group(name)
  if not group or #group.tabs == 0 then
    return
  end

  local idx
  for i, count in ipairs(group.tabs) do
    if count == group.active then
      idx = i
      break
    end
  end

  local current = get_term(group.active, group.win_opts, false)
  if current then
    current:close()
  end
  if idx then
    table.remove(group.tabs, idx)
  end

  if #group.tabs == 0 then
    group.active = nil
    return
  end

  local next_idx = idx and math.min(idx, #group.tabs) or 1
  show_tab(name, group, group.tabs[next_idx])
end

function M.pick(name)
  name = name or M.current
  local group = get_group(name)
  if not group or #group.tabs == 0 then
    return
  end

  vim.ui.select(group.tabs, {
    prompt = "Terminal tab (" .. name .. ")",
    format_item = function(count)
      local marker = count == group.active and "* " or "  "
      local idx = 0
      for i, c in ipairs(group.tabs) do
        if c == count then
          idx = i
        end
      end
      return marker .. idx
    end,
  }, function(choice)
    if not choice or choice == group.active then
      return
    end
    local current = get_term(group.active, group.win_opts, false)
    if current and current:valid() then
      current:hide()
    end
    show_tab(name, group, choice)
  end)
end

return M
