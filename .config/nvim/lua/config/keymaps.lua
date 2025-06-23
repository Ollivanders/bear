-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

local map = vim.keymap.set

map("n", "<leader>sx", require("telescope.builtin").resume, { noremap = true, silent = true, desc = "resume" })

map("n", "<leader>gm", ":DiffviewOpen origin/master", { silent = true, desc = "Diffview origin/master" })
map("n", "<leader>gr", ":DiffviewFileHistory", { silent = true, desc = "Diff file history" })

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

-- TODO:
-- .gitignore  alt-i
-- hidden files alt-h
map("n", "<leader>s/", function()
  -- https://github.com/nvim-telescope/telescope-live-grep-args.nvim
  -- Uses ripgrep args (rg) for live_grep
  -- Command examples:
  -- -i "Data"  # case insensitive
  -- -g "!*.md" # ignore md files
  -- -w # whole word
  -- -e # regex
  -- see 'man rg' for more
  require("telescope").extensions.live_grep_args.live_grep_args() -- see arguments given in extensions config
end, { desc = "Live Grep" })

vim.keymap.set(
  "n",
  "<leader>gw",
  require("telescope-live-grep-args.shortcuts").grep_word_under_cursor,
  { desc = "Live grep word under cursor" }
)
vim.keymap.set(
  "v",
  "<leader>gv",
  require("telescope-live-grep-args.shortcuts").grep_visual_selection,
  { desc = "Live grep visual selection" }
)

map("n", "<leader>uH", require("snacks").dashboard.open, { desc = "Open mini starter" })

-- map("n", "<C-\\>", function()
--   require("snacks").terminal.toggle(nil, { win = { position = "bottom" } })
-- end, { desc = "Bottom Terminal" })

map("n", "<C-/>", function()
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
end

map("n", "gS", open_split_buffer_goto_definition, { desc = "Go to Definition in sep. win" })

map("n", "<c-p>", "<Plug>(YankyPreviousEntry)")
map("n", "<c-n>", "<Plug>(YankyNextEntry)")
map("n", "<leader>bw", ":WipeWindowlessBufs<CR>", { silent = true, desc = "Wipe window less buffers" })

map("n", "<leader>yp", function()
  vim.fn.setreg("+", vim.fn.expand("%:p"))
end, { desc = "Copy file path" })

map("n", "<leader>yr", function()
  vim.fn.setreg("+", vim.fn.expand("%:."))
end, { desc = "Copy Relative file path" })

map("n", "<leader>yd", function()
  vim.fn.setreg("+", vim.fn.fnamemodify(vim.api.nvim_buf_get_name(0), ":p:h"))
end, { desc = "Copy directory of current buffer (absolute path)" })

map("n", "<leader>rl", ":LspRestart")

local grug_far_open_cfg = {
  prefills = {
    flags = "-F --hidden",
  },
  instanceName = "Toggle",
  staticTitle = "Toggle",
}

function close_toggle_instance()
  local inst = require("grug-far.instances").get_instance("Toggle" or 0)
  if inst then
    inst:close()
  end
end

map("n", "<leader>rf", function()
  close_toggle_instance()
  require("grug-far").toggle_instance(vim.tbl_deep_extend("force", grug_far_open_cfg, {
    prefills = {
      paths = vim.fn.expand("%"),
    },
  }))
end, { desc = "Search Replace Current file" })

map("n", "<leader>rw", function()
  close_toggle_instance()
  require("grug-far").toggle_instance(vim.tbl_deep_extend("force", grug_far_open_cfg, {
    prefills = { search = vim.fn.expand("<cword>") },
  }))
end, { desc = "Search Replace Current word" })

map({ "n", "x" }, "<leader>rp", function()
  close_toggle_instance()
  local search = vim.fn.getreg("*")
  -- surround with \b if "word" search (such as when pressing `*`)
  if search and vim.startswith(search, "\\<") and vim.endswith(search, "\\>") then
    search = "\\b" .. search:sub(3, -3) .. "\\b"
  end

  require("grug-far").toggle_instance(vim.tbl_deep_extend("force", grug_far_open_cfg, {
    prefills = { search = search },
  }))
end, { desc = "Search using @/ register value or visual selection" })

map({ "n", "x" }, "<leader>rv", function()
  close_toggle_instance()
  require("grug-far").with_visual_selection(grug_far_open_cfg)
end, { desc = "Search Replace within range " })

map({ "n", "x" }, "<leader>rd", function()
  close_toggle_instance()
  local dir_name = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(0), ":p:h:t")
  local search = "source .*=.*" .. dir_name .. '"'
  require("grug-far").toggle_instance(vim.tbl_deep_extend("force", grug_far_open_cfg, {
    prefills = {
      flags = "",
      search = search,
    },
  }))
end, { desc = "Search Replace Terraform Module" })

