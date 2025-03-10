-- based on "zakissimo/smoji.nvim",
local M = {}

M.prompt = "Select emoji:"

M.items = {
  "📦 NEW:- :new: - New feature",
  "🎨 FORMAT:- :art: - Improve structure / format of the code.",
  "⚡️IMPROVE:- :zap: - Improve performance.",
  "🔥 REMOVE: - :fire: - Remove code or files.",
  "🐛 FIX: - :bug: - Fix a bug.",
  "🚑️ CRITICAL: - :ambulance: - Critical hotfix.",
  "📝 DOCS: - :memo: - Add or update documentation.",
  "🚀 RELEASE: - :rocket: - Deploy stuff.",
  "✅ DONE: - :white_check_mark: - Add, update, or pass tests.",
  "🚧 WIP: - :construction: - Work in progress.",
  "➕ ADD: - :heavy_plus_sign: - Add a dependency.",
  "💥 BREAKING:  - :boom: - Introduce breaking changes.",
  "♻️ REFACTOR:  - :recycle: - Refactor code.",
  "🔒️LOCK- :lock: - Fix security issues.",
  "⬆️ UPGRADE: - :arrow_up: - Upgrade dependencies.",
  "📌 PIN: - :pushpin: - Pin dependencies to specific versions.",
  "💸 MONEY: - :money_with_wings: - Add sponsorships or money related infrastructure.",
  -- "✨ - :sparkles: - Introduce new features.",
  -- "💄 - :lipstick: - Add or update the UI and style files.",
  -- "🎉 - :tada: - Begin a project.",
  -- "🔐 - :closed_lock_with_key: - Add or update secrets.",
  -- "🔖 - :bookmark: - Release / Version tags.",
  -- "🚨 - :rotating_light: - Fix compiler / linter warnings.",
  -- "💚 - :green_heart: - Fix CI Build.",
  -- "⬇️ - :arrow_down: - Downgrade dependencies.",
  -- "👷 - :construction_worker: - Add or update CI build system.",
  -- "📈 - :chart_with_upwards_trend: - Add or update analytics or track code.",
  -- "➖ - :heavy_minus_sign: - Remove a dependency.",
  -- "🔧 - :wrench: - Add or update configuration files.",
  -- "🔨 - :hammer: - Add or update development scripts.",
  -- "🌐 - :globe_with_meridians: - Internationalization and localization.",
  -- "✏️ - :pencil2: - Fix typos.",
  -- "💩 - :poop: - Write bad code that needs to be improved.",
  -- "⏪️ - :rewind: - Revert changes.",
  -- "🔀 - :twisted_rightwards_arrows: - Merge branches.",
  -- "📦️ - :package: - Add or update compiled files or packages.",
  -- "👽️ - :alien: - Update code due to external API changes.",
  -- "🚚 - :truck: - Move or rename resources (e.g.: files, paths, routes).",
  -- "📄 - :page_facing_up: - Add or update license.",
  -- "🍱 - :bento: - Add or update assets.",
  -- "♿️ - :wheelchair: - Improve accessibility.",
  -- "💡 - :bulb: - Add or update comments in source code.",
  -- "🍻 - :beers: - Write code drunkenly.",
  -- "💬 - :speech_balloon: - Add or update text and literals.",
  -- "🗃️ - :card_file_box: - Perform database related changes.",
  -- "🔊 - :loud_sound: - Add or update logs.",
  -- "🔇 - :mute: - Remove logs.",
  -- "👥 - :busts_in_silhouette: - Add or update contributor(s).",
  -- "🚸 - :children_crossing: - Improve user experience / usability.",
  -- "🏗️ - :building_construction: - Make architectural changes.",
  -- "📱 - :iphone: - Work on responsive design.",
  -- "🤡 - :clown_face: - Mock things.",
  -- "🥚 - :egg: - Add or update an easter egg.",
  -- "🙈 - :see_no_evil: - Add or update a .gitignore file.",
  -- "📸 - :camera_flash: - Add or update snapshots.",
  -- "⚗️ - :alembic: - Perform experiments.",
  -- "🔍️ - :mag: - Improve SEO.",
  -- "🏷️ - :label: - Add or update types.",
  -- "🌱 - :seedling: - Add or update seed files.",
  -- "🚩 - :triangular_flag_on_post: - Add, update, or remove feature flags.",
  -- "🥅 - :goal_net: - Catch errors.",
  -- "💫 - :dizzy: - Add or update animations and transitions.",
  -- "🗑️ - :wastebasket: - Deprecate code that needs to be cleaned up.",
  -- "🛂 - :passport_control: - Work on code related to authorization, roles and permissions.",
  -- "🩹 - :adhesive_bandage: - Simple fix for a non-critical issue.",
  -- "🧐 - :monocle_face: - Data exploration/inspection.",
  -- "⚰️ - :coffin: - Remove dead code.",
  -- "🧪 - :test_tube: - Add a failing test.",
  -- "👔 - :necktie: - Add or update business logic.",
  -- "🩺 - :stethoscope: - Add or update healthcheck.",
  -- "🧱 - :bricks: - Infrastructure related changes.",
  -- "🧑‍💻 - :technologist: - Improve developer experience.",
  -- "🧵 - :thread: - Add or update code related to multithreading or concurrency.",
  -- "🦺 - :safety_vest: - Add or update code related to validation.",
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
    else
      local s = vim.split(choice, "-")
      local emoji = s[1]

      vim.fn.setreg("+", emoji)
      vim.fn.setreg('"', emoji)
      if vim.bo.buftype == "terminal" then
        print("terminal")
        print(emoji)
        local reg = "0"
        local old_val = vim.fn.getreg(reg)
        vim.fn.setreg(reg, emoji)
        -- vim.cmd('normal! "0p')
        -- vim.cmd("startinsert!")
        -- vim.fn.setreg(reg, old_val)
      else
        vim.cmd("normal! i" .. emoji)
      end
    end
  end)
end

vim.api.nvim_create_user_command("Smoji", M.select, { nargs = 0 })

return M
