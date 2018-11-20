local game = {name = "Juego"}
local CannonClass = require("gameobjects/cannon")
local cannon = CannonClass.new()
local CannonLaserClass = require("gameobjects/cannonlaser")
local cannonLaser = CannonLaserClass.new()
local SquadClass = require("gameobjects/squad")
local squad = SquadClass.new()
local fire_pressed

function game.load()
    fire_pressed = false
    cannon:load((GAME_WIDTH - cannon.width) / 2, GAME_HEIGHT - 20)
    cannonLaser:load()
    squad:load()
end

function game.update(dt)
    -- actualizamos la posición de la nave
    if cannon.moving_left and not cannon.moving_right then
        cannon.x = cannon.x - cannon.vx * dt
        if cannon.x < 0 then
            cannon.x = 0
        end
    elseif cannon.moving_right and not cannon.moving_left then
        cannon.x = cannon.x + cannon.vx * dt
        if cannon.x >= GAME_WIDTH - cannon.width then
            cannon.x = GAME_WIDTH - cannon.width
        end
    end

    -- actualizamos la posición del escuadrón de enemigos
    squad:update(dt)

    -- disparo desde el cañón
    if cannonLaser.shooting then
        cannonLaser:update(dt)
        -- ¿hemos alcanzado a algún enemigo del escuadrón?
        for i, ufo in pairs(squad.attackers) do
            if ufo.state == ufo.states.normal and aabb_collision(cannonLaser.x, cannonLaser.y, cannonLaser.width, cannonLaser.height, ufo.x, ufo.y, ufo.width, ufo.height) then
                -- sí, le hemos dado
                ufo.state = ufo.states.shot_received
                cannonLaser.shooting = false
                break
            end
        end
    elseif fire_pressed then
        -- ¡fuego! iniciar nuevo disparo
        cannonLaser:shoot(cannon.x + cannon.width / 2, cannon.y)
    end
end

-- comprueba colisión entre dos rectángulos / axis aligned bounding boxes
function aabb_collision(x1, y1, w1, h1, x2, y2, w2, h2)
    return x1 < x2 + w2 and x2 < x1 + w1 and y1 < y2 + h2 and y2 < y1 + h1
end

function game.draw()
    -- el fondo del mundo
    love.graphics.setBackgroundColor(COLOR_BACKGROUND)
    love.graphics.clear(love.graphics.getBackgroundColor())
    love.graphics.setColor(COLOR_MAIN)
    love.graphics.print("SCORE", 20, 5)
    love.graphics.print("LIVES", 250, 5)
    if cannonLaser.shooting then
        cannonLaser:draw()
    end
    squad:draw()
    cannon:draw()
end

function game.keypressed(key, scancode, isrepeat)
    if key == "escape" then
        change_screen(require("screens/menu"))
    elseif key == "left" then
        cannon.moving_left = true
    elseif key == "right" then
        cannon.moving_right = true
    elseif key == "space" then
        fire_pressed = true
    end
end

function game.keyreleased(key, scancode, isrepeat)
    if key == "left" then
        cannon.moving_left = false
    elseif key == "right" then
        cannon.moving_right = false
    elseif key == "space" then
        fire_pressed = false
    end
end

return game
