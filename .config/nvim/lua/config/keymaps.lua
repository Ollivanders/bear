-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
local map = vim.keymap.set

map("n", "<leader>sx", require("telescope.builtin").resume, { noremap = true, silent = true, desc = "resume" })

map("n", "<leader>fp", ":NeovimProjectDiscover", { desc = "Project Discover" })

-- local function diffOpenWithInput()
--   local user_input = vim.fn.input("Revision to Open: ")
--   vim.cmd("DiffviewOpen " .. user_input)
-- end
--
-- local function diffOpenFileHistory()
--   local user_input = vim.fn.input("Files to Open: ")
--   vim.cmd("DiffviewFileHistory" .. user_input)
-- end
--
-- -- Key maps
-- require("which-key").add({
--   { "<leader>g", group = "Git" },
--   { "<leader>gf", diffOpenFileHistory, desc = "Open DiffView on Files" },
--   { "<leader>go", diffOpenWithInput, desc = "Open DiffView" },
-- })
-- diffOpenFileHistory with . opens commit wise history of entire codebase.
-- diffOpenFileHistory with % opens commit wise history of current file.
-- diffOpenFileHistory with <any file path> opens commit wise history of that file.
-- diffOpenWithInput with HEAD opens diff of latest commit.
-- diffOpenWithInput with HEAD~3 opens diff of last 3 commits.
-- diffOpenWithInput with master..HEAD opens changes of your feature branch.
