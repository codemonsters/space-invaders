local Ship = {
    x,
    y,
    width = 13,
    moving_left,
    moving_right,
    vx = 100 -- La velocidad de desplazamiento de la nave
}

Ship.__index = Ship

function Ship:new()
    local o = {}
    setmetatable(o, Ship)   -- La clase Ship será la metatabla del nuevo objeto que estamos creado
    return o
end

function Ship:load(x, y)
    self.x = x
    self.y = y
    self.moving_left = false
    self.moving_right = false
    self.quad = love.graphics.newQuad(36, 18, 13, 8, atlas:getDimensions())
end

function Ship:draw()
    love.graphics.draw(atlas, self.quad, self.x, self.y)
end

return Ship