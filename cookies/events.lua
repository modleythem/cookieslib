--- @class cookies.Events
--- Handles event listening throughout the system.
local events = { }

--- @type table<string, table<function, boolean>>
local evs = { }


--- @param event string The name of the event
--- @param listener function The event listener
--- @return function unsubscribe A function to unsubscribe to the event
function events.on(event, listener)
    if not evs[event] then
        evs[event] = {}
    end
    evs[event][listener] = true

    return function () evs[event][listener] = nil end
end

function events.emit(event, ...)
    if not evs[event] then
        print("Event " .. event .. " doesn't exist.")
        evs[event] = { }
        return
    end
    for listener in pairs(evs[event]) do
        listener(...)
    end
end

return events
