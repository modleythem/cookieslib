--- @class cookies.Events
--- Handles event listening throughout the system.
local events = { }

--- @type string?
local ev = nil

--- @type table<string, set<function>>
local evs = { }


--- @type table<string, { fn: function, args: table }[]>
local queue = { }

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
--- @param event string
--- @param ... any?
function events.emit(event, ...)
    local prev = ev

    if not evs[event] then
        print("Event " .. event .. " doesn't exist.")
        evs[event] = { }
        ev = prev
        return
    end
    for listener in pairs(evs[event]) do
        ev = event
        listener(...)
    end

    if queue[event] then
        for _, q in ipairs(queue[event]) do
            q.fn(unpack(q.args))
        end

        queue[event] = nil
    end
    ev = prev
end

--- This function allows you to queue a function call while inside an event. The
--- function will be called at the end of the currently running event.
--- @param func function
function events.queue(func, ...)
    if not ev then
        print("Cannot queue outside of an event's execution.")
        return
    end

    queue[ev] = queue[ev] or {}

    table.insert(queue[ev], { fn = func, args = { ... } })
end

return events
