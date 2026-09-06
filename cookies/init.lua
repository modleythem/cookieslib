-- cookieslib
-- written by callmemo, 2026

-- class definitions are in defs.lua


--- @class cookies
cookies = {
    events = require("cookies.events")
}

--- @type table<cookies.Cookie, boolean>
local allCookies = { }

--- @type table<string, love.Image>
local textures = { }


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


--- Bakes a Cookie from a select Dough file.
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
            cookies.destroyCookie(self)
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

    allCookies[cookie] = true

    return cookie
end

--- Deletes a select Cookie.
--- @param cookie cookies.Cookie
function cookies.destroyCookie(cookie)
    if not allCookies[cookie] then
        print("Cookie already in deletion or not in the scene.")
        return
    end
    cookie.scope:unsubscribeAll()
    allCookies[cookie] = nil
end

--- Emits the `"update"` event for the entirety of the system.
--- @param dt number
function cookies.update(dt)
    cookies.events.emit("update", dt)
end

--- Emits the `"draw"` event for the entirety of the system and allows
--- some components to render.
function cookies.draw()
    cookies.events.emit("draw")
end

--- Cleans the internal texture cache. Has no effects on SpriteComponents
--- with `cacheTexture` set to `false`.
function cookies.clearTextureCache()
    textures = { }
end


return cookies
