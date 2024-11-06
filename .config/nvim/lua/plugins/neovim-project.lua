return {
  "coffebar/neovim-project",
  opts = {
    projects = {
      "~/projects/*",
      "~/.config/*",
      "~/scratch/*",
    },
    datapath = vim.fn.stdpath("data"), -- ~/.local/share/nvim/
    dashboard_mode = true,
    picker = {
      type = "telescope", -- or "fzf-lua"
    },
  },
  init = function()
    -- enable saving the state of plugins in the session
    vim.opt.sessionoptions:append("globals") -- save global variables that start with an uppercase letter and contain at least one lowercase letter.
  end,
  dependencies = {
    { "nvim-lua/plenary.nvim" },
    -- optional picker
    { "nvim-telescope/telescope.nvim", tag = "0.1.4" },
    -- optional picker
    { "ibhagwan/fzf-lua" },
    { "Shatur/neovim-session-manager" },
  },
  lazy = false,
  priority = 100,
}

-- :NeovimProjectDiscover - find a project based on patterns.
-- :NeovimProjectHistory - select a project from your recent history.
-- :NeovimProjectLoadRecent - open the previous session.
-- :NeovimProjectLoadHist - opens the project from the history providing a project dir.
-- :NeovimProjectLoad - opens the project from all your projects providing a project dir.
