-- Drop LazyVim extra keymaps that collide with keymaps in config/keymaps.lua. lazy.nvim
-- (re)defines a plugin's keys when it loads, which would otherwise silently replace ours.
return {
  -- <leader>tl = Pick Terminal Tab
  { "nvim-neotest/neotest", keys = { { "<leader>tl", false } } },
  -- <leader>gr = Diffview file history
  { "pwntester/octo.nvim", keys = { { "<leader>gr", false } } },
}
