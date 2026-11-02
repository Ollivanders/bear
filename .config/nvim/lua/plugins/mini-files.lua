return {
  "nvim-mini/mini.files",
  opts = {
    windows = {
      preview = true,
      width_focus = 50,
      width_nofocus = 15,
      width_preview = 80,
    },
  },
  init = function()
    -- `l` on a file: choose the target window with window-picker before opening
    vim.api.nvim_create_autocmd("User", {
      pattern = "MiniFilesBufferCreate",
      callback = function(args)
        vim.keymap.set("n", "l", function()
          local mini_files = require("mini.files")
          local fs_entry = mini_files.get_fs_entry()
          if fs_entry and fs_entry.fs_type == "file" then
            local win = require("window-picker").pick_window()
            if not win then
              return
            end
            mini_files.set_target_window(win)
          end
          mini_files.go_in({ close_on_file = true })
        end, { buffer = args.data.buf_id, desc = "Open in target window" })
      end,
    })
  end,
}
