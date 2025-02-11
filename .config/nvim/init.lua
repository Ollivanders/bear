-- bootstrap lazy.nvim, LazyVim and your plugins
require("config.lazy")

vim.notify = function(msg, ...)
  if not msg:match("VenvSelect Registered") then
    print(msg)
  end
end
