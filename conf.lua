function love.conf(t)
    t.window.title = "Space Invaders"
    -- TODO: Añadir t.window.icon = path/hacia/la/imagen/icono
    --t.window.height = 256 -- Comentado, lo escalaremos según la resolución de la pantalla
    --t.window.width = 224 -- Comentado, lo escalaremos según la resolución de la pantalla
    t.window.fullscreen = false
    t.version = "11.1" -- La versión de LÖVE para la cual fue desarrollado el juego
    t.accelerometerjoystick = false -- Uso del acelerómetro como joystick en iOS y Android

    -- modules
    t.modules.joystick = false -- No necesitamos el módulo joystick
    t.modules.physics = false -- No necesitamos el módulo de físicas
end
