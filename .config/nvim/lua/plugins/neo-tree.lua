return {
  "nvim-neo-tree/neo-tree.nvim",
  opts = {
    open_files_do_not_replace_types = { "terminal", "Trouble", "qf", "edgy" },
    filesystem = {
      filtered_items = {
        visible = true,
        show_hidden_count = true,
        hide_dotfiles = false,
        hide_gitignored = true,
        never_show = {
          ".git",
          ".DS_Store",
          "__pycache__",
          ".mypy_cache",
          ".pytest_cache",
          ".ruff_cache",
          ".ropeproject",
          ".venv",
        },
      },
    },
  },
  dependencies = "nvim-tree/nvim-web-devicons",
}
