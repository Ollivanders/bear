-- Patches LazyVim's lualine spec rather than replacing it, so upstream fixes still land.

-- monokai-pro's bundled lualine theme has no `terminal` mode entry, so lualine falls back to
-- `normal` and both end up the same yellow. Add a distinct terminal colour on top of it.
local function theme_with_terminal_mode()
  local ok, theme = pcall(function()
    local scheme = require("monokai-pro").get_scheme()
    local t = vim.deepcopy(require("lualine.themes.monokai-pro"))
    t.terminal = {
      a = { bg = scheme.base.cyan, fg = scheme.base.black, gui = "bold" },
      b = { bg = scheme.base.dimmed5, fg = scheme.base.cyan },
    }
    return t
  end)
  return ok and theme or "auto"
end

local winbar = {
  lualine_c = {
    { "filetype", icon_only = true, separator = "", padding = { left = 1, right = 0 } },
    {
      "filename",
      path = 1, -- relative path
      shorting_target = 40,
      symbols = { modified = "[+]", readonly = "[-]", unnamed = "[No Name]", newfile = "[New]" },
    },
  },
}

return {
  "nvim-lualine/lualine.nvim",
  opts = function(_, opts)
    opts.options.theme = theme_with_terminal_mode()
    opts.options.component_separators = { left = "", right = "" }
    opts.options.section_separators = { left = "", right = "" }
    -- "snacks_terminal" excluded so lualine doesn't overwrite the tab-strip winbar from user.terminal_tabs
    opts.options.disabled_filetypes.winbar =
      { "dashboard", "alpha", "ministarter", "snacks_dashboard", "snacks_terminal" }

    opts.winbar = winbar
    opts.inactive_winbar = winbar

    opts.sections.lualine_b = {
      {
        function()
          return "📂 " .. vim.fn.fnamemodify(vim.fn.getcwd(), ":t")
        end,
      },
      "branch",
    }
    -- searchcount ahead of LazyVim's noice/dap/lazy/diff components
    table.insert(opts.sections.lualine_x, 1, { "searchcount", maxcount = 999, timeout = 500 })
    opts.sections.lualine_y = {
      { "tabs", tab_max_length = 40, max_length = vim.o.columns / 3, mode = 0 },
    }
    opts.sections.lualine_z = {
      { "progress", separator = " | ", padding = { left = 1, right = 0 } },
      { "location", padding = { left = 0, right = 1 } },
    }
    opts.extensions = { "lazy" }
  end,
}
