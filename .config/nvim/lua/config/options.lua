-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua

vim.g.root_spec = { "manual" }

vim.o.scrolloff = 0
vim.o.textwidth = 100
vim.o.colorcolumn = "100"
vim.o.clipboard = "unnamedplus"

-- terraform-ls/tflint write normal output to stderr, which nvim logs as ERROR, so the log grows
-- fast. Keep logging at WARN but rotate on startup: >50MB moves to lsp.log.old (replacing it).
vim.lsp.log.set_level("warn")
do
  local log = vim.lsp.log.get_filename()
  local stat = vim.uv.fs_stat(log)
  if stat and stat.size > 50 * 1024 * 1024 then
    vim.uv.fs_rename(log, log .. ".old")
  end
end
