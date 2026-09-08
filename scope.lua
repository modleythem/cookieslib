local events = require("cookies.events")

--- A Scope is an object holding a bunch of event listeners. It allows for automatic unsubscribing of
--- multiple event listeners.
--- @class cookies.Scope
--- @field private listeners table
local Scope = {
    unsubscribe = {},
}
Scope.__index = Scope

--- Creates a new Scope.
--- @return cookies.Scope
function Scope.new()
    return setmetatable({
        unsubscribe = {},
    }, Scope)
end

--- Adds an event listener to a select event, which will be tied to the Scope.
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

--- Unsubscribes all event listeners tied to the Scope.
function Scope:unsubscribeAll()
    for u in pairs(self.unsubscribe) do
        self.unsubscribe[u] = nil
        u()
    end
end


return Scope
