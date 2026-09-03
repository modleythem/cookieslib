require("cookies")

function love.load()
    addCookie = require("example/test")
end

local hold = false

function love.update(dt)
    if love.keyboard.isDown("a") then
        if not hold then
            hold = true
            addCookie()
        end
    else
        hold = false
    end

    cookies.update(dt)
end

function love.draw()
    cookies.draw()
end
