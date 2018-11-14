local game = {name = "Juego"}
local ShipClass = require("gameobjects/ship")
local ship = ShipClass:new()

function game.load()
    ship:load(((GAME_WIDTH - ship.width) / 2), GAME_HEIGHT - 20)
end

function game.update(dt)
    -- Actualizamos la posición de la nave
    if ship.moving_left and not ship.moving_right then
        ship.x = ship.x - ship.vx * dt
        if ship.x < 0 then ship.x = 0 end
    elseif ship.moving_right and not ship.moving_left then
        ship.x = ship.x + ship.vx * dt
        if ship.x >= GAME_WIDTH - ship.width then ship.x = GAME_WIDTH - ship.width end
    end
end

function game.draw()
    -- El fondo del mundo
    love.graphics.setBackgroundColor(COLOR_BACKGROUND)
    love.graphics.clear(love.graphics.getBackgroundColor())
    love.graphics.setColor(COLOR_MAIN)
    love.graphics.print("SCORE", 20, 5)
    love.graphics.print("LIVES", 250, 5)
    ship:draw()
end

function game.keypressed(key, scancode, isrepeat)
    if key == "escape" then
        change_screen(require("screens/menu"))
    elseif key == "left" then
        ship.moving_left = true
    elseif key == "right" then
        ship.moving_right = true
    end
end

function game.keyreleased(key, scancode, isrepeat)
    if key == "left" then
        ship.moving_left = false
    elseif key == "right" then
        ship.moving_right = false
    end
end

return game
