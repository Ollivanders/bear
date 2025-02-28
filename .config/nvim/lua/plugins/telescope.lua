return {
  {
    "nvim-telescope/telescope.nvim",
    dependencies = {
      { "nvim-lua/plenary.nvim" },
      { "nvim-telescope/telescope-live-grep-args.nvim" },
    },
    config = function(_, opts)
      local telescope = require("telescope")
      telescope.setup(opts)
      telescope.load_extension("live_grep_args")
    end,
    opts = {
      defaults = {
        file_ignore_patterns = {
          ".git",
          "node_modules",
          "poetry.lock",
          ".DS_Store",
          " __pycache__",
          ".mypy_cache",
          ".pytest_cache",
          ".ruff_cache",
          ".ropeproject",
          ".venv",
        },
        vimgrep_arguments = {
          "rg",
          "--color=never",
          "--no-heading",
          "--hidden",
          "--with-filename",
          "--line-number",
          "--column",
          "--smart-case",
          "--trim",
        },
      },
    },
    keys = {
      { "<leader>/", vim.NIL },
      {
        "<leader>/",
        function()
          -- https://github.com/nvim-telescope/telescope-live-grep-args.nvim
          -- Uses ripgrep args (rg) for live_grep
          -- Command examples:
          -- -i "Data"  # case insensitive
          -- -g "!*.md" # ignore md files
          -- -w # whole word
          -- -e # regex
          -- see 'man rg' for more
          require("telescope").extensions.live_grep_args.live_grep_args() -- see arguments given in extensions config
        end,
        desc = "Live Grep (Args)",
      },
    },
  },
}
