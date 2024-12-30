return {
  {
    "williamboman/mason.nvim",
    opts = {
      ensure_installed = {
        "debugpy",
        "pyright",
        "ruff-lsp",
        "lua-language-server",
      },
    },
  },
}
