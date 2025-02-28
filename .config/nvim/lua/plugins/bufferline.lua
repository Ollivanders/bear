return {
  {
    "akinsho/bufferline.nvim",
    --   version = "*",
    --   dependencies = "nvim-tree/nvim-web-devicons",
    opts = {
      options = {
        max_name_length = 50,
        max_prefix_length = 15, -- prefix used when a buffer is de-duplicated
        separator_style = "slanted",
        sort_by = "insert_after_current"
          | "insert_at_end"
          | "id"
          | "extension"
          | "relative_directory"
          | "directory"
          | "tabs"
          | function(buffer_a, buffer_b)
            -- add custom logic
            local modified_a = vim.fn.getftime(buffer_a.path)
            local modified_b = vim.fn.getftime(buffer_b.path)
            return modified_a > modified_b
          end,
      },
    },
  },
}