require("goto-preview").setup({
  width = 120, -- Width of the floating window
  height = 15, -- Height of the floating window
  border = { "↖", "─", "┐", "│", "┘", "─", "└", "│" }, -- Border characters of the floating window
  default_mappings = true, -- Bind default mappings
  debug = false, -- Print debug information
  opacity = 10, -- 0-100 opacity level of the floating window where 100 is fully transparent.
  resizing_mappings = false, -- Binds arrow keys to resizing the floating window.
  post_open_hook = nil, -- A function taking two arguments, a buffer and a window to be ran as a hook.
  post_close_hook = nil, -- A function taking two arguments, a buffer and a window to be ran as a hook.
  references = { -- Configure the telescope UI for slowing the references cycling window.
    provider = "telescope", -- telescope|fzf_lua|snacks|mini_pick|default
    telescope = require("telescope.themes").get_dropdown({ hide_preview = false }),
  },
  -- These two configs can also be passed down to the goto-preview definition and implementation calls for one off "peak" functionality.
  focus_on_open = true,                                        -- Focus the floating window when opening it.
  dismiss_on_move = false,                                     -- Dismiss the floating window when moving the cursor.
  force_close = true,                                          -- passed into vim.api.nvim_win_close's second argument. See :h nvim_win_close
  bufhidden = "wipe",                                          -- the bufhidden option to set on the floating window. See :h bufhidden
  stack_floating_preview_windows = true,                       -- Whether to nest floating windows
  same_file_float_preview = true,                              -- Whether to open a new floating window for a reference within the current file
  preview_window_title = { enable = true, position = "left" }, -- Whether to set the preview window title as the filename
  zindex = 1,                                                  -- Starting zindex for the stack of floating windows
  vim_ui_input = true,                                         -- Whether to override vim.ui.input with a goto-preview floating window
})

map("n", "<leader>th", ":Telescope harpoon marks", { desc = "Harpoon telescope" })

-- smart-splits
map("n", "<A-h>", require("smart-splits").resize_left)
map("n", "<A-j>", require("smart-splits").resize_down)
map("n", "<A-k>", require("smart-splits").resize_up)
map("n", "<A-l>", require("smart-splits").resize_right)
-- moving between splits
map("n", "<C-h>", require("smart-splits").move_cursor_left)
map("n", "<C-j>", require("smart-splits").move_cursor_down)
map("n", "<C-k>", require("smart-splits").move_cursor_up)
map("n", "<C-l>", require("smart-splits").move_cursor_right)
map("n", "<C-\\>", require("smart-splits").move_cursor_previous)
-- swapping buffers between windows
map("n", "<leader><leader>h", require("smart-splits").swap_buf_left)
map("n", "<leader><leader>j", require("smart-splits").swap_buf_down)
map("n", "<leader><leader>k", require("smart-splits").swap_buf_up)
map("n", "<leader><leader>l", require("smart-splits").swap_buf_right)

map("n", "<leader>tp", ":TerraformPlan", { silent = true, desc = "Terraform Plan" })
map("n", "<leader>te", ":TerraformExplore", { silent = true, desc = "Terraform Explore" })
map("n", "<leader>tv", ":TerraformValidate", { silent = true, desc = "Terraform Validate" })
map("n", "<leader>ti", ":TerraformInit", { silent = true, desc = "Terraform init" })
