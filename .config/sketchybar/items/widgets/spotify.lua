local colors = require("colors")
local settings = require("settings")

local spotify = sbar.add("item", "widgets.spotify", {
	position = "right",
	icon = { drawing = false },
	label = {
		string = "",
		scroll_texts = false,
		color = colors.white,
		font = { style = settings.font.style_map["Bold"], size = 15.0 },
	},
	scroll_texts = false,
	padding_left = settings.paddings,
	padding_right = settings.paddings,
	update_freq = 2,
	updates = true,
	drawing = false,
})

local function update()
	sbar.exec("nowplaying-cli get playbackRate title artist", function(result)
		local rate, title, artist = "", "", ""
		local i = 0
		for line in result:gmatch("[^\r\n]+") do
			if i == 0 then rate = line
			elseif i == 1 then title = line
			elseif i == 2 then artist = line end
			i = i + 1
		end

		if rate == "0" or rate == "null" or title == "" or title == "null" then
			spotify:set({ drawing = false })
			return
		end

		spotify:set({
			drawing = true,
			label = { string = artist .. " - " .. title },
		})
	end)
end

spotify:subscribe({ "routine", "forced" }, update)

spotify:subscribe("mouse.clicked", function(env)
	if env.BUTTON == "right" then
		sbar.exec("open -a Spotify")
	else
		sbar.exec("nowplaying-cli togglePlayPause")
	end
end)

return spotify
