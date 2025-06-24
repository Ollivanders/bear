return {
  "okuuva/auto-save.nvim",
  version = "^1.0.0",
  cmd = "ASToggle",
  event = { "WinLeave" },
  opts = {
    trigger_events = {
      immediate_save = { "BufLeave", "FocusLost", "QuitPre", "VimSuspend" },
      defer_save = { "WinLeave" },
      cancel_deferred_save = { "InsertEnter" },
    },
  },
}
