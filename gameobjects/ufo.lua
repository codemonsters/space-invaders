local Ufo = {
    max_time_exploding = 0.4, -- el tiempo que durará la explosión del ufo antes de desaparecer
    height = 8,
    base_quads = {
        octopus1 = love.graphics.newQuad(21, 3, 12, 8, atlas:getDimensions()),
        octopus2 = love.graphics.newQuad(36, 3, 12, 8, atlas:getDimensions()),
        crab1 = love.graphics.newQuad(51, 3, 11, 8, atlas:getDimensions()),
        crab2 = love.graphics.newQuad(65, 3, 11, 8, atlas:getDimensions()),
        squid1 = love.graphics.newQuad(79, 3, 8, 8, atlas:getDimensions()),
        squid2 = love.graphics.newQuad(91, 3, 8, 8, atlas:getDimensions()),
        exploding = love.graphics.newQuad(102, 3, 13, 8, atlas:getDimensions()),
    },
    states = {
        normal = {
            update = function(self, dt, squad_translate_x, squad_translate_y)
                self.x = self.x + squad_translate_x
                self.y = self.y + squad_translate_y
            end,
            draw = function(self, frame)
                love.graphics.draw(atlas, self.quads[frame], self.x, self.y)
            end
        },
        shot_received = {
            update = function(self, dt, squad_translate_x, squad_translate_y)
                self.time_exploding = 0 -- tiempo transcurrido desde el impacto
                self.x = self.x + squad_translate_x
                self.y = self.y + squad_translate_y
                self.state = self.states.exploding
            end,
            draw = function(self, frame)
                love.graphics.draw(atlas, self.quads[frame], self.x, self.y)
            end
        },
        exploding = {
            update = function(self, dt, squad_translate_x, squad_translate_y)
                self.time_exploding = self.time_exploding + dt
                if self.time_exploding > self.max_time_exploding then
                    self.state = self.states.dead
                end
                self.x = self.x + squad_translate_x
                self.y = self.y + squad_translate_y
            end,
            draw = function(self, frame)
                love.graphics.draw(atlas, self.base_quads.exploding, self.x, self.y)
            end
        },
        dead = {
            update = function() end,
            draw = function() end
        }
    }
}

Ufo.__index = Ufo

function Ufo.new(type)
    local o = {
        x = 0,
        y = 0,
    }
    setmetatable(o, Ufo) -- la clase Ufo será la metatabla del nuevo objeto que estamos creado
    if type == "octopus" then
        o.quads = {
            Ufo.base_quads.octopus1,
            Ufo.base_quads.octopus2
        }
        o.width = 12
    elseif type == "crab" then
        o.quads = {
            Ufo.base_quads.crab1,
            Ufo.base_quads.crab2
        }
        o.width = 11
    elseif type == "squid" then
        o.quads = {
            Ufo.base_quads.squid1,
            Ufo.base_quads.squid2
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
    self.state = self.states.normal
end

function Ufo:draw(frame)
    self.state.draw(self, frame)
end

function Ufo:update(dt, squad_translate_x, squad_translate_y)
    self.state.update(self, dt, squad_translate_x, squad_translate_y)
end

return Ufo
