log = require "modules/log/log" -- https://github.com/rxi/log.lua
local push = require "modules/push/push" -- https://github.com/Ulydev/push

GAME_WIDTH, GAME_HEIGHT = 384, 216 -- Usamos una resolución 16:9 divisible por 8 próxima a la del original (224x256): https://pacoup.com/2011/06/12/list-of-true-169-resolutions/
COLOR_BACKGROUND = {0.1, 0.1, 0.1}
COLOR_MAIN = {0.2, 0.94901960784314, 0.57647058823529}

function love.load()
    log.level = "trace" -- trace / debug / info / warn / error / fatal
    log.info("Iniciado programa")

    love.graphics.setDefaultFilter("nearest", "nearest") -- Cambiamos el filtro usado durante el escalado para evitar imágenes borrosas
    font = love.graphics.newFont("assets/fonts/space_invaders.ttf", 7)
    love.graphics.setFont(font) -- Copyright kylemaoin 2010: https://fonts2u.com/space-invaders-regular.font

    -- Escalado de la ventana del juego (a resolución nativa si estamos en pantalla completa y con una pequeña reducción si estamos en una ventana)
    local window_width, window_height = love.window.getDesktopDimensions()
    if love.window.getFullscreen() == true then
        log.debug("Escalando en pantalla completa")
    else
        log.debug("Escalando dentro de una ventana")
        window_width, window_height = window_width * .7, window_height * .7
    end
    push:setupScreen(
        GAME_WIDTH,
        GAME_HEIGHT,
        window_width,
        window_height,
        {
            fullscreen = love.window.getFullscreen(),
            resizable = true,
            canvas = false,
            pixelperfect = false,
            highdpi = true,
            streched = false
        }
    )

    math.randomseed(os.time())

    log.info("Juego cargado")
end

function love.update(dt)
    -- TODO: Implementar
end

function love.draw()
    push:start()
    love.graphics.setBackgroundColor(COLOR_BACKGROUND)
    love.graphics.clear(love.graphics.getBackgroundColor())
    love.graphics.setColor(COLOR_MAIN)

    -- indicadores de prueba en esquinas superior izquierda e inferior derecha
    love.graphics.line(0, 0, 10, 0)
    love.graphics.line(0, 0, 0, 10)
    love.graphics.line(GAME_WIDTH - 1, GAME_HEIGHT - 1, GAME_WIDTH - 11, GAME_HEIGHT - 1)
    love.graphics.line(GAME_WIDTH - 1, GAME_HEIGHT - 1, GAME_WIDTH - 1, GAME_HEIGHT - 11)

    love.graphics.printf("¡HOLA MUNDO!", 0, (GAME_HEIGHT - font:getHeight()) / 2, GAME_WIDTH, "center")
    push:finish()
end

function love.keypressed(key, scancode, isrepeat)
    -- TODO: Implementar
end

function love.keyreleased(key, scancode, isrepeat)
    -- TODO: Implementar
end

function love.resize(w, h)
    log.debug("Redimensionando ventana a " .. w .. " x " .. h .. "px")
    push:resize(w, h)
end
