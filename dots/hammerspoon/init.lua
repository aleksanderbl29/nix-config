package.path = os.getenv("HOME") .. "/.hammerspoon/?.lua;" .. package.path

local dock = require("dock")

hs.screen.watcher.new(dock.updateDockVisibility):start()
dock.updateDockVisibility()

hs.alert.show("Hammerspoon loaded")
