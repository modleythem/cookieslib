-- cookieslib
-- written by callmemo, 2026

-- class definitions are in defs.lua


--- @class cookies
cookies = { }

local components = require("cookies.components")
local events = require("cookies.events")

--- @type set<cookies.Cookie>
local scene = { }




--- Bakes a Cookie from a select Dough file.
--- @param doughPath string
--- @return cookies.Cookie
function cookies.bakeCookie(doughPath)
    local block, err = love.filesystem.load(doughPath .. ".dough.lua")
    if err or not block then
        error("Failed to load dough file " .. doughPath .. ".dough.lua: " .. err)
    end

    local dough = block()
    assert(type(dough) == "table", "Failed to load dough file " .. doughPath .. ".dough.lua: Dough should be a table")

    --- @class cookies.Cookie
    local cookie = {
        --- @type cookies.Transform
        transform = dough.transform or {
            x = 0,
            y = 0,
            sx = 1,
            sy = 1,
            r = 0
        },

        --- @type table<string, set<cookies.Component>>
        components = { },

        --- @type cookies.Scope
        scope = require("cookies.scope").new(),

        --- @param self cookies.Cookie
        destroy = function (self)
            cookies.destroyCookie(self)
        end,
    }

    for className, comps in pairs(dough.components) do
        for _, comp in ipairs(comps) do
            components.add(cookie, comp, className)
        end
    end

    scene[cookie] = true

    return cookie
end

--- Deletes a select Cookie.
--- @param cookie cookies.Cookie
function cookies.destroyCookie(cookie)
    if not scene[cookie] then
        print("Cookie already in deletion or not in the scene.")
        return
    end
    for className, comps in pairs(cookie.components) do
        for comp in pairs(comps) do
            comp:destroy()
        end
    end
    cookie.scope:unsubscribeAll()
    scene[cookie] = nil
end

--- Emits the `"update"` event for the entirety of the system.
--- @param dt number
function cookies.update(dt)
    events.emit("update", dt)
end

--- Emits the `"draw"` event for the entirety of the system and allows
--- some components to render.
function cookies.draw()
    events.emit("draw")
end


return cookies
