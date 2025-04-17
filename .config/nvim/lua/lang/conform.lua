return {
  "stevearc/conform.nvim",
  opts = function(_, opts)
    require("conform").setup({
      float = {
        max_width = 100,
        max_height = 100,
      },
      formatters_by_ft = {
        lua = { "stylua" },
        -- Conform will run multiple formatters sequentially
        python = { "ruff", "ruff_fix" },
        -- You can customize some of the format options for the filetype (:help conform.format)
        rust = { "rustfmt", lsp_format = "fallback" },
        -- Conform will run the first available formatter
        javascript = { "prettierd", "prettier", stop_after_first = true },
      },
      format_on_save = {
        -- These options will be passed to conform.format()
        timeout_ms = 500,
        lsp_format = "fallback",
      },
    })
  end,
  init = function()
    vim.api.nvim_create_autocmd("WinLeave", {
      pattern = "*.py",
      callback = function()
        require("conform").format({ async = true, lsp_fallback = true })
      end,
    })
  end,
}
