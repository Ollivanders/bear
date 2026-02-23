return {
  "skanehira/github-actions.nvim",
  dependencies = {
    "nvim-treesitter/nvim-treesitter",
    "nvim-telescope/telescope.nvim",
  },
  config = function()
    local actions = require("github-actions")
    actions.setup({})

    vim.keymap.set("n", "<leader>gah", actions.show_history, { desc = "GitHub Actions: history" })
    vim.keymap.set("n", "<leader>gap", function() actions.show_history({ pr_mode = true }) end,
      { desc = "GitHub Actions: history by branch/PR" })
    vim.keymap.set("n", "<leader>gaw", actions.watch_workflow, { desc = "GitHub Actions: watch running" })
    vim.keymap.set("n", "<leader>gad", actions.dispatch_workflow, { desc = "GitHub Actions: dispatch" })
  end,
}
