local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  spec = {
    -- add LazyVim and import its plugins
    { "LazyVim/LazyVim", import = "lazyvim.plugins" },
    -- import/override with your plugins
    { import = "plugins" },
    { import = "custom" },
    { import = "lang" },
  },
  defaults = {
    -- By default, only LazyVim plugins will be lazy-loaded. Your custom plugins will load during startup.
    -- If you know what you're doing, you can set this to `true` to have all your custom plugins lazy-loaded by default.
    lazy = false,
    -- It's recommended to leave version=false for now, since a lot the plugin that support versioning,
    -- have outdated releases, which may break your Neovim install.
    version = false, -- always use the latest git commit
    -- version = "*", -- try installing the latest stable version for plugins that support semver
  },
  install = { colorscheme = { "kanagawa-wave" } },
  checker = {
    enabled = true, -- check for plugin updates periodically
    notify = true, -- notify on update
  }, -- automatically check for plugin updates
  performance = {
    rtp = {
      -- disable some rtp plugins
      disabled_plugins = {
        "gzip",
        -- "matchit",
        -- "matchparen",
        -- "netrwPlugin",
        "tarPlugin",
        "tohtml",
        "tutor",
        "zipPlugin",
      },
    },
  },
})


-- local Terminal = require("toggleterm.terminal").Terminal
--
-- local function close_terminal_on_zero_exit(terminal, _, exit_code)
--   if exit_code == 0 then
--     terminal:close()
--   end
-- end
--
-- local lazygit = Terminal:new({
--   cmd = "lazygit",
--   direction = "float",
--   hidden = true,
--   on_exit = close_terminal_on_zero_exit,
-- })
--
-- local dotfileslazygit = Terminal:new({
--   cmd = "lazygit --git-dir=$HOME/.cfg --work-tree=$HOME",
--   direction = "float",
--   hidden = true,
--   on_exit = close_terminal_on_zero_exit,
-- })
--
-- local wk = require("which-key")
--
-- wk.add({
--   G = {
--     function()
--       local current_dir = vim.fn.getcwd()
--       local config_dir = vim.fn.expand("~/")
--       print(current_dir)
--
--       -- Check if we're in the config directory
--       if current_dir == config_dir then
--         dotfileslazygit:toggle()
--       else
--         lazygit:toggle()
--       end
--     end,
--     "lazygit",
--   },
-- }, { prefix = "g" })

-- TODO: add status line
-- local actived_venv = function()
--   local venv_name = require("venv-selector").get_active_venv()
--   if venv_name ~= nil then
--     return string.gsub(venv_name, ".*/pypoetry/virtualenvs/", "(poetry) ")
--   else
--     return "venv"
--   end
-- end
--
-- local venv = {
--   {
--     provider = function()
--       return "  " .. actived_venv()
--     end,
--   },
--   on_click = {
--     callback = function()
--       vim.cmd.VenvSelect()
--     end,
--     name = "heirline_statusline_venv_selector",
--   },
-- }
