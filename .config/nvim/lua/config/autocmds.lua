-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
-- Add any additional autocmds here

-- autocmd("FocusLost", { pattern = "*", command = "silent! wa" })

vim.api.nvim_create_augroup("bufcheck", { clear = true })

vim.api.nvim_create_autocmd("FocusLost", {
  pattern = "*",
  command = "silent! wa",
})

vim.api.nvim_create_autocmd("FileType", {
  group = vim.api.nvim_create_augroup("grug-far-keybindings", { clear = true }),
  pattern = { "grug-far" },
  callback = function()
    vim.keymap.set("n", "<C-enter>", function()
      require("grug-far").get_instance(0):open_location()
      require("grug-far").get_instance(0):close()
    end, { buffer = true })
  end,
})

vim.api.nvim_create_user_command("WipeWindowlessBufs", function()
  local bufinfos = vim.fn.getbufinfo({ buflisted = true })
  vim.tbl_map(function(bufinfo)
    if bufinfo.changed == 0 and (not bufinfo.windows or #bufinfo.windows == 0) then
      -- print(("Deleting buffer %d : %s"):format(bufinfo.bufnr, bufinfo.name))
      vim.api.nvim_buf_delete(bufinfo.bufnr, { force = false, unload = false })
    end
  end, bufinfos)
end, { desc = "Wipeout all buffers not shown in a window" })

vim.api.nvim_create_autocmd("BufWritePost", {
  pattern = { "*.tf" },
  callback = function()
    vim.cmd("TerraformValidate")
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  group = vim.api.nvim_create_augroup("my-grug-far-custom-keybinds", { clear = true }),
  pattern = { "grug-far" },
  callback = function()
    vim.keymap.set("n", "<c-f>", function()
      local state = unpack(require("grug-far").get_instance(0):toggle_flags({ "-F" }))
      vim.notify("grug-far: toggled -F" .. (state and "ON" or "OFF"))
    end, { buffer = true })

    vim.keymap.set("n", "<c-a>", function()
      local state = unpack(require("grug-far").get_instance(0):toggle_flags({ "--hidden" }))
      vim.notify("grug-far: toggled --hidden" .. (state and "ON" or "OFF"))
    end, { buffer = true })
  end,
})

vim.api.nvim_create_autocmd("WinLeave", {
  pattern = "*.py",
  callback = function()
    require("conform").format({ async = true, lsp_fallback = true })
  end,
})


vim.api.nvim_create_autocmd("WinEnter", {
  once = true, -- ensures it only runs once
  callback = function()
    local project = "p: " .. vim.fs.basename(vim.fn.getcwd())
    vim.fn.system({ "wezterm", "cli", "set-tab-title", project })
  end,
})

vim.api.nvim_create_autocmd({ "VimLeave" }, {
  callback = function()
    -- Setting title to empty string causes wezterm to revert to its
    -- default behavior of setting the tab title automatically
    vim.fn.system({ "wezterm", "cli", "set-tab-title", "" })
  end,
})
vim.api.nvim_create_autocmd("User", {
  pattern = "MiniFilesBufferCreate",
  callback = function(args)
    local buf_id = args.data.buf_id
    local open_in_window_picker = function()
      local mini_files = require("mini.files")
      local fs_entry = mini_files.get_fs_entry()
      if fs_entry ~= nil and fs_entry.fs_type == "file" then
        local picked_window_id = require("window-picker").pick_window()
        if not picked_window_id then return end
        mini_files.set_target_window(picked_window_id)
      end
      mini_files.go_in({
        close_on_file = true,
      })
    end
    vim.keymap.set("n", "l", open_in_window_picker, { buffer = buf_id, desc = "Open in target window" })
  end,
})
