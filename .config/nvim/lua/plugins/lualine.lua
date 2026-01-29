return {
  "nvim-lualine/lualine.nvim",
  event = "VeryLazy",
  opts = function()
    -- PERF: we don't need this lualine require madness 🤷
    local lualine_require = require("lualine_require")
    lualine_require.require = require

    local icons = LazyVim.config.icons

    vim.o.laststatus = vim.g.lualine_laststatus

    local opts = {
      options = {
        theme = "auto",
        component_separators = { left = "", right = "" },
        section_separators = { left = "", right = "" },
        globalstatus = vim.o.laststatus == 3,
        disabled_filetypes = {
          statusline = { "dashboard", "alpha", "ministarter", "snacks_dashboard" },
          winbar = { "neo-tree", "neo-tree-buffer", "dashboard", "alpha", "ministarter", "snacks_dashboard" },
        },
        always_divide_middle = true,
      },
      winbar = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = {
          {
            "filetype",
            icon_only = true,
            separator = "",
            padding = { left = 1, right = 0 },
          },
          {
            "filename",
            file_status = true,     -- Displays file status (readonly status, modified status)
            newfile_status = false, -- Display new file status (new file means no write after created)
            path = 1,               -- 0: Just the filename
            -- 1: Relative path
            -- 2: Absolute path
            -- 3: Absolute path, with tilde as the home directory
            -- 4: Filename and parent dir, with tilde as the home directory

            shorting_target = 40, -- Shortens path to leave 40 spaces in the window
            -- for other components. (terrible name, any suggestions?)
            symbols = {
              modified = "[+]",      -- Text to show when the file is modified.
              readonly = "[-]",      -- Text to show when the file is non-modifiable or readonly.
              unnamed = "[No Name]", -- Text to show for unnamed buffers.
              newfile = "[New]",     -- Text to show for newly created file before first write
            },
          },
        },
        lualine_x = {},
        lualine_y = {},
        lualine_z = {},
      },

      inactive_winbar = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = {
          { "filetype", icon_only = true, separator = "", padding = { left = 1, right = 0 } },
          {
            "filename",
            file_status = true,     -- Displays file status (readonly status, modified status)
            newfile_status = false, -- Display new file status (new file means no write after created)
            path = 1,               -- 0: Just the filename
            -- 1: Relative path
            -- 2: Absolute path
            -- 3: Absolute path, with tilde as the home directory
            -- 4: Filename and parent dir, with tilde as the home directory

            shorting_target = 40, -- Shortens path to leave 40 spaces in the window
            -- for other components. (terrible name, any suggestions?)
            symbols = {
              modified = "[+]",      -- Text to show when the file is modified.
              readonly = "[-]",      -- Text to show when the file is non-modifiable or readonly.
              unnamed = "[No Name]", -- Text to show for unnamed buffers.
              newfile = "[New]",     -- Text to show for newly created file before first write
            },
          },
        },
        lualine_x = {},
        lualine_y = {},
        lualine_z = {},
      },
      sections = {
        lualine_a = { "mode" },
        lualine_b = {
          {
            function() return '📂 ' .. vim.fn.fnamemodify(vim.fn.getcwd(), ":t") end,
          },
          "branch", "diff" },
        lualine_c = {
          {
            "diagnostics",
            symbols = {
              error = icons.diagnostics.Error,
              warn = icons.diagnostics.Warn,
              info = icons.diagnostics.Info,
              hint = icons.diagnostics.Hint,
            },
          },
        },

        lualine_x = {
          {
            "searchcount",
            maxcount = 999,
            timeout = 500,
          },
          Snacks.profiler.status(),
          -- stylua: ignore
          {
            function() return require("noice").api.status.command.get() end,
            cond = function() return package.loaded["noice"] and require("noice").api.status.command.has() end,
            color = function() return { fg = Snacks.util.color("Statement") } end,
          },
          -- stylua: ignore
          {
            function() return require("noice").api.status.mode.get() end,
            cond = function() return package.loaded["noice"] and require("noice").api.status.mode.has() end,
            color = function() return { fg = Snacks.util.color("Constant") } end,
          },
          -- stylua: ignore
          {
            function() return "  " .. require("dap").status() end,
            cond = function() return package.loaded["dap"] and require("dap").status() ~= "" end,
            color = function() return { fg = Snacks.util.color("Debug") } end,
          },
          -- stylua: ignore
          {
            require("lazy.status").updates,
            cond = require("lazy.status").has_updates,
            color = function() return { fg = Snacks.util.color("Special") } end,
          },
          {
            "diff",
            symbols = {
              added = icons.git.added,
              modified = icons.git.modified,
              removed = icons.git.removed,
            },
            source = function()
              local gitsigns = vim.b.gitsigns_status_dict
              if gitsigns then
                return {
                  added = gitsigns.added,
                  modified = gitsigns.changed,
                  removed = gitsigns.removed,
                }
              end
            end,
          },
        },
        lualine_y = {
          {
            "tabs",
            tab_max_length = 40,            -- Maximum width of each tab. The content will be shorten dynamically (example: apple/orange -> a/orange)
            max_length = vim.o.columns / 3, -- Maximum width of tabs component.
            -- Note:
            -- It can also be a function that returns
            -- the value of `max_length` dynamically.
            mode = 0, -- 0: Shows tab_nr
            -- 1: Shows tab_name
            -- 2: Shows tab_nr + tab_name

            path = 0, -- 0: just shows the filename
            -- 1: shows the relative path and shorten $HOME to ~
            -- 2: shows the full path
            -- 3: shows the full path and shorten $HOME to ~
          },
        },
        lualine_z = {
          {
            "progress",
            separator = " | ",
            padding = { left = 1, right = 0 }
          },
          { "location", padding = { left = 0, right = 1 } },
          -- {
          --   'datetime',
          --   -- options: default, us, uk, iso, or your own format string ("%H:%M", etc..)
          --   style = '%a %b %-d %H:%M:%S'
          -- }
        },
      },
      extensions = { "neo-tree", "lazy", "fzf" },
    }

    -- do not add trouble symbols if aerial is enabled
    -- And allow it to be overriden for some buffer types (see autocmds)
    if vim.g.trouble_lualine and LazyVim.has("trouble.nvim") then
      local trouble = require("trouble")
      local symbols = trouble.statusline({
        mode = "symbols",
        groups = {},
        title = false,
        filter = { range = true },
        format = "{kind_icon}{symbol.name:Normal}",
        hl_group = "lualine_c_normal",
      })
      table.insert(opts.sections.lualine_c, {
        symbols and symbols.get,
        cond = function()
          return vim.b.trouble_lualine ~= false and symbols.has()
        end,
      })
    end

    return opts
  end,
}
