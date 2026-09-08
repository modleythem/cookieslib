
--- @type dict<love.Image>
local textures = { }

require("cookies.events").on("clearTextureCache", function ()
    for _, t in pairs(textures) do
        t:release()
    end
    textures = { }
end)


--- @package
--- @param spriteComp cookies.SpriteComponent
--- @return love.Image
local function getTexture(spriteComp)
    local image
    local path = spriteComp.texture
    if spriteComp.cacheTexture then
        if not textures[path] then
            textures[path] = love.graphics.newImage(path)
        end

        image = textures[path]
    else
        if not spriteComp.imageTexture then
            spriteComp.imageTexture = love.graphics.newImage(path)
        end
        image = spriteComp.imageTexture
    end
    assert(image, "Failed to fetch sprite: " .. path)

    return image
end

return {
    --- @param comp cookies.SpriteComponent
    init = function (comp)
        local cookie = comp.cookie
        cookie.scope:on("draw", function ()
            local ox, oy = comp.offset.x, comp.offset.y
            local image = getTexture(comp)

            if comp.centered then
                ox = ox + (image:getWidth () / 2)
                oy = oy + (image:getHeight() / 2)
            end

            love.graphics.draw( image, cookie.transform.x, cookie.transform.y,
                                cookie.transform.r, cookie.transform.sx,
                                cookie.transform.sy, ox, oy )
        end, function () return comp end)
    end,

    --- @param comp cookies.SpriteComponent
    destroy = function (comp)
        if not comp.cacheTexture and comp.imageTexture then
            comp.imageTexture:release()
        end
    end
}