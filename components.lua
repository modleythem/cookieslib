--- @class cookies.Component
--- @field private __index table
local Component = { }
Component.__index = Component

local components = {}

--- @param cookie cookies.Cookie
--- @param doughComponent table
--- @param className string?
--- @return cookies.Component
function components.add(cookie, doughComponent, className)
    --- @type cookies.Component
    local comp = setmetatable(doughComponent, Component)
    comp.className = className or comp.className or "Component"
    comp.cookie = cookie

    cookie.components[comp.className] = cookie.components[comp.className] or { }
    cookie.components[comp.className][comp] = true

    comp:initialize()

    return comp
end

local classModules = {
    SpriteComponent = "cookies.comps.sprite",
}

function Component:initialize()
    local module = classModules[self.className]
    assert(module, "unknown component class: " .. self.className)
    require(module).init(self)
end

function Component:destroy()
    local module = classModules[self.className]
    assert(module, "unknown component class: " .. self.className)
    require(module).destroy(self)
    self.cookie.components[self.className][self] = nil
end

return components
