local UfoClass = require("gameobjects/ufo")

local Squad = {
    vx = 10 -- velocidad de desplazamiento horizontal
}

Squad.__index = Squad

function Squad.new()
    local o = {}
    o.attackers = {}
    setmetatable(o, Squad) -- La clase Squad será la metatabla del nuevo objeto que estamos creado
    return o
end

function Squad:load()
    local left = 100 -- espacio por la izquierda hasta el centro del primero ufo
    local xdist = (GAME_WIDTH - left * 2) / 10 -- espacio horizontal entre ufos (respecto a sus centros)
    local top = 40 -- espacio libre inicial encima de los ufos de la primera fila
    local ydist = 15 -- espacio vertical entre ufos

    -- Creamos el escuadrón inicial de enemigos
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
end

function Squad:draw()
    for _, ufo in pairs(self.attackers) do
        ufo:draw()
    end
end

return Squad
