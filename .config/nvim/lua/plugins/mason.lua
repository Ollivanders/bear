return {
  {
    "williamboman/mason.nvim",
    opts = {
      ensure_installed = {
        "pyright",
        "ruff-lsp",
        "lua-language-server",
      },
    },
  },
}
