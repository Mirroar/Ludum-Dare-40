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
            kills = 200,
        },
        waves = {
            'sideways',
        },
    },
    {
        goals = {
            time = 60,
        },
        waves = {
            'sideways',
        },
    },
    {
        goals = {
            time = 300,
            kills = 1000,
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

function Game:initStage(stage)
    self.isActive = true
    self.stageTimer = 0
    self.spawnTimer = 0
    self.kills = 0
    self.activeStage = stage
    self.transitionStage = false
    self.waves = {}

    if not self.player or self.player.isDestroyed then
        self.player = Player()
        self.entities:AddEntity(self.player)
    end

    self.player.x = self.width / 2
    self.player.y = self.height / 2

    self:spawnWave()

    log:insert("stage "..stage.." started")
end

function Game:endStage()
    self.isActive = false

    for _, entity in ipairs(self.entities.entities) do
        entity.isDestroyed = true
    end
end

function Game:checkStageConditions()
    local stage = Game.stages[self.activeStage]
    local cleared = true
    for key, value in pairs(stage.goals) do
        if key == 'parts' then
            if #self.player.attachments.entities < value then
                cleared = false
                break
            end
        elseif key == 'time' then
            if self.stageTimer < value then
                cleared = false
                break
            end
        elseif key == 'kills' then
            if self.kills < value then
                cleared = false
                break
            end
        end
    end

    if cleared then
        -- Stop spawning new waves.
        self.transitionStage = true
    end
end

function Game:draw()
    if self.isActive then
        self.entities:draw()

        -- Show some stats to the player.
        love.graphics.print("HP: "..math.floor(game.player.hitpoints).."/"..game.player.maxHitpoints, 20, 20)
        love.graphics.print("Parts: "..game.player.attachments:GetCount(), 20, 40)

        local goalString = nil
        local stage = Game.stages[self.activeStage]
        for key, value in pairs(stage.goals) do
            if key == 'parts' then
                goalString = (goalString or '').. 'Collect '..value..' parts. '
            elseif key == 'time' then
                goalString = (goalString or '').. 'Survive for '..value..' seconds. '
            elseif key == 'kills' then
                goalString = (goalString or '').. 'Defeat '..value..' enemies. '
            end
        end

        if goalString then
            love.graphics.print("Goal: "..goalString, 20, 100)
        end
    end
end

function Game:keypressed(key)
    if key == 'escape' then
        self.isActive = false
    end
end

function Game:spawnWave()
    if self.transitionStage then return end

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

        self:checkStageConditions()

        if self.transitionStage then
            -- Check if there are no more enemies and bullets left
            -- before transitioning to the next stage.
            local done = true
            for _, entity in ipairs(self.entities.entities) do
                if entity:IsInstanceOf(Enemy) or entity:IsInstanceOf(Bullet) then
                    done = false
                    break
                end
            end

            if done then
                self:initStage(self.activeStage + 1)
            end
        end
    end
end
