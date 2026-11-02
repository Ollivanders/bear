---@return { path: string, branch: string }[]
local function list_worktrees()
  local worktrees, current = {}, nil
  for _, line in ipairs(vim.fn.systemlist("git worktree list --porcelain")) do
    if vim.startswith(line, "worktree ") then
      current = { path = line:sub(#"worktree " + 1), branch = "(detached)" }
      worktrees[#worktrees + 1] = current
    elseif vim.startswith(line, "branch ") and current then
      current.branch = line:gsub("^branch refs/heads/", "")
    end
  end
  return worktrees
end

local function pick_worktree(prompt, on_choice)
  vim.ui.select(list_worktrees(), {
    prompt = prompt,
    format_item = function(item)
      return ("%s -> %s"):format(item.branch, item.path)
    end,
  }, function(choice)
    if choice then
      on_choice(choice)
    end
  end)
end

return {
  "polarmutex/git-worktree.nvim",
  version = "^2",
  dependencies = { "nvim-lua/plenary.nvim" },
  keys = {
    {
      "<leader>gws",
      function()
        pick_worktree("Switch worktree", function(wt)
          require("git-worktree").switch_worktree(wt.path)
        end)
      end,
      desc = "Switch",
    },
    {
      "<leader>gwn",
      function()
        vim.ui.input({ prompt = "Branch: " }, function(branch)
          if not branch or branch == "" then
            return
          end
          vim.ui.input({ prompt = "Path: ", default = "../" .. branch }, function(path)
            if path and path ~= "" then
              require("git-worktree").create_worktree(path, branch, "origin")
            end
          end)
        end)
      end,
      desc = "New",
    },
    {
      "<leader>gwr",
      function()
        pick_worktree("Remove worktree", function(wt)
          require("git-worktree").delete_worktree(wt.path, false)
        end)
      end,
      desc = "Remove",
    },
  },
}
