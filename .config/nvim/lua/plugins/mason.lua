return {
  {
    "mason-org/mason.nvim",
    opts = {
      ensure_installed = {
        "debugpy",
        "pyright",
        "mypy",
        "ruff",
        "lua-language-server",
      },
    },
  },
}
