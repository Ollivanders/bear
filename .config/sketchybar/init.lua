local colors = require("colors")
sbar = require("sketchybar")

sbar.begin_config()
require("default")
require("bar")
require("items")
sbar.end_config()

-- Run the event loop of the sketchybar module (without this there will be no
-- callback functions executed in the lua module)
sbar.event_loop()
