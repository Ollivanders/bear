return {
  "stevearc/conform.nvim",
  opts = {
    formatters_by_ft = {
      python = { "ruff_fix" },
    },
    format_on_focus_lost = true, -- Custom option to attach autocmd
  },
  init = function()
    vim.api.nvim_create_autocmd("FocusLost", {
      pattern = "*.py",
      callback = function()
        require("conform").format({ async = true, lsp_fallback = true })
      end,
    })
  end,
}
