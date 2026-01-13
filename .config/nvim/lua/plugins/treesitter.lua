return {
  "nvim-treesitter/nvim-treesitter",
  opts = function(_, opts)
    opts.highlight = opts.highlight or {}
    opts.highlight.disable = opts.highlight.disable or {}

    if type(opts.highlight.disable) == "table" then
      table.insert(opts.highlight.disable, "vim")
    elseif type(opts.highlight.disable) == "function" then
      local prev = opts.highlight.disable
      opts.highlight.disable = function(lang, buf)
        if lang == "vim" then
          return true
        end
        return prev(lang, buf)
      end
    end

    return opts
  end,
}
