-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

local map = vim.keymap.set

map("n", "<leader>sx", require("telescope.builtin").resume, { noremap = true, silent = true, desc = "resume" })

map("n", "<leader>gc", ":DiffviewOpen HEAD<CR>", { silent = true, desc = "Diffview Commit" })
map("n", "<leader>gm", ":DiffviewOpen origin/master<CR>", { silent = true, desc = "Diffview origin/master" })
map("n", "<leader>gM", ":DiffviewOpen origin/main<CR>", { silent = true, desc = "Diffview origin/" })
map("n", "<leader>gr", ":DiffviewFileHistory<CR>", { silent = true, desc = "Diff file history" })
map("n", "<leader>gf", ":DiffviewFileHistory %<CR>", { silent = true, desc = "Diff current file" })

-- Save key strokes (now we do not need to press shift to enter command mode).
-- map({ "n", "x" }, ";", ":")

-- Quit all opened buffers
map("n", "<leader>Q", "<cmd>qa!<cr>", { silent = true, desc = "quit nvim" })

-- insert a blank line below or above current line (do not move the cursor),
-- see https://stackoverflow.com/a/16136133/6064933
map("n", "go", "printf('m`%so<esc>``', v:count1)", {
  expr = true,
  desc = "insert line below",
})

map("n", "gO", "printf('m`%sO<esc>``', v:count1)", {
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

map("n", "<leader>uH", require("snacks").dashboard.open, { desc = "Open mini starter" })

-- map("n", "<C-\\>", function()
--   require("snacks").terminal.toggle(nil, { win = { position = "bottom" } })
-- end, { desc = "Bottom Terminal" })

map("n", "<C-/>", function()
  require("snacks").terminal.toggle(nil, {
    count = 1,
    win = { position = "right" },
  })
end, { desc = "Terminal (Right)" })

-- Bottom terminal (#2)
map("n", "<C-_>", function()
  require("snacks").terminal.toggle(nil, {
    count = 2,
    win = { position = "bottom" },
  })
end, { desc = "Terminal (Bottom)" })

-- vim.keymap.set("n", "<leader>ts", function()
--   require("snacks").terminal.open(nil, {
--     count = vim.v.count1,            -- allow 1,2,... to make new ones
--     win = { position = "right" },    -- vertical split
--   })
-- end, { desc = "New vertical terminal" })
--
-- vim.keymap.set("n", "<leader>tS", function()
--   require("snacks").terminal.open(nil, {
--     count = vim.v.count1,
--     win = { position = "bottom" },   -- horizontal split
--   })
-- end, { desc = "New horizontal terminal" })

-- <Esc><Esc> in terminal mode sends <C-\><C-n> to exit terminal mode, see :h term
map("t", "<Esc><Esc>", "<C-\\><C-n>", { noremap = true })

map("n", "gS", function()
  -- Check how many windows are open
  local wins = vim.api.nvim_tabpage_list_wins(0)
  local current_cursor_pos = vim.api.nvim_win_get_cursor(0)

  local current_buf = vim.api.nvim_get_current_buf()
  local current_win = vim.api.nvim_get_current_win()

  local target_win

  -- If there are already splits, then take the next one and set buffer to current buffer
  if #wins >= 2 then
    for _, win_num in pairs(wins) do
      if win_num ~= current_win then
        target_win = win_num
      end
    end
  else
    vim.cmd("vsplit")
    vim.cmd("wincmd p")
  end

  -- Set buffer for new window
  vim.api.nvim_win_set_buf(target_win, current_buf)

  -- Copy cursor position to new window for lsp defintion
  vim.api.nvim_win_set_cursor(target_win, vim.api.nvim_win_get_cursor(0))

  -- Focus new window
  vim.api.nvim_set_current_win(target_win)
  vim.cmd("normal! zz")

  -- Call lsp
  vim.lsp.buf.definition()
end, { desc = "Go to Definition in sep. win" })

map("n", "<c-p>", "<Plug>(YankyPreviousEntry)")
map("n", "<c-n>", "<Plug>(YankyNextEntry)")
map("n", "<leader>bw", ":WipeWindowlessBufs<CR>", { silent = true, desc = "Wipe window less buffers" })

map("n", "<leader>yf", function()
  vim.fn.setreg("+", vim.fn.expand("%:t"))
end, { desc = "Copy filename" })

map("n", "<leader>yp", function()
  vim.fn.setreg("+", vim.fn.expand("%:p"))
end, { desc = "Copy file path" })

vim.keymap.set("n", "<leader>yl", function()
  vim.fn.setreg("+", vim.fn.expand("%:p") .. ":" .. vim.fn.line("."))
end, { desc = "Copy file path and line number" })

map("n", "<leader>yr", function()
  vim.fn.setreg("+", vim.fn.expand("%:."))
end, { desc = "Copy Relative file path" })

map("n", "<leader>yd", function()
  vim.fn.setreg("+", vim.fn.fnamemodify(vim.api.nvim_buf_get_name(0), ":p:h"))
end, { desc = "Copy directory of current buffer (absolute path)" })
vim.keymap.set("v", "<leader>YY", function()
  local start_line = vim.fn.line("v")
  local end_line = vim.fn.line(".")
  if start_line > end_line then
    start_line, end_line = end_line, start_line
  end

  local filename = vim.fn.expand("%:t")
  local ref

  if start_line == end_line then
    ref = string.format("%s#%d", filename, start_line)
  else
    ref = string.format("%s#%d-%d", filename, start_line, end_line)
  end

  vim.fn.setreg("+", ref)
  print("Copied: " .. ref)
end, { desc = "Copy file#lines reference" })

map("n", "<leader>yD", function()
  local buf_dir = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(0), ":p:h")
  local cwd = vim.fn.getcwd()
  local rel_path = vim.fn.fnamemodify(buf_dir, ":." .. cwd)
  vim.fn.setreg("+", rel_path)
end, { desc = "Copy directory of current buffer (relative path)" })

map("n", "<leader>lr", ":LspRestart<CR>", { silent = true })

map("n", "<leader>j", function()
  require("mini.files").open(vim.uv.cwd(), true)
end, { desc = "Open mini.files (cwd)" })
map("n", "<leader>j", function()
  require("mini.files").open(vim.uv.cwd(), true)
end, { desc = "Open mini.files (cwd)" })

map("n", "<leader>k", function()
  require("mini.files").open(vim.api.nvim_buf_get_name(0), true)
end, { desc = "Open mini.files (Directory of Current File)" })

-- smart-splits
map("n", "<A-h>", require("smart-splits").resize_left)
map("n", "<A-j>", require("smart-splits").resize_down)
map("n", "<A-k>", require("smart-splits").resize_up)
map("n", "<A-l>", require("smart-splits").resize_right)

-- moving between splits
-- map("n", "<C-h>", require("smart-splits").move_cursor_left)
-- map("n", "<C-j>", require("smart-splits").move_cursor_down)
-- map("n", "<C-k>", require("smart-splits").move_cursor_up)
-- map("n", "<C-l>", require("smart-splits").move_cursor_right)
-- map("n", "<C-\\>", require("smart-splits").move_cursor_previous)

-- swapping buffers between windows
map("n", "<leader>ph", require("smart-splits").swap_buf_left)
map("n", "<leader>pj", require("smart-splits").swap_buf_down)
map("n", "<leader>pk", require("smart-splits").swap_buf_up)
map("n", "<leader>pl", require("smart-splits").swap_buf_right)

map("n", "<leader>tb", function()
  -- 0 = never show tabline (hides bufferline)
  -- 2 = always show tabline (shows bufferline)
  vim.o.showtabline = (vim.o.showtabline == 0) and 2 or 0
end, { desc = "Toggle bufferline (tabline)" })

map("n", "<leader>bA", "<cmd>bufdo edit<CR>", {
  desc = "Reload all buffers",
})

map({ "n", "x" }, "<C-P>", '"0P', { noremap = true, silent = true })

-- map("n", "<leader>gws", function() Snacks.picker.worktrees() end, { desc = "Switch" })
map("n", "<leader>gwn", function()
  local telescope = require("telescope")
  telescope.load_extension("git_worktree")
  telescope.extensions.git_worktree.create_git_worktree()
end, { desc = "New" })
map("n", "<leader>gwr", function()
  local git_worktree = require("git-worktree")
  local worktrees = {}
  local current_path

  for _, line in ipairs(vim.fn.systemlist("git worktree list --porcelain")) do
    if vim.startswith(line, "worktree ") then
      current_path = line:sub(#"worktree " + 1)
    elseif vim.startswith(line, "branch ") and current_path then
      worktrees[#worktrees + 1] = {
        path = current_path,
        branch = line:gsub("^branch refs/heads/", ""),
      }
      current_path = nil
    elseif line == "" and current_path then
      worktrees[#worktrees + 1] = {
        path = current_path,
        branch = "(detached)",
      }
      current_path = nil
    end
  end

  vim.ui.select(worktrees, {
    prompt = "Remove worktree",
    format_item = function(item)
      return string.format("%s -> %s", item.branch, item.path)
    end,
  }, function(choice)
    if not choice then
      return
    end

    git_worktree.delete_worktree(choice.path, false)
  end)
end, { desc = "Remove" })

map("n", "<leader>gws", function()
  local telescope = require("telescope")
  telescope.load_extension("git_worktree")
  telescope.extensions.git_worktree.git_worktree()
  -- telescope.extensions.git_worktree.git_worktree({ path_display = {} })
end, { desc = "Manage Worktrees" })
