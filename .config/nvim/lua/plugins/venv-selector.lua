return {
  "linux-cultist/venv-selector.nvim",
  dependencies = {
    "neovim/nvim-lspconfig",
    "mfussenegger/nvim-dap",
    "mfussenegger/nvim-dap-python",
    { "nvim-telescope/telescope.nvim", branch = "0.1.x", dependencies = { "nvim-lua/plenary.nvim" } },
  },
  lazy = false,
  keys = {
    { ",v", "<cmd>VenvSelect<cr>" },
  },
  config = function()
    require("venv-selector").setup({
      settings = {
        options = {
          notify_user_on_venv_activation = false,
          dap_enabled = true,
        },
      },
    })
  end,
}
