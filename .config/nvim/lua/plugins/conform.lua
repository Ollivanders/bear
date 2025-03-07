return {
  "stevearc/conform.nvim",
  opts = {
    formatters_by_ft = {
      python = { "ruff_fix" },
    },
  },
  init = function()
    vim.api.nvim_create_autocmd("WinLeave", {
      pattern = "*.py",
      callback = function()
        require("conform").format({ async = true, lsp_fallback = true })
      end,
    })
  end,
}
