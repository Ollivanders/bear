return {
  "stevearc/conform.nvim",
  opts = function(_, opts)
    opts.float = {
      max_width = 100,
      max_height = 100,
    }
    opts.formatters_by_ft = vim.tbl_deep_extend("force", opts.formatters_by_ft or {}, {
      lua = { "stylua" },
      -- Conform will run multiple formatters sequentially
      python = { "ruff", "ruff_fix" },
      -- You can customize some of the format options for the filetype (:help conform.format)
      rust = { "rustfmt", lsp_format = "fallback" },
      -- Conform will run the first available formatter
      -- javascript = { "prettierd", "prettier", stop_after_first = true },
      terraform = { "terraform_fmt" },
      ["terraform-vars"] = { "terraform_fmt" },
    })
    return opts
  end,
}
