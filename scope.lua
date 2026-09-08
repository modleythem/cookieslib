local events = require("cookies.events")

--- @class cookies.Scope
--- @field private unsubscribe set<function>
--- @field private __index table
local Scope = { }
Scope.__index = Scope


local scope = {}

--- Creates a new Scope.
--- 
--- @return cookies.Scope
function scope.new()
    return setmetatable({
        unsubscribe = {},
    }, Scope)
end

--- Adds an event listener to a select event, which will be tied to the Scope.
--- 
--- If any of the dependency functions return `nil`, the listener will not run and
--- instead automatically unsubscribe.
--- 
--- @param event string The name of the event.
--- @param listener function The event listener.
--- @param ... (fun(): any)? Functions returning dependencies linked to the listener.
--- @return function unsubscribe A function to unsubscribe to the event.
function Scope:on(event, listener, ...)
    local dependencies = { ... }
    local l
    local u

    if #dependencies > 0 then
        u = events.on(event, function(...)
            for _, dep in ipairs(dependencies) do
                if dep() == nil then
                    events.queue(l)
                    return
                end
            end
            listener(...)
        end)
    else
        u = events.on(event, listener)
    end

    self.unsubscribe[u] = true
    l = function()
        u()
        self.unsubscribe[u] = nil
    end
    return l
end

--- Unsubscribes all event listeners tied to the Scope.
--- 
--- You usually want to queue this function call in case an event currently running gets
--- a listener to unsubscribe which can be problematic.
function Scope:unsubscribeAll()
    for u in pairs(self.unsubscribe) do
        self.unsubscribe[u] = nil
        u()
    end
end


return scope
