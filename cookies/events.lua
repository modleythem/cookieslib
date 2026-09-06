--- @class cookies.Events
--- Handles event listening throughout the system.
local events = { }

--- @type table<string, table<function, boolean>>
local evs = { }

--- Adds an event listener to a chosen event and returns a function to unsubscribe to
--- set event at will
--- @param event string The name of the event
--- @param listener function The event listener
--- @return function unsubscribe A function to unsubscribe to the event
function events.on(event, listener)
    if not evs[event] then
        evs[event] = { }
    end
    evs[event][listener] = true

    return function () evs[event][listener] = nil end
end

--- Emits an event and calls all of its listeners.
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
