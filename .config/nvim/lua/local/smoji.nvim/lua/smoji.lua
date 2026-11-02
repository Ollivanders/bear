-- based on "zakissimo/smoji.nvim",
local M = {}

M.prompt = "Select : "

M.items = {
  "📦PACKAGE:- :package: - update compiled packages",
  "🎨FORMAT:- :art: - Improve structure / format of the code.",
  "⚡️IMPROVE:- :zap: - Improve performance.",
  "🔥REMOVE: - :fire: - Remove code or files.",
  "🐛FIX: - :bug: - Fix a bug.",
  "🚑️CRITICAL: - :ambulance: - Critical hotfix.",
  "📝DOCS: - :memo: - Add or update documentation.",
  "🚀RELEASE: - :rocket: - Deploy stuff.",
  "✅DONE: - :white_check_mark: - Add, update, or pass tests.",
  "🚧WIP: - :construction: - Work in progress.",
  "➕ADD: - :heavy_plus_sign: - Add a dependency.",
  "💥BREAKING:  - :boom: - Introduce breaking changes.",
  "♻️REFACTOR:  - :recycle: - Refactor code.",
  "🔒️LOCK- :lock: - Fix security issues.",
  "⬆️UPGRADE: - :arrow_up: - Upgrade dependencies.",
  "⬆️BUMP: - :arrow_up: - Bump dependencies.",
  "📌PIN: - :pushpin: - Pin dependencies to specific versions.",
  "💸MONEY: - :money_with_wings: - Add sponsorships or money related infrastructure.",
  "✨NEW: - :sparkles: - Introduce new features.",
  "💄UI: - :lipstick: - Add or update the UI and style files.",
  "🎉BEGIN: - :tada: - Begin a project.",
  "🔐SECRET: - :closed_lock_with_key: - Add or update secrets.",
  "🔖TAG: - :bookmark: - Release / Version tags.",
  "🚨COMPILER: - :rotating_light: - Fix compiler / linter warnings.",
  "💚CI: - :green_heart: - Fix CI Build.",
  "⬇️DOWNGRADE: - :arrow_down: - Downgrade dependencies.",
  "👷BUILD: - :construction_worker: - Add or update CI build system.",
  "📈ANALYICS: - :chart_with_upwards_trend: - Add or update analytics or track code.",
  "➖DELETE: - :heavy_minus_sign: - Remove a dependency.",
  "🔧CONFIG: - :wrench: - Add or update configuration files.",
  "🔨SCRIPT: - :hammer: - Add or update development scripts.",
  "✏️TYPO: - :pencil2: - Fix typos.",
  "⏪️REVERT: - :rewind: - Revert changes.",
  "🔀MERGE: - :twisted_rightwards_arrows: - Merge branches.",
  "👽️EXTERNAL: - :alien: - Update code due to external API changes.",
  "🚚MOVE: - :truck: - Move or rename resources (e.g.: files, paths, routes).",
  "📄LICENSE: - :page_facing_up: - Add or update license.",
  "♿️ACCESSIBILITY: - :wheelchair: - Improve accessibility.",
  "💡COMMENTS: - :bulb: - Add or update comments in source code.",
  "🗃️DATA: - :card_file_box: - Perform database related changes.",
  "🔊LOGS: - :loud_sound: - Add or update logs.",
  "🔇REMOVE_LOGS: - :mute: - Remove logs.",
  "👥CONTRIBUTOR: - :busts_in_silhouette: - Add or update contributor(s).",
  "🚸UX: - :children_crossing: - Improve user experience / usability.",
  "🏗️DESIGN: - :building_construction: - Make architectural changes.",
  "🤡MOCK: - :clown_face: - Mock things.",
  "🙈GIT_IGNORE: - :see_no_evil: - Add or update a .gitignore file.",
  "📸SNAPSHOT: - :camera_flash: - Add or update snapshots.",
  "⚗️EXPERIEMENT: - :alembic: - Perform experiments.",
  "🏷️TYPES: - :label: - Add or update types.",
  "🚩FEATURE_FLAG - :triangular_flag_on_post: - Add, update, or remove feature flags.",
  "🥅CATCH_ERROR: - :goal_net: - Catch errors.",
  "🗑️DEPRECATE: - :wastebasket: - Deprecate code that needs to be cleaned up.",
  "🛂AUTH: - :passport_control: - Work on code related to authorization, roles and permissions.",
  "🩹PATCH: - :adhesive_bandage: - Simple fix for a non-critical issue.",
  "🧐INSPECT: - :monocle_face: - Data exploration/inspection.",
  "⚰️HIDE: - :coffin: - Remove dead code.",
  "🧪TESTER: - :test_tube: - Add a failing test.",
  "🩺HEALTH: - :stethoscope: - Add or update healthcheck.",
  "🧱INFRA: - :bricks: - Infrastructure related changes.",
  "🧵THREADING: - :thread: - Add or update code related to multithreading or concurrency.",
  "🦺VALIDATION: - :safety_vest: - Add or update code related to validation.",
  "🧬EXPERIMENTAL: - :genetics: - Experiment with core change",
  "🔺CHANGE: - :change: - Change component",
  "🌶️SPICY: - :spicy: - Spicy change",
  "🧹DECOM:- :broom: - decom something",
}

--- Insert `text` where the picker was opened from: typed into the job for terminals,
--- otherwise inserted at the saved cursor position and insert mode resumed.
local function insert_at(ctx, text)
  if not vim.api.nvim_win_is_valid(ctx.win) then
    return
  end
  vim.api.nvim_set_current_win(ctx.win)
  if vim.bo[ctx.buf].buftype == "terminal" then
    vim.api.nvim_chan_send(vim.bo[ctx.buf].channel, text)
    vim.cmd("startinsert")
    return
  end
  local row, col = ctx.cursor[1], ctx.cursor[2]
  vim.api.nvim_buf_set_text(ctx.buf, row - 1, col, row - 1, col, { text })
  local at_eol = col + #text >= #vim.api.nvim_buf_get_lines(ctx.buf, row - 1, row, true)[1]
  -- normal mode clamps the cursor onto the last char, so at end of line use `startinsert!`
  vim.api.nvim_win_set_cursor(ctx.win, { row, col + #text })
  if ctx.insert then
    vim.cmd(at_eol and "startinsert!" or "startinsert")
  end
end

M.select = function()
  -- capture origin before the picker takes focus
  local ctx = {
    win = vim.api.nvim_get_current_win(),
    buf = vim.api.nvim_get_current_buf(),
    cursor = vim.api.nvim_win_get_cursor(0),
    insert = vim.fn.mode():sub(1, 1) == "i",
  }
  vim.ui.select(M.items, { prompt = M.prompt }, function(choice)
    if not choice then
      return
    end
    local emoji = vim.trim(vim.split(choice, "-")[1])
    vim.fn.setreg("+", emoji)
    vim.fn.setreg('"', emoji)
    vim.schedule(function()
      insert_at(ctx, emoji)
    end)
  end)
end

vim.api.nvim_create_user_command("Smoji", M.select, { nargs = 0 })

return M
