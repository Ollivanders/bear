return {
  "nvim-neo-tree/neo-tree.nvim",
  opts = {
    sources = { "filesystem", "buffers", "git_status" },
    source_selector = {
      winbar = false,
      statusline = false
    },
    open_files_do_not_replace_types = { "terminal", "Trouble", "qf", "edgy" },
    filesystem = {
      filtered_items = {
        bind_to_cwd = true,
        cwd_target = {
          sidebar = "global",
          current = "global",
        },
        visible = true,
        show_hidden_count = true,
        hide_dotfiles = false,
        hide_gitignored = true,
        never_show = {
          ".git",
          ".DS_Store",
          "__pycache__",
          ".mypy_cache",
          ".pytest_cache",
          ".ruff_cache",
          ".ropeproject",
          ".venv",
        },
      },
    },
    event_handlers = {
      {
        event = "neo_tree_popup_input_ready",
        ---@param args { bufnr: integer, winid: integer }
        handler = function(args)
          vim.cmd("stopinsert")
          vim.keymap.set("i", "<esc>", vim.cmd.stopinsert, { noremap = true, buffer = args.bufnr })
        end,
      },
    },
    commands = {
      copy_selector = function(state)
        local node = state.tree:get_node()
        local filepath = node:get_id()
        local filename = node.name
        local modify = vim.fn.fnamemodify

        local vals = {
          ["BASENAME"] = modify(filename, ":r"),
          ["EXTENSION"] = modify(filename, ":e"),
          ["FILENAME"] = filename,
          ["PATH (CWD)"] = modify(filepath, ":."),
          ["PATH (HOME)"] = modify(filepath, ":~"),
          ["PATH"] = filepath,
          ["URI"] = vim.uri_from_fname(filepath),
        }

        local options = vim.tbl_filter(function(val)
          return vals[val] ~= ""
        end, vim.tbl_keys(vals))
        if vim.tbl_isempty(options) then
          vim.notify("No values to copy", vim.log.levels.WARN)
          return
        end
        table.sort(options)
        vim.ui.select(options, {
          prompt = "Choose to copy to clipboard:",
          format_item = function(item)
            return ("%s: %s"):format(item, vals[item])
          end,
        }, function(choice)
          local result = vals[choice]
          if result then
            vim.notify(("Copied: `%s`"):format(result))
            vim.fn.setreg("+", result)
          end
        end)
      end,
    },
    window = {
      mappings = {
        ["Y"] = "copy_selector",
        -- set root dir for neovim
        ["q"] = function(state)
          local node = state.tree:get_node()
          local path = node:get_id()

          -- If a file is selected, use its parent directory
          if node.type ~= "directory" then
            path = vim.fs.dirname(path)
          end

          -- Sanity check
          if vim.fn.isdirectory(path) == 0 then
            vim.notify("Not a directory: " .. path, vim.log.levels.ERROR, { title = "Neo-tree" })
            return
          end

          -- Update Neo-tree root and Neovim cwd (project-wide)
          vim.fn.chdir(path)
          vim.notify("Project root & cwd set to: " .. path, vim.log.levels.INFO, { title = "Neo-tree" })
        end,
        ["Q"] = function(_)
          -- Try to detect a project root (prefers .git)
          local bufpath = vim.api.nvim_buf_get_name(0)
          local git_root = vim.fs.dirname(vim.fs.find(".git", { upward = true, path = bufpath })[1] or "")
          local root = (#git_root > 0) and git_root or vim.loop.cwd()

          assert(root ~= nil, "Root directory cannot be nil")
          vim.fn.chdir(root)
          vim.notify("Reset root & cwd to: " .. root, vim.log.levels.INFO, { title = "Neo-tree" })
        end,
      },
    },
  },
  dependencies = "nvim-tree/nvim-web-devicons",
}
