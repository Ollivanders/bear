return {
  "folke/edgy.nvim",
  init = function()
    vim.opt.laststatus = 3
    vim.opt.splitkeep = "topline"
  end,
  event = "VeryLazy",
  keys = {
    -- stylua: ignore
    { "<leader>ue", function() require("edgy").toggle() end, desc = "Edgy Toggle", },
    -- stylua: ignore
    { "<leader>r",  function() require("edgy").toggle() end, desc = "Edgy Toggle", },
    -- stylua: ignore
    { "<leader>uE", function() require("edgy").select() end, desc = "Edgy Select Window" },
  },
  opts = function()
    return {
      options = {
        left = { size = 30 },
      },
      keys = {
        -- increase width
        ["<c-w>>"] = function(win)
          win:resize("width", 5)
        end,
        -- decrease width
        ["<c-w><lt>"] = function(win)
          win:resize("width", -5)
        end,
      },
      left = {
        {
          title = "Buffers",
          ft = "neo-tree",
          filter = function(buf)
            return vim.b[buf].neo_tree_source == "buffers"
          end,
          pinned = true,
          colapsed = false,
          size = { height = 0.15 },
          open = "Neotree position=top buffers",
        },
        {
          title = "Filesystem",
          ft = "neo-tree",
          filter = function(buf)
            return vim.b[buf].neo_tree_source == "filesystem"
          end,
          size = { height = 0.7 },
          pinned = true,
          colapsed = false,
          open = "Neotree filesystem position=left",
        },
        {
          title = "Git",
          ft = "neo-tree",
          filter = function(buf)
            return vim.b[buf].neo_tree_source == "git_status"
          end,
          size = { height = 0.15 },
          pinned = true,
          colapsed = false,
          open = "Neotree position=right git_status",
        },
        -- {
        --   title = function()
        --     local buf_name = vim.api.nvim_buf_get_name(0) or "[No Name]"
        --     return vim.fn.fnamemodify(buf_name, ":t")
        --   end,
        --   ft = "Outline",
        --   pinned = true,
        --   open = "SymbolsOutlineOpen",
        -- },
        -- any other neo-tree windows
        -- "neo-tree",
      },
    }
  end,
}
