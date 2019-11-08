require "Enemy"
math.randomseed(os.time())

Spawner = Class{}

function Spawner:init(target)
    self.target = target

    self.spawnrate = ENEMY_SPAWNRATE
    self.timer = 0

    self.enemyCount = 0
    enemiesTable = {}
end



function Spawner:update(dt)
    self.timer = self.timer + dt

    

    if self.timer >= self.spawnrate then
        
        self.timer = 0
        
        if math.random(0, 1) == 0 then
            self.enemyX = math.random(0, virtual_width)
            self.enemyY = math.random(0, 1) == 0 and 0 or virtual_height
        else
            self.enemyX = math.random(0, 1) == 0 and 0 or virtual_width
            self.enemyY = math.random(0, virtual_height)
        end
        enemiesTable[self.enemyCount] = Enemy(self.target, self.enemyX, self.enemyY)

        self.enemyCount = self.enemyCount + 1
    end

    for k, enemy in pairs(enemiesTable) do
        if enemy.health <= 0 then
            enemiesTable[k] = nil
            playerScore = playerScore + 1
        else
            enemy:update(dt)
        end
    end
end


function Spawner:render()
    for k, enemy in pairs(enemiesTable) do
        enemy:render()
    end
end