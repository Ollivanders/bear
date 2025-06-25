return {
  "okuuva/auto-save.nvim",
  cmd = "ASToggle",
  event = { "WinLeave", "InsertLeave", "TextChanged" },
  opts = {
  noautocmd = true,
}
}
