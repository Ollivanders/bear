return {
  "neovim/nvim-lspconfig",
  opts = {
    inlay_hints = { enabled = false },
    servers = {
      bashls = {
        filetypes = { "sh", "zsh" },
      },
      ruby_lsp = {
        mason = false,
        cmd = { vim.fn.expand("~/.rbenv/shims/ruby-lsp") },
      },
      terraformls = {
        root_markers = { ".git" },
      },
    },
  },
}
