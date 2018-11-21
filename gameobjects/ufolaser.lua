local UfoLaser = {
    width = 3,
    height = 7,
    vy = 120, -- La velocidad con la que se desplaza el disparo
    base_quads = {
        love.graphics.newQuad(100, 19, 3, 7, atlas:getDimensions()),
        love.graphics.newQuad(105, 19, 3, 7, atlas:getDimensions())
    }
}

UfoLaser.__index = UfoLaser

function UfoLaser.new(x, y)
    local o = { active = true }
    o.x = x
    o.y = y
    setmetatable(o, UfoLaser)   -- La clase Cannon será la metatabla del nuevo objeto que estamos creado
    return o
end

function UfoLaser:update(dt)
    self.y = self.y + self.vy * dt
    if self.y > GAME_HEIGHT then
        self.active = false
    end
end

function UfoLaser:draw()
    love.graphics.draw(atlas, self.base_quads[1], self.x, self.y)
end

return UfoLaser