-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
-- Add any additional autocmds here

-- autocmd("FocusLost", { pattern = "*", command = "silent! wa" })

vim.api.nvim_create_augroup("bufcheck", { clear = true })

vim.api.nvim_create_autocmd("FocusLost", {
  pattern = "*",
  command = "silent! wa",
})

-- reload config file on change
vim.api.nvim_create_autocmd("BufWritePost", {
  group = "bufcheck",
  pattern = vim.env.MYVIMRC,
  command = "silent source %",
})
vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
  pattern = "*.ocl",
  callback = function()
    vim.bo.filetype = "opencl"
  end,
})
