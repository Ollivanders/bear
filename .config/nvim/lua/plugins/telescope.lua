return {
  "nvim-telescope/telescope.nvim",
  dependencies = {
    { "nvim-lua/plenary.nvim" },
    { "nvim-telescope/telescope-live-grep-args.nvim" },
  },
  config = function(_, opts)
    local telescope = require("telescope")
    local lga_actions = require("telescope-live-grep-args.actions")
    opts.extensions = {
      live_grep_args = {
        auto_quoting = true, -- enable/disable auto-quoting
        -- define mappings, e.g.
        mappings = { -- extend mappings
          i = {
            ["<C-j>"] = require("telescope.actions").cycle_history_next,
            ["<C-k>"] = require("telescope.actions").cycle_history_prev,

            ["<C-q>"] = lga_actions.quote_prompt(),
            ["<C-l>"] = lga_actions.quote_prompt({ postfix = ' -g "*libs*"' }),
            ["<C-t>"] = lga_actions.quote_prompt({ postfix = ' -g "!*test*"' }),
            ["<C-i>"] = lga_actions.quote_prompt({ postfix = " --iglob " }),
            -- freeze the current list and start a fuzzy search in the frozen list
            ["<C-f>"] = lga_actions.to_fuzzy_refine,
          },
        },
        -- ... also accepts theme settings, for example:
        -- theme = "dropdown", -- use dropdown theme
        -- theme = { }, -- use own theme spec
        -- layout_config = { mirror=true }, -- mirror preview pane
      },
    }

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
}
