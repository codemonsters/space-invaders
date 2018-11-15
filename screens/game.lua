local game = {name = "Juego"}
local CannonClass = require("gameobjects/cannon")
local cannon = CannonClass.new()
local SquadClass = require("gameobjects/squad")
local squad = SquadClass.new()

function game.load()
    cannon:load((GAME_WIDTH - cannon.width) / 2, GAME_HEIGHT - 20)
    squad:load()
end

function game.update(dt)
    -- Actualizamos la posición de la nave
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
end

function game.draw()
    -- El fondo del mundo
    love.graphics.setBackgroundColor(COLOR_BACKGROUND)
    love.graphics.clear(love.graphics.getBackgroundColor())
    love.graphics.setColor(COLOR_MAIN)
    love.graphics.print("SCORE", 20, 5)
    love.graphics.print("LIVES", 250, 5)
    cannon:draw()
    squad:draw()
end

function game.keypressed(key, scancode, isrepeat)
    if key == "escape" then
        change_screen(require("screens/menu"))
    elseif key == "left" then
        cannon.moving_left = true
    elseif key == "right" then
        cannon.moving_right = true
    end
end

function game.keyreleased(key, scancode, isrepeat)
    if key == "left" then
        cannon.moving_left = false
    elseif key == "right" then
        cannon.moving_right = false
    end
end

return game
