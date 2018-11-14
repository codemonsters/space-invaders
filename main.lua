log = require "modules/log/log" -- https://github.com/rxi/log.lua
local push = require "modules/push/push" -- https://github.com/Ulydev/push

GAME_WIDTH, GAME_HEIGHT = 384, 216 -- Usamos una resolución 16:9 divisible por 8 próxima a la del original (224x256): https://pacoup.com/2011/06/12/list-of-true-169-resolutions/

COLOR_BACKGROUND = {0.1, 0.1, 0.1}
COLOR_MAIN = {1, 1, 1}
COLOR_ACCENT = {0.2, 0.94901960784314, 0.57647058823529}

function love.load()
    log.level = "trace" -- trace / debug / info / warn / error / fatal
    log.info("Iniciando")

    --love.graphics.setDefaultFilter("nearest", "nearest") -- Cambiamos el filtro usado durante el escalado para evitar imágenes borrosas
    love.graphics.setDefaultFilter("nearest", "linear") -- Cambiamos el filtro usado durante el escalado para evitar imágenes borrosas

    -- atlas será la textura que contiene todas las imágenes. Una optimización no implementada es utilizar un bitmap font incluido en esta misma imagen
    atlas = love.graphics.newImage("assets/8593.png") -- Créditos y datos de contacto de los autores en la propia imagen: https://www.spriters-resource.com/arcade/spaceinv/sheet/8593/
    
    font = love.graphics.newFont("assets/fonts/space_invaders.ttf", 7) -- Copyright kylemaoin 2010: https://fonts2u.com/space-invaders-regular.font
    love.graphics.setFont(font)

    -- Escalado de la ventana del juego (a resolución nativa en pantalla completa y con una pequeña reducción si estamos en una ventana)
    local window_width, window_height = love.window.getDesktopDimensions()
    if love.window.getFullscreen() then
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
    change_screen(require("screens/menu"))
end

function love.update(dt)
    screen.update(dt)
end

function love.draw()
    push:start()
    screen.draw()
    push:finish()
end

function love.keypressed(key, scancode, isrepeat)
    screen.keypressed(key, scancode, isrepeat)
end

function love.keyreleased(key, scancode, isrepeat)
    screen.keyreleased(key, scancode, isrepeat)
end

function love.resize(w, h)
    log.debug("Redimensionando ventana a " .. w .. " x " .. h .. "px")
    push:resize(w, h)
end

function change_screen(new_screen)
    screen = new_screen
    log.debug("Cargando pantalla: " .. screen.name)
    screen.load()
end
