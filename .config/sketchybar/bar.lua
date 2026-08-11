local colors = require("colors")
sbar = require("sketchybar")

sbar.bar({
	display = "all",
	-- topmost = "off",
	height = 38,
	-- notch_offset = 10,
	-- y_offset = -10,
	notch_display_height = 38,
	-- margin = 15,
	-- corner_radius = 30,
	border_width = 0,
	border_color = colors.bar.border,
	color = colors.bar.bg,
	blur_radius = 0,
	padding_right = 5,
	padding_left = 5,
})
