return {
  {
    "williamboman/mason.nvim",
    opts = {
      ensure_installed = {
        "debugpy",
        "pyright",
        "mypy",
        "ruff",
        "ruff-lsp",
        "lua-language-server",
      },
    },
  },
}
