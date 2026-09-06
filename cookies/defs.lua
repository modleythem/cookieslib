---- This file is empty and has no real code, it is used to define classes and types
---- for cookieslib in EmmyLua for easy use with Lua language servers for autocomplete,
---- type checks, ect.



--- @class cookies.Transform
--- @field x number
--- @field y number
--- @field r number
--- @field sx number
--- @field sy number




--- components

--- @class cookies.Component
--- @field className string


--- @class cookies.SpriteComponent : cookies.Component
--- @field texture string
--- @field imageTexture love.Image?
--- @field cacheTexture boolean
--- @field centered boolean
--- @field offset { x: number, y: number }
--- @field frame integer
--- @field hframes integer
--- @field vframes integer
