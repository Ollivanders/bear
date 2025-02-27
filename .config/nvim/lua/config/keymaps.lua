-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

local map = vim.keymap.set

map("n", "<leader>sx", require("telescope.builtin").resume, { noremap = true, silent = true, desc = "resume" })
map("n", "<leader>fp", ":NeovimProjectDiscover", { desc = "Project Discover" })

-- Save key strokes (now we do not need to press shift to enter command mode).
map({ "n", "x" }, ";", ":")

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

vim.keymap.del("n", "<leader>/")
map("n", "<leader>/", function()
  -- https://github.com/nvim-telescope/telescope-live-grep-args.nvim
  -- Uses ripgrep args (rg) for live_grep
  -- Command examples:
  -- -i "Data"  # case insensitive
  -- -g "!*.md" # ignore md files
  -- -w # whole word
  -- -e # regex
  -- see 'man rg' for more
  require("telescope").extensions.live_grep_args.live_grep_args() -- see arguments given in extensions config
end, { desc = "Live Grep (Args)" })

-- faster save and quit
map("n", "<leader>w", "<cmd>update<cr>", { silent = true, desc = "save buffer" })

map("n", "<leader>uH", require("snacks").dashboard.open, { desc = "Open mini starter" })

map("t", "<Esc>", "<C-\\><C-n>")

map("n", "<C-/>", function()
  require("snacks").terminal.toggle(nil, { win = { position = "right" } })
end, { desc = "Vertical Terminal" })

map("n", "<C-_>", function()
  require("snacks").terminal.toggle(nil, { win = { position = "right" } })
end, { desc = "Vertical Terminal" })

-- <Esc><Esc> in terminal mode sends <C-\><C-n> to exit terminal mode, see :h term
map("t", "<Esc><Esc>", "<C-\\><C-n>", { noremap = true })

function open_split_buffer_goto_definition()
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
    target_win = current_win
  end

  -- Set buffer for new window
  vim.api.nvim_win_set_buf(target_win, current_buf)

  -- Copy cursor position to new window for lsp defintion
  vim.api.nvim_win_set_cursor(target_win, current_cursor_pos)

  -- Focus new window
  vim.api.nvim_set_current_win(target_win)
  vim.cmd("normal! zz")

  -- Call lsp
  vim.lsp.buf.definition()
end
map("n", "gS", open_split_buffer_goto_definition, { desc = "Go to Definition in sep. win" })
