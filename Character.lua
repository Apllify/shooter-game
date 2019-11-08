require "Projectile"

Character = Class{}

function Character:init()
    self.width = CHARACTER_WIDTH
    self.height = CHARACTER_HEIGHT

    self.x = virtual_width /2 - self.width / 2
    self.y = virtual_height / 2 - self.height / 2

    self.speed = CHARACTER_SPEED  

    self.projectiles = {}
    self.projectileCount = 0

    self.health = CHARACTER_HEALTH
    self.invincibilityTimer = 0
end

function Character:damage()
    if self.invincibilityTimer <= 0 then
        self.health = self.health - 1
        self.invincibilityTimer = 1

        if self.health == 0 then
            love.endGame()
        end
    end
end


function Character:update(dt)
    if love.keyboard.isDown("z")then
        self.y = self.y - (self.speed * dt)
    end
    if love.keyboard.isDown("s") then
        self.y = self.y + (self.speed * dt)
    end
    if love.keyboard.isDown("d") then
        self.x = self.x + (self.speed * dt)
    end
    if love.keyboard.isDown("q") then
        self.x = self.x - (self.speed * dt)
    end

    if self.y < 0 then
        self.y = 0
    elseif self.y + self.height > virtual_height then
        self.y = virtual_height - self.height
    end

    if self.x < 0 then
        self.x = 0
    elseif self.x + self.width > virtual_width then
        self.x = virtual_width - self.width
    end

    
    
    if love.keyboard.wasPressed("up") then
        self.projectiles[self.projectileCount] = Projectile(1,self.x + (self.width / 2 - PROJECTILE_WIDTH / 2), self.y - PROJECTILE_HEIGHT)
        self.projectileCount = self.projectileCount + 1
    elseif love.keyboard.wasPressed("right") then
        self.projectiles[self.projectileCount] = Projectile(2, self.x + self.width, self.y + (self.width / 2 - PROJECTILE_WIDTH / 2))
        self.projectileCount = self.projectileCount + 1
    elseif love.keyboard.wasPressed("down") then
        self.projectiles[self.projectileCount] = Projectile(3, self.x + (self.width / 2 - PROJECTILE_WIDTH / 2), self.y + self.width)
        self.projectileCount = self.projectileCount + 1
    elseif love.keyboard.wasPressed("left") then
        self.projectiles[self.projectileCount] = Projectile(4, self.x - PROJECTILE_WIDTH, self.y + (self.width / 2 - PROJECTILE_WIDTH / 2))
        self.projectileCount = self.projectileCount + 1
    end

    for k, projectile in pairs(self.projectiles) do
        if projectile:isOut() then
            self.projectiles[k] = nil
        else
            projectile:update(dt)
        end
    end

    if self.invincibilityTimer > 0 then
        self.invincibilityTimer = self.invincibilityTimer - dt
    end
end



function Character:render()
    if self.invincibilityTimer > 0  then
        love.graphics.setColor(1, 1 - self.invincibilityTimer, 0.5 + (0.5 - self.invincibilityTimer / 2))
        love.graphics.rectangle("fill", self.x, self.y, self.width, self.height)
        love.graphics.setColor(1, 1, 1)
    else 
        love.graphics.rectangle("fill", self.x, self.y, self.width, self.height)
    end

    for k, projectile in pairs(self.projectiles) do
        projectile:render()
    end

end