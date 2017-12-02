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
    self.waves = {}

    self:spawnWave()
end

function Game:endStage()
    self.isActive = false
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

function Game:spawnWave()
    local waveType = 'sideways'

    table.insert(self.waves, Wave(waveType))
end

function Game:update(delta)
    if self.isActive then
        self.entities:update(delta)

        for _, wave in ipairs(self.waves) do
            wave:update(delta)
        end

        self.stageTimer = self.stageTimer + delta
        self.spawnTimer = self.spawnTimer + delta

        if self.spawnTimer > 3 then
            self:spawnWave()
            self.spawnTimer = 0
        end
    end
end
