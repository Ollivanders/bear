-- default mappings: gpd gpt gpi gpD gpr, gP closes all
return {
  "rmagatti/goto-preview",
  dependencies = { "rmagatti/logger.nvim" },
  event = "LspAttach",
  opts = {
    width = 120,
    height = 15,
    border = { "↖", "─", "┐", "│", "┘", "─", "└", "│" },
    default_mappings = true,
    opacity = 10,
    references = { provider = "snacks" },
    focus_on_open = true,
    dismiss_on_move = false,
    force_close = true,
    bufhidden = "wipe",
    stack_floating_preview_windows = true,
    same_file_float_preview = true,
    preview_window_title = { enable = true, position = "left" },
    zindex = 1,
    vim_ui_input = false, -- leave vim.ui.input to Snacks.input
  },
}
