local CannonLaser = {
    width = 1,
    height = 4,
    vy = 220, -- La velocidad con la que se desplaza el disparo
    quad = love.graphics.newQuad(31, 21, 1, 4, atlas:getDimensions())
}

CannonLaser.__index = CannonLaser

function CannonLaser.new()
    local o = {}
    setmetatable(o, CannonLaser)   -- La clase Cannon será la metatabla del nuevo objeto que estamos creado
    return o
end

function CannonLaser:load()
    self.x = 0
    self.y = 0
    self.shooting = false -- true mientras el disparo está activo (volverá a ser false una vez alcance a un enemigo o llegue al borde superior de la pantalla)
end

function CannonLaser:shoot(x_init, y_init)
    self.x = x_init
    self.y = y_init
    self.shooting = true
end

function CannonLaser:update(dt)
    self.y = self.y - self.vy * dt
    if self.y <= -self.height then
        self.shooting = false
    end
end

function CannonLaser:draw()
    love.graphics.draw(atlas, self.quad, self.x, self.y)
end

return CannonLaser