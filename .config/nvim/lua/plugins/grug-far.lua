local grug_far_open_cfg = {
  prefills = {
    flags = "-F --hidden",
  },
  instanceName = "Toggle",
  staticTitle = "Toggle",
}

function close_toggle_instance()
  local inst = require("grug-far.instances").get_instance("Toggle" or 0)
  if inst then
    inst:close()
  end
end

local M = {
  "MagicDuck/grug-far.nvim",
  opts = { headerMaxWidth = 80 },
  cmd = "GrugFar",
  config = function()
    require("grug-far").setup({})
  end,
  keys = {
    {
      "<leader>sr",
      function()
        local grug = require("grug-far")
        local ext = vim.bo.buftype == "" and vim.fn.expand("%:e")
        grug.open({
          transient = true,
          instanceName = "Main",
          staticTitle = "Main",
          prefills = {
            flags = "-F --hidden",
            -- filesFilter = ext and ext ~= "" and "*." .. ext or nil,
          },
        })
      end,
      mode = { "n", "v" },
      desc = "Search and Replace Main",
    },
    {
      "<leader>rt",
      function()
        require("grug-far").toggle_instance({
          instanceName = "Toggle",
          staticTitle = "Toggle",
          prefills = {
            flags = "-F --hidden",
          },
        })
      end,
      mode = { "n", "v" },
      desc = "Search and Replace Toggle",
    },
    {
      "<leader>rv",
      function()
        close_toggle_instance()
        require("grug-far").with_visual_selection(grug_far_open_cfg)
      end,
      mode = { "n", "v" },
      desc = "Search Replace visual selection",
    },
    {
      "<leader>rd",
      function()
        close_toggle_instance()
        local dir_name = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(0), ":p:h:t")
        local search = "source .*=.*/" .. dir_name .. '"'
        require("grug-far").toggle_instance(vim.tbl_deep_extend("force", grug_far_open_cfg, {
          prefills = {
            flags = "",
            search = search,
          },
        }))
      end,
      mode = { "n", "v" },
      desc = "Search Replace Terraform Module",
    },
    {
      "<leader>rp",
      function()
        close_toggle_instance()
        local search = vim.fn.getreg("*")
        -- surround with \b if "word" search (such as when pressing `*`)
        if search and vim.startswith(search, "\\<") and vim.endswith(search, "\\>") then
          search = "\\b" .. search:sub(3, -3) .. "\\b"
        end

        require("grug-far").toggle_instance(vim.tbl_deep_extend("force", grug_far_open_cfg, {
          prefills = { search = search },
        }))
      end,
      mode = { "n", "v" },
      desc = "Search using @/ register value or visual selection",
    },
    {
      "<leader>rw",
      function()
        close_toggle_instance()
        require("grug-far").toggle_instance(vim.tbl_deep_extend("force", grug_far_open_cfg, {
          prefills = { search = vim.fn.expand("<cword>") },
        }))
      end,
      mode = { "n", "v" },
      desc = "Search Replace Current Word",
    },
    {
      "<leader>rf",
      function()
        close_toggle_instance()
        require("grug-far").toggle_instance(vim.tbl_deep_extend("force", grug_far_open_cfg, {
          prefills = {
            paths = vim.fn.expand("%"),
          },
        }))
      end,
      mode = { "n", "v" },
      desc = "Search Replace Current file",
    },
  },
}
return M
