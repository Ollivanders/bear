return {
  "folke/snacks.nvim",
  ---@type snacks.Config
  opts = {
    terminal = {
      win = {
        -- merged over snacks' default terminal keys (q = hide, double <esc> = normal mode)
        keys = {
          -- Ctrl+hjkl in terminal mode: route through smart-splits so it crosses into WezTerm panes
          nav_h = {
            "<C-h>",
            function(self)
              return self:is_floating() and "<C-h>" or vim.schedule(require("smart-splits").move_cursor_left)
            end,
            mode = "t",
            expr = true,
            desc = "Move left",
          },
          nav_j = {
            "<C-j>",
            function(self)
              return self:is_floating() and "<C-j>" or vim.schedule(require("smart-splits").move_cursor_down)
            end,
            mode = "t",
            expr = true,
            desc = "Move down",
          },
          nav_k = {
            "<C-k>",
            function(self)
              return self:is_floating() and "<C-k>" or vim.schedule(require("smart-splits").move_cursor_up)
            end,
            mode = "t",
            expr = true,
            desc = "Move up",
          },
          nav_l = {
            "<C-l>",
            function(self)
              return self:is_floating() and "<C-l>" or vim.schedule(require("smart-splits").move_cursor_right)
            end,
            mode = "t",
            expr = true,
            desc = "Move right",
          },
          -- open file under cursor without hiding the terminal
          gf = function()
            local f = vim.fn.findfile(vim.fn.expand("<cfile>"), "**")
            if f == "" then
              Snacks.notify.warn("No file under cursor")
            else
              vim.schedule(function()
                vim.cmd.edit(f)
              end)
            end
          end,
          gl = function()
            local cfile = vim.fn.expand("<cfile>")
            if cfile:match("^https?://") or cfile:match("^www%.") then
              vim.ui.open(cfile)
            else
              Snacks.notify.warn("No URL under cursor")
            end
          end,
        },
      },
    },
    picker = {
      sources = {
        explorer = { hidden = true },
        files = { hidden = true },
      },
    },
    lazygit = { configure = true },
    dashboard = {
      enabled = false,
      width = 60,
      preset = {
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
  },
}
