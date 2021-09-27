local BasePlugin = require "kong.plugins.base_plugin"
local access = require "kong.plugins.multi-header-based-route.access"
local MultiHeaderBasedHandler = BasePlugin:extend()

MultiHeaderBasedHandler.PRIORITY = 804
MultiHeaderBasedHandler.VERSION = "1.0.0"

function MultiHeaderBasedHandler:new()
    MultiHeaderBasedHandler.super.new(self, "multi-header-based-route")
end

function MultiHeaderBasedHandler:access(conf)
    MultiHeaderBasedHandler.super.access(self)
    access.execute(conf)
end

return MultiHeaderBasedHandler
