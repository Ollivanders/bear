-- lazy.nvim
return {
  "snacks.nvim",
  opts = {
    ---@class snacks.terminal.Config
    terminal = {
      enabled = true,
      keys = {
        q = "hide",
        gf = function(self)
          local f = vim.fn.findfile(vim.fn.expand("<cfile>"), "**")
          if f == "" then
            Snacks.notify.warn("No file under cursor")
          else
            -- self:hide()
            vim.schedule(function()
              vim.cmd("e " .. f)
            end)
          end
        end,
        gl = function(self)
          Snacks.notify.info("run")
          local cfile = vim.fn.expand("<cfile>")

          -- Check if it's a URL
          if cfile:match("^https?://") or cfile:match("^www%.") then
            vim.schedule(function()
              local open_cmd
              if vim.fn.has("mac") == 1 then
                open_cmd = "open"
              elseif vim.fn.has("unix") == 1 then
                open_cmd = "xdg-open"
              elseif vim.fn.has("win32") == 1 then
                open_cmd = "start"
              end

              if open_cmd then
                vim.fn.system(open_cmd .. " " .. vim.fn.shellescape(cfile))
              else
                Snacks.notify.warn("No command to open URLs on this system")
              end
            end)
          else
            Snacks.notify.warn("No file under cursor")
          end
        end,
        term_normal = {
          "<esc>",
          function(self)
            self.esc_timer = self.esc_timer or (vim.uv or vim.loop).new_timer()
            if self.esc_timer:is_active() then
              self.esc_timer:stop()
              vim.cmd("stopinsert")
            else
              self.esc_timer:start(200, 0, function() end)
              return "<esc>"
            end
          end,
          mode = "t",
          expr = true,
          desc = "Double escape to normal mode",
        },
      },
    },
    picker = {
      sources = {
        explorer = {
          hidden = true,
          -- ignored = true,
        },
        files = {
          hidden = true,
          -- ignored = true,
        },
      },
    },
    winpicker = {
      enabled = true,
      ui = {
        width = 0.3,        -- percentage of screen width
        height = 0.3,       -- percentage of screen height
        border = "double", -- "single", "double", "rounded", "none"
        row = 0.9,          -- center vertically (0 = top, 1 = bottom)
        col = 0.9,          -- center horizontally (0 = left, 1 = right)
      },
    },
    ---@class snacks.dashboard.Config
    dashboard = {
      enabled = false,
      width = 60,
      row = nil,                                                                   -- dashboard position. nil for center
      col = nil,                                                                   -- dashboard position. nil for center
      pane_gap = 4,                                                                -- empty columns between vertical panes
      autokeys = "1234567890abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ", -- autokey sequence
      -- These settings are used by some built-in sections
      preset = {
        -- Defaults to a picker that supports `fzf-lua`, `telescope.nvim` and `mini.pick`
        ---@type fun(cmd:string, opts:table)|nil
        pick = nil,
        -- Used by the `keys` section to show keymaps.
        -- Set your custom keymaps here.
        -- When using a function, the `items` argument are the default keymaps.
        ---@type snacks.dashboard.Item[]
        keys = {
          { icon = " ", key = "f", desc = "Find File", action = ":lua Snacks.dashboard.pick('files')" },
          { icon = " ", key = "n", desc = "New File", action = ":ene | startinsert" },
          { icon = " ", key = "t", desc = "Find Text", action = ":lua Snacks.dashboard.pick('live_grep')" },
          {
            icon = "git",
            key = "g",
            desc = "Git Root Dir",
            action = ":lua Snacks.lazygit( { cwd = LazyVim.root.git() })",
          },
          { icon = " ", key = "r", desc = "Recent Files", action = ":lua Snacks.dashboard.pick('oldfiles')" },
          {
            icon = " ",
            key = "c",
            desc = "Config",
            action = ":lua Snacks.dashboard.pick('files', {cwd = vim.fn.stdpath('config')})",
          },
          { icon = " ", key = "s", desc = "Restore Session", section = "session" },
          -- { icon = " ", key = "x", desc = "Extras", section = ":LazyExtras" },
          { icon = "󰒲 ", key = "L", desc = "Lazy", action = ":Lazy", enabled = package.loaded.lazy ~= nil },
          { icon = " ", key = "q", desc = "Quit", action = ":qa" },
        },
        header = [[
 _____ _      _     _____ _   _  ___   _   _______ ___________  _____
 |  _  | |    | |   |_   _| | | |/ _ \ | \ | |  _  \  ___| ___ \/  ___|
| | | | |    | |     | | | | | / /_\ \|  \| | | | | |__ | |_/ /\ `--.
 | | | | |    | |     | | | | | |  _  || . ` | | | |  __||    /  `--. \
 \ \_/ / |____| |_____| |_\ \_/ / | | || |\  | |/ /| |___| |\ \ /\__/ /
  \___/\_____/\_____/\___/ \___/\_| |_/\_| \_/___/ \____/\_| \_|\____/
                                                            ]],
      },

      sections = {
        { section = "header" },
        { section = "startup", padding = 2 },
        { section = "keys", gap = 0, padding = 2 },
        { icon = " ", title = "Recent Files", section = "recent_files", indent = 2, padding = 2 },
        { icon = " ", title = "Projects", section = "projects", indent = 2, padding = 2 },
        {
          icon = " ",
          title = "Git Status",
          section = "terminal",
          enabled = function()
            return Snacks.git.get_root() ~= nil
          end,
          cmd = "git --no-pager diff --stat -B -M -C",
          height = 5,
          padding = 1,
          ttl = 5 * 60,
          indent = 3,
        },
      },
    },
    lazygit = {
      configure = true,
      win = {
        style = "lazygit",
      },
    }
  },
}
