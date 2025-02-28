return {
  "nvimtools/none-ls.nvim",
  dependencies = { "nvim-lua/plenary.nvim" },
  opts = function(_, opts)
    local null_ls = require("null-ls")

    local mypy_ignore_action = {
      name = "mypy_ignore",
      method = null_ls.methods.CODE_ACTION,
      filetypes = { "python" },
      generator = {
        fn = function(context)
          local row = context.row
          local lines = vim.api.nvim_buf_get_lines(0, row - 1, row, false)
          if #lines == 0 then
            return nil
          end
          local line = lines[1]
          if line:match("# type: ignore") then
            return nil
          end

          return {
            {
              title = "Add # type: ignore",
              action = function()
                vim.api.nvim_buf_set_lines(0, row - 1, row, false, { line .. "  # type: ignore" })
              end,
            },
          }
        end,
      },
    }

    null_ls.register(mypy_ignore_action)

    opts.root_dir = opts.root_dir
      or require("null-ls.utils").root_pattern(".null-ls-root", ".neoconf.json", "Makefile", ".git")

    opts.sources = vim.list_extend(opts.sources or {}, {
      null_ls.builtins.formatting.fish_indent,
      null_ls.builtins.diagnostics.fish,
      null_ls.builtins.formatting.stylua,
      null_ls.formatting.shfmt,
      null_ls.builtins.formatting.ruff,
    })
  end,
}
