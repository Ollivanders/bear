-- local config = require("lspconfig")
-- config.pyright.setup({
--   filetypes = { "python" },
-- })

-- Configure `ruff-lsp`.
-- See: https://github.com/neovim/nvim-lspconfig/blob/master/doc/configs.md#ruff_lsp
-- For the default config, along with instructions on how to customize the settings
-- require("lspconfig").ruff_lsp.setup({
--   init_options = {
--     settings = {
--       -- Any extra CLI arguments for `ruff` go here.
--       args = {},
--     },
--   },
-- })
--
-- require("lspconfig").pyright.setup({
--   settings = {
--     pyright = {
--       -- Using Ruff's import organizer
--       disableOrganizeImports = true,
--     },
--     python = {
--       analysis = {
--         -- Ignore all files for analysis to exclusively use Ruff for linting
--         ignore = { "*" },
--       },
--     },
--   },
-- })
--
-- return {
--   "neovim/nvim-lspconfig",
--   opts = {
--     servers = {
--       pyright = {},
--       ruff_lsp = {},
--     },
--   },
--   config = function()
--     require("lspconfig")
--   end,
-- }

return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        pylsp = {
          settings = {
            pylsp = {
              plugins = {
                rope_autoimport = {
                  enabled = true,
                },
              },
            },
          },
        },
      },
    },
  },

  { import = "lazyvim.plugins.extras.lang.python" },
}
