Projectile = Class{}

function Projectile:init(direction, x, y)
    self.direction = direction
    self.speed = PROJECTILE_SPEED

    self.x = x
    self.y = y

    self.width = PROJECTILE_WIDTH
    self.height = PROJECTILE_HEIGHT

    self.hasCollided = false
end

function Projectile:isOut()
    return (self.x > virtual_width or self.x < 0 or self.y > virtual_height or self.y < 0)
        or self.hasCollided
end


function Projectile:collidesWith(other)
    return self.x < other.x + other.width and
            other.x < self.x+self.width and
            self.y < other.y+other.height and
            other.y < self.y+self.height
end


function Projectile:update(dt)
    if self.direction == 1 then
        self.y = self.y - self.speed * dt
    elseif self.direction == 2 then
        self.x = self.x + self.speed * dt
    elseif self.direction == 3 then
        self.y = self.y + self.speed * dt
    elseif self.direction == 4 then
        self.x = self.x - self.speed * dt
    end

    for k, v in pairs(enemiesTable) do
        if self:collidesWith(v) then
            v:damage(self.direction)
            self.hasCollided = true
        end
    end

end



function Projectile:render()
    love.graphics.rectangle("fill", self.x, self.y, self.width, self.height)
end