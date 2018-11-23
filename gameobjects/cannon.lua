local Cannon = {
    width = 13,
    height = 8,
    vx = 100, -- La velocidad de desplazamiento de la nave
    max_time_exploding = 1.2, -- el tiempo que durará la explosión del cañón
    quad = love.graphics.newQuad(36, 18, 13, 8, atlas:getDimensions()),
    exploding_quads = {
        love.graphics.newQuad(53, 18, 15, 8, atlas:getDimensions()),
        love.graphics.newQuad(69, 18, 16, 8, atlas:getDimensions())
    },
    states = {
        normal = {
            update = function(self, dt)
                if self.moving_left and not self.moving_right then
                    self.x = self.x - self.vx * dt
                    if self.x < 0 then
                        self.x = 0
                    end
                elseif self.moving_right and not self.moving_left then
                    self.x = self.x + self.vx * dt
                    if self.x >= GAME_WIDTH - self.width then
                        self.x = GAME_WIDTH - self.width
                    end
                end
            end,
            draw = function(self)
                love.graphics.draw(atlas, self.quad, self.x, self.y)
            end
        },
        shot_received = {
            update = function(self, dt)
                self.time_exploding = 0 -- tiempo transcurrido desde el impacto
                self.frame_num = 1 -- alternaremos entre 1 y 2 para animar el disparo
                self.frame_elapsed_time = 0 -- el tiempo que llevamos dibujando este frame
                self.frame_max_time = 0.07 -- el tiempo que mostraremos cada frame
                self.state = self.states.exploding
            end,
            draw = function(self)
                love.graphics.draw(atlas, self.quad, self.x, self.y)
            end
        },
        exploding = {
            update = function(self, dt)
                self.time_exploding = self.time_exploding + dt
                if self.time_exploding > self.max_time_exploding then
                    self.state = self.states.dead
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
            end,
            draw = function(self)
                love.graphics.draw(atlas, self.exploding_quads[self.frame_num], self.x, self.y)
            end
        },
        dead = {
            update = function()
            end,
            draw = function()
            end
        }
    }
}

Cannon.__index = Cannon

function Cannon.new()
    local o = {}
    setmetatable(o, Cannon) -- La clase Cannon será la metatabla del nuevo objeto que estamos creado
    return o
end

function Cannon:load(x, y)
    self.x = x
    self.y = y
    self.moving_left = false
    self.moving_right = false
    self.state = self.states.normal
end

function Cannon:update(dt)
    self.state.update(self, dt)
end
function Cannon:draw()
    self.state.draw(self)
end

return Cannon
