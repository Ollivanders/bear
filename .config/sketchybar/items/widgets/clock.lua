local colors = require("colors")
local settings = require("settings")

local clock = sbar.add("item", "widgets.clock", {
	position = "right",
	icon = { drawing = false },
	label = {
		string = "??:??",
		color = colors.white,
		font = { family = settings.font.numbers, style = settings.font.style_map["Bold"], size = 15.0 },
		width = 180,
		align = "right",
	},
	padding_left = settings.paddings,
	padding_right = settings.paddings + 22,
	update_freq = 1,
	updates = true,
})

local function update()
	sbar.exec("date '+%a %d %b %H:%M:%S'", function(result)
		clock:set({ label = { string = result:gsub("%s+$", "") } })
	end)
end

clock:subscribe({ "routine", "forced" }, update)

return clock
