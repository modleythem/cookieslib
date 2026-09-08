---- This file is empty and has no real code, it is used to define classes and types for
---- cookieslib in EmmyLua for easy use with Lua language servers for autocomplete, type
---- checks, ect.
--- @meta

--- aliases

--- @alias dict<T> table<string, T>
--- @alias set<T> table<T, true?>



--- cookieslib


--- The "game object" class in cookieslib. All instances of your dough files are
--- Cookies.
--- @class cookies.Cookie
--- @field components dict<set<cookies.Component>>
--- @field transform cookies.Transform
--- @field scope cookies.Scope
--- method definitions in init.lua


--- Handles event listening throughout the system.
--- @class cookies.Events
--- method definitions in events.lua


--- A Scope is an object holding a bunch of event listeners. It allows for automatic
--- unsubscribing of multiple event listeners at once, and dependency management.
--- @class cookies.Scope
--- method definitions in scope.lua


--- Simple data class used to define a cookie's position, scale and rotation.
--- Used for rendering all graphic-type components.
--- @class cookies.Transform
--- @field x number
--- @field y number
--- @field r number
--- @field sx number
--- @field sy number




--- components


--- Can be added onto a Cookie to add functionality to it.
--- @class cookies.Component
--- @field className string
--- @field cookie cookies.Cookie
--- method defintions in components.lua


--- Allows for rendering a sprite at a Cookie's position.
--- @class cookies.SpriteComponent : cookies.Component
--- @field texture string
--- @field imageTexture love.Image?
--- @field cacheTexture boolean
--- @field centered boolean
--- @field offset { x: number, y: number }
--- @field frame integer
--- @field hframes integer
--- @field vframes integer
