local colors = require("colors")
local settings = require("settings")
local clock_item = require("items.widgets.clock")
local battery_mod = require("items.widgets.battery")

local artwork_script = os.getenv("HOME") .. "/.config/sketchybar/helpers/scripts/artwork.sh"

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

-- Purely decorative spacer so the artwork backdrop extends further left,
-- past the right cluster, toward the middle of the bar.
local spotify_pad = sbar.add("item", "widgets.spotify.pad", {
	position = "right",
	icon = { drawing = false },
	label = { drawing = false },
	width = 400,
})

-- Groups the pads + spotify + battery + clock behind one shared background so
-- now-playing artwork can render as a backdrop across the whole right side.
local right_cluster = sbar.add("bracket", "widgets.right_cluster", {
	"widgets.spotify.pad",
	"widgets.spotify",
	"widgets.battery",
	"widgets.clock",
}, {
	background = {
		drawing = false,
		image = { scale = 1.0 },
		corner_radius = 9,
		height = 38,
	},
})

local function set_cluster_text_color(color)
	spotify:set({ label = { color = color } })
	clock_item:set({ label = { color = color } })
	battery_mod.battery:set({ label = { color = color } })
end

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
			right_cluster:set({ background = { drawing = false } })
			set_cluster_text_color(colors.white)
			return
		end

		spotify:set({
			drawing = true,
			label = { string = artist .. " - " .. title },
		})

		sbar.exec(artwork_script, function(result)
			local art_path, brightness = "", nil
			local j = 0
			for line in result:gmatch("[^\r\n]+") do
				if j == 0 then art_path = line
				elseif j == 1 then brightness = tonumber(line) end
				j = j + 1
			end

			if art_path == "" then
				right_cluster:set({ background = { drawing = false } })
				set_cluster_text_color(colors.white)
			else
				right_cluster:set({
					background = {
						drawing = true,
						image = { string = art_path },
					},
				})
				local is_light = brightness ~= nil and brightness > 0.55
				set_cluster_text_color(is_light and colors.black or colors.white)
			end
		end)
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
