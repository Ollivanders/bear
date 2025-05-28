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
}

M.select = function()
  vim.ui.select(M.items, {
    prompt = M.prompt,
    format_item = function(item)
      return item
    end,
  }, function(choice)
    if choice == nil then
      vim.print("No choice made!")
      return
    end

    local s = vim.split(choice, "-")
    local emoji = s[1]

    vim.fn.setreg("+", emoji)
    vim.fn.setreg('"', emoji)

    if vim.bo.buftype == "terminal" then
      local reg = "0"
      local old_val = vim.fn.getreg(reg)
      vim.fn.setreg(reg, emoji)
      -- vim.cmd('normal! "0p')
      -- vim.cmd("startinsert!")
      -- vim.fn.setreg(reg, old_val)
    else
      vim.cmd("normal!" .. emoji)
    end
  end)
end

vim.api.nvim_create_user_command("Smoji", M.select, { nargs = 0 })

return M
