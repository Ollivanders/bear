-- Pane integration: first backend whose detect() succeeds wins (WezTerm, then Ghostty 1.3+ on macOS)
return {
  "smart-splits-nvim/smart-splits.nvim",
  version = "^3.0.0",
  lazy = false,
  dependencies = {
    { "smart-splits-nvim/backend-wezterm", main = "smart-splits-backend-wezterm", opts = {} },
    { "smart-splits-nvim/backend-ghostty", main = "smart-splits-backend-ghostty", opts = {} },
  },
  init = function()
    -- backend-wezterm only detects via SMART_SPLITS_WEZTERM, which WezTerm sets for panes spawned
    -- after its config loaded; fall back to WEZTERM_PANE so older panes still integrate
    if vim.env.WEZTERM_PANE and not vim.env.SMART_SPLITS_WEZTERM then
      vim.env.SMART_SPLITS_WEZTERM = "0.1.0"
    end
  end,
  opts = {
    mux = { backend = { "smart-splits-backend-wezterm", "smart-splits-backend-ghostty" } },
    move = { at_edge = "stop" },
  },
}
