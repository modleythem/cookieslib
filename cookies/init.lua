-- cookieslib
-- written by callmemo, 2026

-- class definitions are in defs.lua


--- @class cookies
cookies = {
    events = require("cookies.events")
}

--- @type cookies.Cookie[]
local allCookies = { }

--- @type table<string, love.Image>
local textures = { }

--- @package
--- @param t table
--- @param val any
--- @return integer?
local function tableFind(t, val)
    for i, v in ipairs(t) do
        if v == val then
            return i
        end
    end
    return nil
end

--- @package
--- @param spriteComponent cookies.SpriteComponent
--- @return love.Image
local function getTexture(spriteComponent)
    local image
    if spriteComponent.cacheTexture then
        if not textures[spriteComponent.texture] then
            textures[spriteComponent.texture] = love.graphics.newImage(spriteComponent.texture)
        end

        image = textures[spriteComponent.texture]
    else
        if not spriteComponent.imageTexture then
            spriteComponent.imageTexture = love.graphics.newImage(spriteComponent.texture)
        end
        image = spriteComponent.imageTexture
    end
    assert(image, "Failed to fetch sprite: " .. spriteComponent.texture)

    return image
end


--- Bakes a Cookie from the Dough
--- @param doughPath string
--- @return cookies.Cookie
function cookies.bakeCookie(doughPath)
    local block = love.filesystem.load(doughPath .. ".dough.lua")
    assert(block, "Failed to bake cookie, dough path " .. doughPath .. ".dough.lua not found.")

    local dough = block()

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

        --- @type table<string, cookies.Component[]>
        components = dough.components or { },

        --- @type cookies.Scope
        scope = require("cookies.scope").new(),

        --- @param self cookies.Cookie
        destroy = function (self)
            local index = tableFind(allCookies, self)
            if index then
                if self.scope then
                    self.scope:unsubscribeAll()
                end
                table.remove(allCookies, index)
            else
                print("Cookie not found.")
            end
        end,
    }

    if cookie.components.SpriteComponent then
        for _, sprite in ipairs(cookie.components.SpriteComponent) do
            --- @cast sprite cookies.SpriteComponent
            cookie.scope:on("draw", function ()
                local ox, oy = sprite.offset.x, sprite.offset.y
                local image = getTexture(sprite)

                if sprite.centered then
                    ox = ox + (image:getWidth () / 2)
                    oy = oy + (image:getHeight() / 2)
                end

                love.graphics.draw( image, cookie.transform.x, cookie.transform.y, cookie.transform.r,
                                    cookie.transform.sx, cookie.transform.sy, ox, oy )
            end)
        end
    end

    table.insert(allCookies, cookie)

    return cookie
end


--- @param dt number
function cookies.update(dt)
    cookies.events.emit("update", dt)
end


function cookies.draw()
    cookies.events.emit("draw")
end


return cookies
