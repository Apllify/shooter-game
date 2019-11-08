Enemy = Class{}

local epsilon = 2

function Enemy:init(target, x, y)
    self.target = target
    self.health = ENEMY_HEALTH

    self.x = x
    self.y = y

    self.xv = 0
    self.yv = 0

    self.speed = ENEMY_SPEED

    self.width = ENEMY_WIDTH
    self.height = ENEMY_HEIGHT

    self.redLeft = 0
end


function Enemy:damage(direction)
    self.redLeft = 1

    if direction == 1 then
        self.yv = -3
    elseif direction == 2 then 
        self.xv = 3
    elseif direction == 3 then
        self.yv = 3
    elseif direction == 4 then
        self.xv = -3
    end


    self.health = self.health - 1
end



function Enemy:update(dt)
    if self.y - self.target.y < -epsilon then
        self.y = self.y + self.speed * dt + self.yv
    elseif self.y - self.target.y > epsilon then
        self.y = self.y - self.speed * dt + self.yv 
    end

    if self.x - self.target.x < -epsilon then
        self.x = self.x + self.speed * dt + self.xv
    elseif self.x - self.target.x > epsilon then
        self.x = self.x - self.speed * dt + self.xv
    end     

    if self.redLeft > 0 then
        self.redLeft = self.redLeft - dt
    end

    
    if self.xv > 0 then
        self.xv = self.xv - dt
    end

    if self.xv < 0 then
        self.xv = self.xv + dt
    end

    if self.yv > 0 then
        self.yv = self.yv - dt
    end

    if self.yv < 0 then
        self.yv = self.yv + dt
    end

    if self.x < self.target.x + self.target.width and
            self.target.x < self.x+self.width and
            self.y < self.target.y+self.target.height and
            self.target.y < self.y+self.height then
                self.target:damage()
            end
end



function Enemy:render()
    if self.redLeft > 0 then
        love.graphics.setColor(1, 1 - self.redLeft, 1 - self.redLeft)
        love.graphics.rectangle("fill", self.x, self.y, self.width, self.height)
        love.graphics.setColor(1, 1, 1)
    else
        love.graphics.setColor(1, 1, 1)
        love.graphics.rectangle("fill", self.x, self.y, self.width, self.height)
    end
end