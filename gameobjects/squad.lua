local UfoClass = require("gameobjects/ufo")

local Squad = {}
Squad.__index = Squad

function Squad.new()
    local o = {
        drop_per_turn = 8, -- distancia que los ovnis descenderan cada vez que alcancen el lateral de la pantalla
        min_speed = 11 , -- veloicdad mínima (será la inicial del escuadrón, cuando todavía no hayamos destruido ningún enemigo)
        max_speed = 80, -- velocidad máxima (se alcanzará cuando solo quede un enemigo en el escuadrón)
        frame_change_speed_factor = 10, -- mayor valor para mantener el mismo frame durante más tiempo
        vx = function(self)
            -- la velocidad horizontal será mayor cuantos menos ovnis queden
            return self.direction *
                (self.min_speed +
                    (self.max_speed - self.min_speed) * (self.attackers_init_count - #self.attackers) *
                        ((self.attackers_init_count + 1) / (self.attackers_init_count)) /
                        (self.attackers_init_count))
        end,
        vy = function(self)
            -- igualmente la velocidad vertical dependerá del tamaño del escuadrón
            return self.min_speed +
                (self.max_speed - self.min_speed) * (self.attackers_init_count - #self.attackers) *
                    ((self.attackers_init_count + 1) / (self.attackers_init_count)) /
                    (self.attackers_init_count)
        end,
        frame_max_time = function(self)
            return self.frame_change_speed_factor / math.abs(self:vx())
        end,
        states = {
            moving_sideways = {
                update = function(self, dt)
                    for i, ufo in pairs(self.attackers) do
                        if ufo.state == ufo.states.dead then
                            table.remove(self.attackers, i)
                            self:refresh_first_line_ufo_list()
                        else
                            ufo:update(dt, self:vx() * dt, 0)   -- args: dt, translate_x, translate_y
                            if ufo.state == ufo.states.normal and (ufo.x > GAME_WIDTH - ufo.width or ufo.x <= 0) then
                                self.next_state = self.states.start_moving_down
                            end
                        end
                    end
                end
            },
            start_moving_down = {
                update = function(self, dt)
                    self.vertical_pixels_traveled = 0
                    self.next_state = self.states.moving_down
                end
            },
            moving_down = {
                update = function(self, dt)
                    self.vertical_pixels_traveled = self.vertical_pixels_traveled + self:vy() * dt
                    for i, ufo in pairs(self.attackers) do
                        if ufo.state == ufo.states.dead then
                            table.remove(self.attackers, i)
                        else
                            ufo:update(dt, 0, self:vy() * dt)   -- args: dt, translate_x, translate_y
                        end
                    end
                    if self.vertical_pixels_traveled >= self.drop_per_turn then
                        self.direction = -1 * self.direction
                        self.next_state = self.states.moving_sideways
                    end
                end
            }
        }
    }
    o.attackers = {}
    setmetatable(o, Squad) -- La clase Squad será la metatabla del nuevo objeto que estamos creado
    return o
end

function Squad:load()
    local left = 100 -- espacio por la izquierda hasta el centro del primero ufo
    local xdist = (GAME_WIDTH - left * 2) / 10 -- espacio horizontal entre ufos (respecto a sus centros)
    local top = 40 -- espacio libre inicial encima de los ufos de la primera fila
    local ydist = 15 -- espacio vertical entre ufos
    self.direction = 1 -- 1 derecha, -1 izquierda (lo usaremos como factor de una multiplicación, para sumar o restar a la hora de calcular desplazamientos)
    self.frame = 1 -- alternaremos entre 1 y 2 para animar todos los ovnis al mismo tiempo
    self.frame_elapsed_time = 0 -- el tiempo que llevamos dibujando este frame

    self.state = self.states.moving_sideways -- establecemos el estado inicial del escuadrón
    self.next_state = self.state

    -- Eliminamos cualquier escuadrón de enemigos que pudiese existir tras una partida previa
    self.attackers = {}

    -- creamos el escuadrón inicial de enemigos
    for f = 0, 4 do
        for i = 1, 11 do
            local ufo
            if f < 1 then
                ufo = UfoClass.new("squid")
            elseif f < 3 then
                ufo = UfoClass.new("crab")
            else
                ufo = UfoClass.new("octopus")
            end
            ufo:load(left - ufo.width / 2 + xdist * (i - 1), top + ydist * f)
            table.insert(self.attackers, ufo)
        end
    end
    self.attackers_init_count = #self.attackers

    self:refresh_first_line_ufo_list()
end

--  determinamos el grupo de ovnis que no tienen ningún otro debajo (serán los que puedan disparar)
function Squad:refresh_first_line_ufo_list()
    local f = {}
    for _, ufo_a in pairs(self.attackers) do
        if ufo_a.state == ufo_a.states.normal then
            local has_ufo_below = false
            for _, ufo_b in pairs(self.attackers) do
                if ufo_a.x < ufo_b.x + ufo_b.width and ufo_b.x < ufo_a.x + ufo_a.width and ufo_a.y < ufo_b.y then
                    has_ufo_below = true
                    break
                end
            end
            if has_ufo_below == false then
                table.insert(f, ufo_a)
            end
        end
    end
    self.first_line_ufos = f
    log.trace("Número de UFOS en primera fila = " .. #self.first_line_ufos)
end

function Squad:draw()
    for _, ufo in pairs(self.attackers) do
        ufo:draw(self.frame)
    end
end

function Squad:update(dt)
    -- Actualizaremos el escuadrón según el estado en el que esté
    self.state.update(self, dt)
    if self.state ~= self.next_state then
        self.state = self.next_state
    end

    -- actualizamos el frame que utilizamos para dibujar cada ufo. Lo hacemos de forma proporcional a la velocidad con la que se mueven
    self.frame_elapsed_time = self.frame_elapsed_time + dt
    if self.frame_elapsed_time >= self:frame_max_time() then
        self.frame_elapsed_time = self.frame_elapsed_time % self:frame_max_time()
        self.frame = self.frame + 1
        if self.frame > 2 then
            self.frame = 1
        end
    end
end

return Squad
