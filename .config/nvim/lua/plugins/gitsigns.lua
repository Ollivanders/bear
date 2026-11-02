-- signs and hunk keymaps come from LazyVim; only add inline blame
return {
  "lewis6991/gitsigns.nvim",
  opts = {
    current_line_blame = true,
    current_line_blame_opts = {
      virt_text_pos = "eol",
      delay = 500,
    },
  },
}
