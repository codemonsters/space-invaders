local menu = {name = "Menú principal"}
local negro = {1, 1, 1, 1}

function menu.load()
end

function menu.update(dt)
end

function menu.draw()
    love.graphics.setBackgroundColor(COLOR_BACKGROUND)
    love.graphics.clear(love.graphics.getBackgroundColor())
    love.graphics.setColor(COLOR_MAIN)
    love.graphics.printf(
        "PLAY SPACE INVADERS\n\nFIRE TO START",
        0,
        math.floor((GAME_HEIGHT - font:getHeight() * 4) / 2 + 0.5),
        GAME_WIDTH,
        "center"
    )
end

function menu.keypressed(key, scancode, isrepeat)
    if key == "space" then
        change_screen(require("screens/game"))
    elseif key == "escape" then
        log.info("Finalizando")
        love.event.quit()
    end
end

function menu.keyreleased(key, scancode, isrepeat)
end

return menu
