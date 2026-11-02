return {
  "linux-cultist/venv-selector.nvim",
  cmd = "VenvSelect",
  keys = {
    { ",v", "<cmd>VenvSelect<cr>", desc = "Select VirtualEnv" },
  },
  opts = {
    options = {
      picker = "snacks",
      notify_user_on_venv_activation = false,
    },
  },
}
