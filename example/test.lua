return function()
    local cookie = cookies.bakeCookie("example/test")

    cookie.transform.x = math.random(0, 800)
    cookie.transform.y = math.random(0, 600)

    local spd = 0.5 + 2.5 * math.random() -- lua needs a random float function...
    local lifetime = 0

    cookie.update = function(self, dt)
        lifetime = lifetime + dt
        self.transform.r = self.transform.r + dt * spd
        if lifetime > 2 then
            self:destroy()
        end
    end
end
