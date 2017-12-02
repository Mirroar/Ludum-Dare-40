Game = class()

Game.stages = {
    {
        goals = {
            parts = 50,
        },
        waves = {
            'sideways',
        },
    },
    {
        goals = {
            enemies = 200,
            parts = 70,
        },
        waves = {
            'sideways',
        },
    },
    {
        goals = {
            enemies = 1000,
            parts = 100,
        },
        waves = {
            'sideways',
        },
    },
}

function Game:construct()
    self.isActive = false

    self.entities = EntityManager()

    self.width = 1280
    self.height = 720
end

function Game:initStage()
    self.isActive = true
    self.stageTimer = 0
    self.spawnTimer = 0
    self.waves = {}

    self.player = Player()
    self.entities:AddEntity(self.player)

    self.player.x = self.width / 2
    self.player.y = self.height / 2

    self:spawnWave()
end

function Game:endStage()
    self.isActive = false

    for _, entity in ipairs(self.entities.entities) do
        entity.isDestroyed = true
    end
end

function Game:draw()
    if self.isActive then
        self.entities:draw()

        -- Show some stats to the player.
        love.graphics.print("HP: "..math.floor(game.player.hitpoints).."/"..game.player.maxHitpoints, 20, 20)
        love.graphics.print("Parts: "..game.player.attachments:GetCount(), 20, 40)
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

        if self.player.isDestroyed then
            self:endStage()
        end
    end
end
