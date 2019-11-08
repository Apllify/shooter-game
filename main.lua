push = require "push"
Class = require "class"

require "Character"
require "Spawner"

window_width = 1920
window_height = 1080

virtual_width = 432
virtual_height = 243


CHARACTER_SPEED = 200
CHARACTER_WIDTH = 10
CHARACTER_HEIGHT = 10
CHARACTER_HEALTH = 3

PROJECTILE_SPEED = 250
PROJECTILE_WIDTH = 2
PROJECTILE_HEIGHT = 2

ENEMY_SPEED = 100
ENEMY_WIDTH = 7
ENEMY_HEIGHT = 7
ENEMY_HEALTH = 4

ENEMY_SPAWNRATE = 3

playerScore = 0

gameState = "menu"
local selectedOption = 0

local character = Character()
local spawner = Spawner(character)


function love.load()
    love.window.setTitle("Character Control Test")

    love.graphics.setDefaultFilter("nearest", "nearest")

    push:setupScreen(virtual_width, virtual_height, window_width, window_height,{
        fullscreen = true,
        resizable = true,
        vsync = true
    })


    score_font = love.graphics.newFont("font.ttf", 25)
    menu_font = love.graphics.newFont("menu_font.ttf", 20)

    love.graphics.setDefaultFilter("nearest", "nearest")

    love.keyboard.keysPressed = {}
end

function love.resize(w, h)
    push:resize(w, h)
end





function love.keypressed(key)

    love.keyboard.keysPressed[key] = true

    if key == "escape" then
        love.event.quit()
    end
end

function love.keyboard.wasPressed(key)
    if love.keyboard.keysPressed[key] == true then
        return true
    else
        return false
    end
end

function love.endGame()
    local character = Character()
    local spawner = Spawner(character)

    gameState = "end"
end

function love.update(dt)
    if gameState == "play" then
        character:update(dt)
        spawner:update(dt)

    elseif gameState == "menu" then
        if love.keyboard.wasPressed("up") then
            selectedOption = 0
            
        elseif love.keyboard.wasPressed("down") then
            selectedOption = 1

        end

        if love.keyboard.wasPressed("return") then
            if selectedOption == 0 then
                gameState = "play"

            elseif selectedOption == 1 then
                love.event.quit()

            end
        end

    elseif gameState == "end" then
        if love.keyboard.wasPressed("return") then
            character = Character()
            spawner = Spawner(character)
            
            gameState = "menu"
            playerScore = 0
            
        end
    end

    love.keyboard.keysPressed = {}
end


function love.draw()
    push:start() 

    love.graphics.clear(0.5, 0, 1, 1)

    if gameState == "play" then 
        character:render()
        spawner:render()

        love.graphics.setFont(score_font)
        love.graphics.printf(tostring(playerScore), 0, 10, virtual_width, "center")

        love.graphics.setFont(menu_font)
        love.graphics.setColor(1, 0, 0)
        love.graphics.print(tostring(character.health), virtual_width - 15, virtual_height - 25)
        love.graphics.setColor(1, 1, 1)
    
    elseif gameState == "menu" then
        love.graphics.setFont(menu_font)

        love.graphics.printf("PLAY", 0, virtual_height / 2 - 25, virtual_width, "center")
        love.graphics.printf("EXIT", 0, virtual_height / 2 + 25, virtual_width, "center")

        if selectedOption == 0 then
            love.graphics.setColor(1, 0, 0)

            love.graphics.rectangle("fill", 0, virtual_height / 2 - 25, 100, 15)
            love.graphics.rectangle("fill", virtual_width - 100, virtual_height / 2 - 25, 100, 15)

            love.graphics.setColor(1, 1, 1)

        elseif selectedOption == 1 then
            love.graphics.setColor(1, 0, 0)

            love.graphics.rectangle("fill", 0, virtual_height / 2 + 25, 100, 15)
            love.graphics.rectangle("fill", virtual_width - 100, virtual_height / 2 + 25, 100, 15)

            love.graphics.setColor(1, 1, 1)
        end

    elseif gameState == "end" then
        love.graphics.setFont(menu_font)

        love.graphics.printf("Sorry, you died. (press enter for respawn)", 0, 50, virtual_width, "center")
        love.graphics.printf("Your score was : " .. playerScore, 0, virtual_height/2, virtual_width, "center")
    end

    push:finish()
end