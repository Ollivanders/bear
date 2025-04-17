return {}
--[[
return {
  "folke/edgy.nvim",
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
    local opts = {
      options = {
        left = { size = 40 },
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
          title = "Filesystem",
          ft = "neo-tree",
          filter = function(buf)
            return vim.b[buf].neo_tree_source == "filesystem"
          end,
          size = { height = 0.7 },
          -- pinned = true,
          -- colapsed = false,
          -- open = "Neotree filesystem position=left",
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
        "neo-tree",
      },
    }

    local pos = {
      filesystem = "left",
      buffers = "top",
      git_status = "right",
      document_symbols = "bottom",
      diagnostics = "bottom",
    }
    local sources = LazyVim.opts("neo-tree.nvim").sources or {}
    for i, v in ipairs(sources) do
      table.insert(opts.left, i, {
        title = "Neo-Tree " .. v:gsub("_", " "):gsub("^%l", string.upper),
        ft = "neo-tree",
        filter = function(buf)
          return vim.b[buf].neo_tree_source == v
        end,
        pinned = true,
        open = function()
          vim.cmd(("Neotree show position=%s %s dir=%s"):format(pos[v] or "bottom", v, LazyVim.root()))
        end,
      })
    end
    return opts
  end,
}
--]]
