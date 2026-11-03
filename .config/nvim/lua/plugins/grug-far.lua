local default_flags = "-F --hidden --multiline"

--- Close the named instance if it exists (get_instance errors when missing).
---@param name string
local function close_instance(name)
  local gf = require("grug-far")
  if gf.has_instance(name) then
    gf.get_instance(name):close()
  end
end

--- (Re)open a named instance, closing any previous one first.
--- Visual selection is captured before closing, since closing can disturb visual mode.
---@param name string
---@param prefills table
---@param visual? boolean use the visual selection as the search
local function reopen(name, prefills, visual)
  local gf = require("grug-far")
  prefills = vim.tbl_extend("force", { flags = default_flags }, prefills)
  if visual then
    prefills.search = gf.get_current_visual_selection()
  end
  close_instance(name)
  gf.open({
    instanceName = name,
    staticTitle = name,
    visualSelectionUsage = "ignore",
    prefills = prefills,
  })
end

---@param prefills table
---@param visual? boolean
local function toggle(prefills, visual)
  reopen("Toggle", prefills, visual)
end

return {
  "MagicDuck/grug-far.nvim",
  cmd = "GrugFar",
  opts = { headerMaxWidth = 80 },
  init = function()
    vim.api.nvim_create_autocmd("FileType", {
      group = vim.api.nvim_create_augroup("user_grug_far_keys", { clear = true }),
      pattern = "grug-far",
      callback = function(ev)
        local function toggle_flag(flag)
          local state = unpack(require("grug-far").get_instance(0):toggle_flags({ flag }))
          vim.notify(("grug-far: %s %s"):format(flag, state and "ON" or "OFF"))
        end
        vim.keymap.set("n", "<C-enter>", function()
          local inst = require("grug-far").get_instance(0)
          inst:open_location()
          inst:close()
        end, { buffer = ev.buf, desc = "Open location and close" })
        vim.keymap.set("n", "<C-f>", function()
          toggle_flag("-F")
        end, { buffer = ev.buf, desc = "Toggle -F" })
        vim.keymap.set("n", "<C-a>", function()
          toggle_flag("--hidden")
        end, { buffer = ev.buf, desc = "Toggle --hidden" })
      end,
    })
  end,
  keys = {
    {
      "<leader>sr",
      function()
        reopen("Main", {}, vim.fn.mode():find("[vV\22]") ~= nil)
      end,
      mode = { "n", "v" },
      desc = "S/R Main",
    },
    {
      "<leader>rn",
      function()
        require("grug-far").toggle_instance({
          instanceName = "Second",
          staticTitle = "Second",
          prefills = { flags = default_flags },
        })
      end,
      mode = { "n", "v" },
      desc = "S/R Toggle Second",
    },
    {
      "<leader>rt",
      function()
        require("grug-far").toggle_instance({
          instanceName = "Toggle",
          staticTitle = "Toggle",
          prefills = { flags = default_flags },
        })
      end,
      mode = { "n", "v" },
      desc = "S/R Toggle",
    },
    {
      "<leader>rv",
      function()
        toggle({ paths = vim.fn.expand("%") }, true)
      end,
      mode = "v",
      desc = "S/R visual selection",
    },
    {
      "<leader>rd",
      function()
        local dir_name = vim.fn.expand("%:p:h:t")
        toggle({ flags = "", search = "source .*=.*/modules/" .. dir_name .. '"' })
      end,
      desc = "S/R Terraform Module",
    },
    {
      "<leader>rp",
      function()
        local search = vim.fn.getreg("+")
        -- `*` searches are \<word\>; convert to ripgrep word boundaries
        if vim.startswith(search, "\\<") and vim.endswith(search, "\\>") then
          search = "\\b" .. search:sub(3, -3) .. "\\b"
        end
        toggle({ search = search })
      end,
      desc = "S/R using clipboard (+) value",
    },
    {
      "<leader>rw",
      function()
        toggle({ search = vim.fn.expand("<cword>") })
      end,
      desc = "S/R word under cursor",
    },
    {
      "<leader>rf",
      function()
        toggle({ paths = vim.fn.expand("%") })
      end,
      desc = "S/R Current file",
    },
    {
      "<leader>rf",
      function()
        toggle({ paths = vim.fn.expand("%") }, true)
      end,
      mode = "v",
      desc = "S/R Visual, Current file",
    },
    {
      "<leader>rc",
      function()
        toggle({ paths = vim.fn.expand("%:p:h") })
      end,
      desc = "S/R Current Dir",
    },
    {
      "<leader>rc",
      function()
        toggle({ paths = vim.fn.expand("%:p:h") }, true)
      end,
      mode = "v",
      desc = "S/R Visual, Current Dir",
    },
    {
      "<leader>rr",
      function()
        for _, name in ipairs({ "Main", "Toggle" }) do
          local gf = require("grug-far")
          if gf.has_instance(name) then
            gf.get_instance(name):search()
          end
        end
      end,
      mode = { "n", "v" },
      desc = "S/R Refresh",
    },
  },
}
