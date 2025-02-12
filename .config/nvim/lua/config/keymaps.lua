-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
local map = vim.keymap.set

map("n", "<leader>sx", require("telescope.builtin").resume, { noremap = true, silent = true, desc = "resume" })
map("n", "<leader>fp", ":NeovimProjectDiscover", { desc = "Project Discover" })

-- Save key strokes (now we do not need to press shift to enter command mode).
-- map({ "n", "x" }, ";", ":")

-- Quit all opened buffers
map("n", "<leader>Q", "<cmd>qa!<cr>", { silent = true, desc = "quit nvim" })

-- insert a blank line below or above current line (do not move the cursor),
-- see https://stackoverflow.com/a/16136133/6064933
map("n", "<space>o", "printf('m`%so<esc>``', v:count1)", {
  expr = true,
  desc = "insert line below",
})

map("n", "<space>O", "printf('m`%sO<esc>``', v:count1)", {
  expr = true,
  desc = "insert line above",
})

map("n", "<leader>sv", function()
  vim.cmd([[
      update $MYVIMRC
      source $MYVIMRC
    ]])
  vim.notify("Nvim config successfully reloaded!", vim.log.levels.INFO, { title = "nvim-config" })
end, {
  silent = true,
  desc = "reload init.lua",
})

-- faster save and quit
map("n", "<leader>w", "<cmd>update<cr>", { silent = true, desc = "save buffer" })

map("n", "<leader>uH", require("snacks").dashboard.open, { desc = "Open mini starter" })

vim.keymap.set("t", "<Esc>", "<C-\\><C-n>")

-- floating terminal
-- map("n", "<leader>fT", function()
--   Snacks.terminal()
-- end, { desc = "Terminal (cwd)" })
-- map("n", "<leader>ft", function()
--   Snacks.terminal(nil, { cwd = LazyVim.root() })
-- end, { desc = "Terminal (Root Dir)" })
-- map("n", "<c-/>", function()
--   Snacks.terminal(nil, { cwd = LazyVim.root() })
-- end, { desc = "Terminal (Root Dir)" })
-- map("n", "<c-_>", function()
--   Snacks.terminal(nil, { cwd = LazyVim.root() })
-- end, { desc = "which_key_ignore" })

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

-- local wk = require("which-key")
-- wk.add({
--   l = {
--     name = "flash",
--     s = {
--       function()
--         require("flash").jump()
--       end,
--       "Flash Jump",
--     },
--     t = {
--       function()
--         require("flash").treesitter()
--       end,
--       "Flash Treesitter",
--     },
--     r = {
--       function()
--         require("flash").treesitter_search()
--       end,
--       "Flash Treesitter Search",
--     },
--   },
-- }, { prefix = "<leader>" })
