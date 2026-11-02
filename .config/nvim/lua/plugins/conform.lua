return {
  "stevearc/conform.nvim",
  opts = {
    formatters_by_ft = {
      lua = { "stylua" },
      -- fix lint issues, sort imports, then format
      python = { "ruff_fix", "ruff_organize_imports", "ruff_format" },
      rust = { "rustfmt", lsp_format = "fallback" },
      terraform = { "terraform_fmt" },
      ["terraform-vars"] = { "terraform_fmt" },
      hcl = { "terraform_fmt" },
    },
  },
}
