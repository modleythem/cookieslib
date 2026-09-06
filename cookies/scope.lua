local events = require("cookies.events")

--- @class cookies.Scope
--- @field private listeners table
--- A scope is an object holding a bunch of event listeners. It allows for automatic unsubscribing of
--- multiple event listeners.
local Scope = {
    unsubscribe = {},
}
Scope.__index = Scope

--- @return cookies.Scope
--- Creates a new Scope.
function Scope.new()
    return setmetatable({
        unsubscribe = {},
    }, Scope)
end

--- @param event string The name of the event
--- @param listener function The event listener
--- @return function unsubscribe A function to unsubscribe to the event
function Scope:on(event, listener)
    local u = events.on(event, listener)
    self.unsubscribe[u] = true

    return function()
        self.unsubscribe[u] = nil
        u()
    end
end

function Scope:unsubscribeAll()
    for u in pairs(self.unsubscribe) do
        self.unsubscribe[u] = nil
        u()
    end
end


return Scope
