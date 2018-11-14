local Cannon = {
    width = 13,
    vx = 100 -- La velocidad de desplazamiento de la nave
}

Cannon.__index = Cannon

function Cannon.new()
    local o = {}
    setmetatable(o, Cannon)   -- La clase Cannon será la metatabla del nuevo objeto que estamos creado
    return o
end

function Cannon
:load(x, y)
    self.x = x
    self.y = y
    self.moving_left = false
    self.moving_right = false
    self.quad = love.graphics.newQuad(36, 18, 13, 8, atlas:getDimensions())
end

function Cannon
:draw()
    love.graphics.draw(atlas, self.quad, self.x, self.y)
end

return Cannon