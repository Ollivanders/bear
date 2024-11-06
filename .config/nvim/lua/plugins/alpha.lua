return {
  "goolord/alpha-nvim",
  opts = function()
    local dashboard = require("alpha.themes.dashboard")
    local logo = [[
        ______     __         __         __     __   __   ______     __   __     _____     ______     ______     ______
      /\  __ \   /\ \       /\ \       /\ \   /\ \ / /  /\  __ \   /\ "-.\ \   /\  __-.  /\  ___\   /\  == \   /\  ___\
      \ \ \/\ \  \ \ \____  \ \ \____  \ \ \  \ \ \'/   \ \  __ \  \ \ \-.  \  \ \ \/\ \ \ \  __\   \ \  __<   \ \___  \
      \ \_____\  \ \_____\  \ \_____\  \ \_\  \ \__|    \ \_\ \_\  \ \_\\"\_\  \ \____-  \ \_____\  \ \_\ \_\  \/\_____\
      \/_____/   \/_____/   \/_____/   \/_/   \/_/      \/_/\/_/   \/_/ \/_/   \/____/   \/_____/   \/_/ /_/   \/_____/
    ]]

    dashboard.section.header.val = vim.split(logo, "\n")
      -- stylua: ignore
      dashboard.section.buttons.val = {
        dashboard.button("f", " " .. " Files",       LazyVim.pick()),
        dashboard.button("n", " " .. " New",        [[<cmd> ene <BAR> startinsert <cr>]]),
        dashboard.button("r", " " .. " Recent",    LazyVim.pick("oldfiles")),
        dashboard.button("g", " " .. " Find",       LazyVim.pick("live_grep")),
        dashboard.button("c", " " .. " Settings",          LazyVim.pick.config_files()),
        dashboard.button("s", " " .. " Session", [[<cmd> lua require("persistence").load() <cr>]]),
        dashboard.button("x", " " .. " Extras",     "<cmd> LazyExtras <cr>"),
        dashboard.button("l", "󰒲 " .. " Lazy",            "<cmd> Lazy <cr>"),
        dashboard.button("q", " " .. " Quit",            "<cmd> qa <cr>"),
      }

    for _, button in ipairs(dashboard.section.buttons.val) do
      button.opts.hl = "AlphaButtons"
      button.opts.hl_shortcut = "AlphaShortcut"
    end

    dashboard.section.header.opts.hl = "AlphaHeader"
    dashboard.section.buttons.opts.hl = "AlphaButtons"
    dashboard.section.footer.opts.hl = "AlphaFooter"
    dashboard.opts.layout[1].val = 8

    return dashboard
  end,
  config = function()
    require("alpha").setup(require("alpha.themes.dashboard").config)
  end,
}
