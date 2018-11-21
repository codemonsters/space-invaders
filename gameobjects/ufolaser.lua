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
    local o = {
        active = true,
        frame_num = 1, -- alternaremos entre 1 y 2 para animar el disparo
        frame_elapsed_time = 0, -- el tiempo que llevamos dibujando este frame
        frame_max_time = 0.07 -- el tiempo que mostraremos cada frame
    }
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

    -- actualizamos el frame
    self.frame_elapsed_time = self.frame_elapsed_time + dt
    if self.frame_elapsed_time >= self.frame_max_time then
        self.frame_elapsed_time = self.frame_elapsed_time % self.frame_max_time
        self.frame_num = self.frame_num + 1
        if self.frame_num > 2 then
            self.frame_num = 1
        end
    end
end

function UfoLaser:draw()
    love.graphics.draw(atlas, self.base_quads[self.frame_num], self.x, self.y)
end

return UfoLaser