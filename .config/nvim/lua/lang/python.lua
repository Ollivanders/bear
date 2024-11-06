local M = {}
M.ui = { theme = "catppuccin" }
M.plugins = "custom.plugins"

-- local config = require("lspconfig")
-- config.pyright.setup({
--   filetypes = { "python" },
-- })

return {
  "neovim/nvim-lspconfig",
  opts = {
    servers = {
      pyright = {},
    },
  },
  config = function()
    require("lspconfig")
    require(M)
  end,
}
