--- @class cookies.Component
--- @field private __index table
local Component = { }
Component.__index = Component

local components = {}

--- @type dict<string>
local classModules = {
    Component = "",
    SpriteComponent = "cookies.comps.sprite",
}

--- @package
--- @param comp cookies.Component
local function initialize(comp)
    local module = classModules[comp.className]
    assert(module, "unknown component class: " .. comp.className)
    require(module).init(comp)
end


--- Destroys the Component and unlists it from its Cookie's components.
function Component:destroy()
    local module = classModules[self.className]
    assert(module, "unknown component class: " .. self.className)
    require(module).destroy(self)
    self.cookie.components[self.className][self] = nil
end

--- Add and initialize a component to a Cookie.
--- 
--- @param cookie cookies.Cookie Cookie to add the Component.
--- @param doughComponent table Base data dough table.
--- @param className string? Component type.
--- @return cookies.Component
function components.add(cookie, doughComponent, className)
    --- @type cookies.Component
    local comp = setmetatable(doughComponent, Component)
    comp.className = className or comp.className or "Component"
    comp.cookie = cookie

    cookie.components[comp.className] = cookie.components[comp.className] or { }
    cookie.components[comp.className][comp] = true

    initialize(comp)

    return comp
end


return components
