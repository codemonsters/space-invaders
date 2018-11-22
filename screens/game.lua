local game = {name = "Juego"}
local CannonClass = require("gameobjects/cannon")
local cannon = CannonClass.new()
local CannonLaserClass = require("gameobjects/cannonlaser")
local cannonLaser = CannonLaserClass.new()
local SquadClass = require("gameobjects/squad")
local squad = SquadClass.new()
local UfoLaserClass = require("gameobjects/ufolaser")
local ufoLasers
local min_time_between_ufo_shots = 0.2   -- en segundos
local max_time_between_ufo_shots = 3   -- en segundos
local fire_pressed
local lives

function game.load()
    score = 0
    lives = 3
    fire_pressed = false
    cannon:load((GAME_WIDTH - cannon.width) / 2, GAME_HEIGHT - 20)
    cannonLaser:load()
    squad:load()
    
    ufoLasers = {}
    time_since_last_shot = 0
    time_next_shot = randomFloat(min_time_between_ufo_shots, max_time_between_ufo_shots)
end

function game.update(dt)
    -- actualizamos la posición de la nave
    cannon:update(dt)
    if cannon.state == cannon.states.shot_received or cannon.state == cannon.states.exploding then
        return  -- congelamos el estado del juego después de haber sido alcanzados
    elseif cannon.state == cannon.states.dead then
        ufoLasers = {}  -- eliminamos todos los disparos restantes de la pantalla antes de renacer
        cannonLaser.active = false  -- eliminamos también nuestro disparo
        lives = lives - 1
        if lives == 0 then
            game_over()
        end
        cannon.state = cannon.states.normal
    end
    -- actualizamos la posición del escuadrón de enemigos
    squad:update(dt)

    -- disparo desde el cañón
    if cannonLaser.shooting then
        cannonLaser:update(dt)
        -- ¿hemos alcanzado a algún enemigo del escuadrón?
        for i, ufo in pairs(squad.attackers) do
            if ufo.state == ufo.states.normal and aabb_collision(cannonLaser.x, cannonLaser.y, cannonLaser.width, cannonLaser.height, ufo.x, ufo.y, ufo.type.width, ufo.height) then
                -- sí, le hemos dado
                score = score + ufo.type.points
                ufo.state = ufo.states.shot_received
                cannonLaser.shooting = false
                break
            end
        end
    elseif fire_pressed then
        -- ¡fuego! iniciar nuevo disparo del cañón
        cannonLaser:shoot(cannon.x + cannon.width / 2, cannon.y)
    end

    -- disparos desde los ovnis
    time_since_last_shot = time_since_last_shot + dt
    if time_since_last_shot >= time_next_shot and #squad.first_line_ufos > 0 then
        -- disparamos desde una de las naves de la primera línea
        local ufo_shooting = squad.first_line_ufos[math.random(1, #squad.first_line_ufos)]
        table.insert(ufoLasers, UfoLaserClass.new(ufo_shooting.x + ufo_shooting.type.width / 2, ufo_shooting.y))
        time_since_last_shot = 0
        time_next_shot = randomFloat(min_time_between_ufo_shots, max_time_between_ufo_shots)
    end
    for i, ufoLaser in pairs(ufoLasers) do
        ufoLaser:update(dt)
        if ufoLaser.active == false then
            table.remove(ufoLasers, i)
        elseif aabb_collision(ufoLaser.x, ufoLaser.y, ufoLaser.width, ufoLaser.height, cannon.x, cannon.y, cannon.width, cannon.height) then
            cannon.state = cannon.states.shot_received
            ufoLaser.active = false
        end

    end
end

function draw_hud()
    love.graphics.setColor(COLOR_MAIN)
    love.graphics.printf("SCORE",
        0,
        font:getHeight(),
        math.floor(GAME_WIDTH / 3 + 0.5),
        "center"
    )
    love.graphics.printf(score,
        0,
        2 * font:getHeight(),
        math.floor(GAME_WIDTH / 3 + 0.5),
        "center"
    )
    love.graphics.printf("HI-SCORE",
        math.floor(GAME_WIDTH / 3 + 0.5),
        font:getHeight(),
        math.floor(GAME_WIDTH / 3 + 0.5),
        "center"
    )
    love.graphics.printf(high_score,
        math.floor(GAME_WIDTH / 3 + 0.5),
        2 * font:getHeight(),
        math.floor(GAME_WIDTH / 3 + 0.5),
        "center"
    )
    love.graphics.printf("LIVES",
        math.floor(GAME_WIDTH * 2 / 3 + 0.5),
        font:getHeight(),
        math.floor(GAME_WIDTH / 3 + 0.5),
        "center"
    )

    love.graphics.printf(lives,
        math.floor(GAME_WIDTH * 2 / 3 + 0.5),
        2 * font:getHeight(),
        math.floor(GAME_WIDTH / 3 + 0.5),
        "center"
    )

end

function game.draw()
    -- el fondo del mundo
    love.graphics.setBackgroundColor(COLOR_BACKGROUND)
    love.graphics.clear(love.graphics.getBackgroundColor())
    
    draw_hud()

    if cannonLaser.shooting then
        cannonLaser:draw()
    end

    for i, ufoLaser in pairs(ufoLasers) do
        ufoLaser:draw()
    end

    squad:draw()
    cannon:draw()
end

function game.keypressed(key, scancode, isrepeat)
    if key == "escape" then
        game_over()
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

function game_over()
    if score > high_score then
        high_score = score
    end
    change_screen(require("screens/menu"))
end

-- comprueba colisión entre dos rectángulos / axis aligned bounding boxes
function aabb_collision(x1, y1, w1, h1, x2, y2, w2, h2)
    return x1 < x2 + w2 and x2 < x1 + w1 and y1 < y2 + h2 and y2 < y1 + h1
end

function randomFloat(min, max)
	local range = max - min
	local offset = range * math.random()
	return min + offset
end

return game
