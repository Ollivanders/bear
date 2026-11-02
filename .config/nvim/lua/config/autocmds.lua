-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua

local function augroup(name)
  return vim.api.nvim_create_augroup("user_" .. name, { clear = true })
end

vim.api.nvim_create_user_command("WipeWindowlessBufs", function()
  for _, bufinfo in ipairs(vim.fn.getbufinfo({ buflisted = true })) do
    if bufinfo.changed == 0 and #bufinfo.windows == 0 then
      vim.api.nvim_buf_delete(bufinfo.bufnr, { force = false, unload = false })
    end
  end
end, { desc = "Wipeout all buffers not shown in a window" })

vim.api.nvim_create_autocmd("BufWritePost", {
  group = augroup("terraform_validate"),
  pattern = { "*.tf" },
  callback = function()
    if vim.fn.exists(":TerraformValidate") == 2 then
      vim.cmd("TerraformValidate")
    end
  end,
})

-- wezterm tab title: project name while nvim is open, revert to default on exit
-- this file runs on VeryLazy (after VimEnter), so set the title directly
vim.system({ "wezterm", "cli", "set-tab-title", "p: " .. vim.fs.basename(vim.fn.getcwd()) })
vim.api.nvim_create_autocmd("VimLeave", {
  group = augroup("wezterm_title_reset"),
  callback = function()
    vim.fn.system({ "wezterm", "cli", "set-tab-title", "" })
  end,
})
