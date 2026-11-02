-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua

local map = vim.keymap.set

map("n", "<leader>sx", function()
  Snacks.picker.resume()
end, { desc = "Resume Picker" })

-- diffview
map("n", "<leader>gc", "<cmd>DiffviewOpen HEAD<cr>", { desc = "Diffview Commit" })
map("n", "<leader>gm", "<cmd>DiffviewOpen origin/master<cr>", { desc = "Diffview origin/master" })
map("n", "<leader>gM", "<cmd>DiffviewOpen origin/main<cr>", { desc = "Diffview origin/main" })
map("n", "<leader>gr", "<cmd>DiffviewFileHistory<cr>", { desc = "Diff file history" })
map("n", "<leader>gf", "<cmd>DiffviewFileHistory %<cr>", { desc = "Diff current file" })

map("n", "<leader>Q", "<cmd>qa!<cr>", { desc = "Quit nvim" })
map("n", "<leader>R", "<cmd>restart<cr>", { desc = "Restart nvim" })

-- insert a blank line below or above current line (do not move the cursor)
map("n", "go", "printf('m`%so<esc>``', v:count1)", { expr = true, desc = "Insert line below" })
map("n", "gO", "printf('m`%sO<esc>``', v:count1)", { expr = true, desc = "Insert line above" })

map("n", "<leader>uH", function()
  Snacks.dashboard.open()
end, { desc = "Open dashboard" })

-- terminals
map("n", "<C-_>", function()
  Snacks.terminal.toggle(nil, { count = 99, win = { position = "bottom" } })
end, { desc = "Terminal (Bottom)" })

local term_tabs = require("user.terminal_tabs")
term_tabs.setup("right", { position = "right" })

map({ "n", "t" }, "<C-/>", function()
  term_tabs.toggle("right")
end, { desc = "Terminal Tabs (Right)" })
map("n", "]t", term_tabs.next, { desc = "Next Terminal Tab" })
map("n", "[t", term_tabs.prev, { desc = "Prev Terminal Tab" })
-- sent by WezTerm on Ctrl+Shift+] / Ctrl+Shift+[ (see wezterm.lua); Option+key composes on macOS
map({ "n", "t" }, "<M-.>", term_tabs.next, { desc = "Next Terminal Tab" })
map({ "n", "t" }, "<M-,>", term_tabs.prev, { desc = "Prev Terminal Tab" })
map("n", "<leader>tn", term_tabs.new, { desc = "New Terminal Tab" })
map("n", "<leader>tx", term_tabs.close, { desc = "Close Terminal Tab" })
map("n", "<leader>tl", term_tabs.pick, { desc = "Pick Terminal Tab" })

map("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })

map("n", "gS", function()
  local cur_win = vim.api.nvim_get_current_win()
  local target_win
  for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
    if win ~= cur_win and vim.api.nvim_win_get_config(win).relative == "" then
      target_win = win
    end
  end
  if not target_win then
    vim.cmd("vsplit")
    target_win = vim.api.nvim_get_current_win()
  end
  vim.api.nvim_win_set_buf(target_win, vim.api.nvim_win_get_buf(cur_win))
  vim.api.nvim_win_set_cursor(target_win, vim.api.nvim_win_get_cursor(cur_win))
  vim.api.nvim_set_current_win(target_win)
  vim.cmd("normal! zz")
  vim.lsp.buf.definition()
end, { desc = "Go to Definition in sep. win" })

-- buffers
map("n", "<leader>bw", "<cmd>WipeWindowlessBufs<cr>", { desc = "Wipe windowless buffers" })
map("n", "<leader>bA", "<cmd>bufdo edit<cr>", { desc = "Reload all buffers" })
map("n", "<leader>bt", function()
  vim.o.showtabline = (vim.o.showtabline == 0) and 2 or 0
end, { desc = "Toggle bufferline (tabline)" })

-- paste last yank (not last delete); yanky ring cycling is on [y / ]y
map({ "n", "x" }, "<C-p>", '"0P', { desc = "Paste last yank" })

-- copy paths
local function copy(value)
  vim.fn.setreg("+", value)
  vim.notify("Copied: " .. value)
end
map("n", "<leader>yf", function()
  copy(vim.fn.expand("%:t"))
end, { desc = "Copy filename" })
map("n", "<leader>yp", function()
  copy(vim.fn.expand("%:p"))
end, { desc = "Copy file path" })
map("n", "<leader>yr", function()
  copy(vim.fn.expand("%:."))
end, { desc = "Copy relative file path" })
map("n", "<leader>yl", function()
  copy(vim.fn.expand("%:p") .. ":" .. vim.fn.line("."))
end, { desc = "Copy file path and line number" })
map("n", "<leader>yd", function()
  copy(vim.fn.expand("%:p:h"))
end, { desc = "Copy directory (absolute)" })
map("n", "<leader>yD", function()
  copy(vim.fn.expand("%:.:h"))
end, { desc = "Copy directory (relative)" })
map("v", "<leader>YY", function()
  local s, e = vim.fn.line("v"), vim.fn.line(".")
  if s > e then
    s, e = e, s
  end
  local filename = vim.fn.expand("%:t")
  copy(s == e and ("%s#%d"):format(filename, s) or ("%s#%d-%d"):format(filename, s, e))
end, { desc = "Copy file#lines reference" })

map("n", "<leader>lr", "<cmd>lsp restart<cr>", { desc = "Restart LSP" })

-- mini.files
map("n", "<leader>j", function()
  require("mini.files").open(vim.uv.cwd(), true)
end, { desc = "mini.files (cwd)" })
map("n", "<leader>k", function()
  require("mini.files").open(vim.api.nvim_buf_get_name(0), true)
end, { desc = "mini.files (current file dir)" })

-- smart-splits: resize + move + swap (crosses into WezTerm/Ghostty panes at edges)
map("n", "<A-h>", function()
  require("smart-splits").resize_left()
end, { desc = "Resize left" })
map("n", "<A-j>", function()
  require("smart-splits").resize_down()
end, { desc = "Resize down" })
map("n", "<A-k>", function()
  require("smart-splits").resize_up()
end, { desc = "Resize up" })
map("n", "<A-l>", function()
  require("smart-splits").resize_right()
end, { desc = "Resize right" })
map("n", "<C-h>", function()
  require("smart-splits").move_cursor_left()
end, { desc = "Move left" })
map("n", "<C-j>", function()
  require("smart-splits").move_cursor_down()
end, { desc = "Move down" })
map("n", "<C-k>", function()
  require("smart-splits").move_cursor_up()
end, { desc = "Move up" })
map("n", "<C-l>", function()
  require("smart-splits").move_cursor_right()
end, { desc = "Move right" })
map("n", "<leader>ph", function()
  require("smart-splits").swap_buf_left()
end, { desc = "Swap buf left" })
map("n", "<leader>pj", function()
  require("smart-splits").swap_buf_down()
end, { desc = "Swap buf down" })
map("n", "<leader>pk", function()
  require("smart-splits").swap_buf_up()
end, { desc = "Swap buf up" })
map("n", "<leader>pl", function()
  require("smart-splits").swap_buf_right()
end, { desc = "Swap buf right" })
