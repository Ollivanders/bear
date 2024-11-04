-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
local map = vim.keymap.set

map("n", "<leader>sx", require("telescope.builtin").resume, { noremap = true, silent = true, desc = "resume" })

map("n", "<leader>fp", ":NeovimProjectDiscover", { desc = "Project Discover" })
