Game = class()

function Game:construct()
    self.isActive = false

    self.entities = EntityManager()

    self.player = Player()
    self.entities:AddEntity(self.player)

    self.width = 1280
    self.height = 720

    self.player.x = self.width / 2
    self.player.y = self.height / 2
end

function Game:initStage()
    self.isActive = true
    self.stageTimer = 0
    self.spawnTimer = 0

    self:spawnEnemy()
    self:spawnEnemy()
end

function Game:endStage()
    self.isActive = false
end

function Game:spawnEnemy()
    local x = math.random(self.width)
    local y = math.random(self.height)

    if game.player:GetDistanceTo(x, y) > 200 then
        self.entities:AddEntity(Enemy(x, y))
    else
        self:spawnEnemy()
    end
end

function Game:draw()
    if self.isActive then
        self.entities:draw()
    end
end

function Game:keypressed(key)
    if key == 'escape' then
        self.isActive = false
    end
end

function Game:update(delta)
    if self.isActive then
        self.entities:update(delta)

        self.stageTimer = self.stageTimer + delta
        self.spawnTimer = self.spawnTimer + delta

        if self.spawnTimer > 3 then
            self:spawnEnemy()
            self.spawnTimer = 0
        end
    end
end
