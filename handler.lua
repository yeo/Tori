local BasePlugin = require "kong.plugins.base_plugin"
local access = require "kong.plugins.tori.access"

local ToriHandler = BasePlugin:extend()

function ToriHandler:new()
  ToriHandler.super.new(self, "tori")
end

-- Execute before request is being proxy
-- We check for cookie here
function ToriHandler:access(config)
  ToriHandler.super.access(self)

  -- Execute any function from the module loaded in `access`,
  -- for example, `execute()` and passing it the plugin's configuration.
  access.execute(config)
end

return ToriHandler
