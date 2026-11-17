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
        -- per-stack root; .git made it index whole monorepo
        root_markers = { ".terraform.lock.hcl", ".terraform", ".git" },
        init_options = {
          indexing = { ignoreDirectoryNames = { ".terraform", "plan" } },
        },
      },
    },
  },
}
