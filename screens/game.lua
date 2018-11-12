local game = {name = "Juego"}

function game.load()
    -- TODO: Implementar
end

function game.update(dt)
    -- TODO: Implementar
end

function game.draw()
    -- El fondo del mundo
    love.graphics.setBackgroundColor(COLOR_BACKGROUND)
    love.graphics.clear(love.graphics.getBackgroundColor())
    love.graphics.setColor(COLOR_MAIN)
    love.graphics.print("SCORE", 20, 5)
    love.graphics.print("LIVES", 250, 5)
end

function game.keypressed(key, scancode, isrepeat)
    if key == "escape" then
        change_screen(require("screens/menu"))
    end
end

function game.keyreleased(key, scancode, isrepeat)
    -- TODO: Implementar
end

return game
