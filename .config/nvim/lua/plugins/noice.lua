return {
  "folke/noice.nvim",
  opts = function(_, opts)
    opts.cmdline = opts.cmdline or {}
    opts.cmdline.format = opts.cmdline.format or {}

    local cmdline = opts.cmdline.format.cmdline
    if cmdline then
      -- Work around outdated vim Tree-sitter query nodes ("tab", "substitute") crashing Noice.
      cmdline.lang = nil
    end

    return opts
  end,
}
