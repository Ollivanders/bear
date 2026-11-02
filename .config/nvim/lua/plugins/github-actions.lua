return {
  "skanehira/github-actions.nvim",
  dependencies = { "nvim-treesitter/nvim-treesitter" },
  opts = {},
  keys = {
    {
      "<leader>gah",
      function()
        require("github-actions").show_history()
      end,
      desc = "GitHub Actions: history",
    },
    {
      "<leader>gap",
      function()
        require("github-actions").show_history({ pr_mode = true })
      end,
      desc = "GitHub Actions: history by branch/PR",
    },
    {
      "<leader>gaw",
      function()
        require("github-actions").watch_workflow()
      end,
      desc = "GitHub Actions: watch running",
    },
    {
      "<leader>gad",
      function()
        require("github-actions").dispatch_workflow()
      end,
      desc = "GitHub Actions: dispatch",
    },
  },
}
