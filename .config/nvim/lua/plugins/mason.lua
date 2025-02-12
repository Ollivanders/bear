return {
  {
    "williamboman/mason.nvim",
    opts = {
      ensure_installed = {
        "debugpy",
        "black",
        "pyright",
        "mypy",
        "ruff",
        "ruff-lsp",
        "lua-language-server",
      },
    },
  },
}
