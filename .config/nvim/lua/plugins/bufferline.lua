return {
  {
    "akinsho/bufferline.nvim",
    event = "VeryLazy",
    version = "*",
    dependencies = 'nvim-tree/nvim-web-devicons',
    opts = {
      options = {
        max_name_length = 50,
        -- prefix used when a buffer is de-duplicated
        max_prefix_length = 15,
      },
    },
  },
}
