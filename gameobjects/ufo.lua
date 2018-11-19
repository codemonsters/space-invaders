local Ufo = {
    height = 8
}

Ufo.__index = Ufo

function Ufo.new(type)
    local o = {
        x = 0,
        y = 0
    }
    setmetatable(o, Ufo) -- la clase Ufo será la metatabla del nuevo objeto que estamos creado
    if type == "octopus" then
        o.quads = {
            love.graphics.newQuad(21, 3, 12, 8, atlas:getDimensions()),
            love.graphics.newQuad(36, 3, 12, 8, atlas:getDimensions())
        }
        o.width = 12
    elseif type == "crab" then
        o.quads = {
            love.graphics.newQuad(51, 3, 11, 8, atlas:getDimensions()),
            love.graphics.newQuad(65, 3, 11, 8, atlas:getDimensions())
        }
        o.width = 11
    elseif type == "squid" then
        o.quads = {
            love.graphics.newQuad(79, 3, 8, 8, atlas:getDimensions()),
            love.graphics.newQuad(91, 3, 8, 8, atlas:getDimensions())
        }
        o.width = 8
    else
        log.fatal("Imposible crear UFO: tipo no válido")
        return nil
    end
    return o
end

function Ufo:load(x, y)
    self.x = x
    self.y = y
end

function Ufo:draw(frame)
    love.graphics.draw(atlas, self.quads[frame], self.x, self.y)
end

function Ufo:update(dt)
    self.state.update(self, dt)
end

return Ufo
