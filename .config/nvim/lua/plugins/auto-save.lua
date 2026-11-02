-- sole save strategy (defaults also save immediately on BufLeave/FocusLost)
return {
  "okuuva/auto-save.nvim",
  cmd = "ASToggle",
  event = { "InsertLeave", "TextChanged" },
  opts = {
    noautocmd = true, -- skip format-on-save; use <leader>cf or explicit :w
  },
}
