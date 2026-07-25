return {
	black = 0xff1c1c1e,
	white = 0xffffffff,
	red = 0xffff453a,
	green = 0xff30d158,
	blue = 0xff0a84ff,
	yellow = 0xffffd60a,
	orange = 0xffff9f0a,
	magenta = 0xffbf5af2,
	grey = 0xffaeaeb2,
	transparent = 0x00000000,
	aerospace_label_color = 0xff8e8e93,
	aerospace_border_color = 0x30ffffff,
	aerospace_label_highlight_color = 0xffe8e8ed,
	aerospace_icon_highlight_color = 0xffe8e8ed,
	front_app_color = 0xffe8e8ed,

	bar = {
		bg = 0x00000000,
		border = 0x00000000,
	},
	popup = {
		bg = 0x55000000,
		border = 0x55ffffff,
	},
	bg1 = 0x20ffffff,
	bg2 = 0x38ffffff,
	bg3 = 0x1affffff,
	transparency = 0.85,
	blur_radius = 70,

	with_alpha = function(color, alpha)
		if alpha > 1.0 or alpha < 0.0 then
			return color
		end
		return (color & 0x00ffffff) | (math.floor(alpha * 255.0) << 24)
	end,
}
