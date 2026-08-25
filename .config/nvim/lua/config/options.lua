-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

-- vim.opt.winbar = "%=%m %f"

vim.o.scrolloff = 0

vim.opt.textwidth = 100
-- vim.opt.laststatus = 3
vim.opt.spell = true

vim.g.opencode_opts = {
  provider = {
    enabled = "wezterm",
    wezterm = { }
  }
}
