--- @class cookies.Component
local Component = { }


function Component.from(component)
    return setmetatable(component, Component)
end

function Component:destroy()
    
end
