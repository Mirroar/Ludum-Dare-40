Game = class()

Game.stages = {
    {
        goals = {
            parts = 10,
        },
        waves = {
            'sideways',
            'seeker',
        },
        waveTimer = 5,
    },
    {
        goals = {
            kills = 50,
        },
        waves = {
            'sideways',
            'spinner',
        },
        waveTimer = 3,
    },
    {
        goals = {
            time = 60,
        },
        waves = {
            'sideways',
            'spinner',
            'double_spinner',
            'seeker',
        },
        waveTimer = 2,
    },
    {
        goals = {
            time = 300,
            kills = 1000,
            parts = 100,
        },
        waves = {
            'sideways',
            'spinner',
            'double_spinner',
            'seeker',
        },
        waveTimer = 2,
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
    self.backgroundLines = {}

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
    self.backgroundLines = {}
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
        -- Draw background.
        love.graphics.push()
        love.graphics.translate(-game.player.x * 0.2, -game.player.y * 0.2)
        love.graphics.scale(1.2, 1.2)
        local lineSpacing = 150
        love.graphics.setColor(0, 50, 0)
        for i = 1, math.ceil(game.width / lineSpacing) do
            love.graphics.line(0, i * lineSpacing, game.width, i * lineSpacing)
            love.graphics.line(i * lineSpacing, 0, i * lineSpacing, game.height)
        end
        love.graphics.setLineWidth(7)
        for i = 1, 3 do
            local line = self.backgroundLines[i]
            if line then
                local decay = 1 / (line.numSegments - 1)
                local drawn = false

                for i = line.numSegments, 2, -1 do

                    local segmentIndex = #line.segments - line.numSegments + i

                    if segmentIndex > 1 then
                        if i == line.numSegments then
                            love.graphics.setColor(255, 255, 255, 128)
                            love.graphics.draw(images.greenLight, line.segments[segmentIndex].x - 100, line.segments[segmentIndex].y - 100)
                        end

                        if line.segments[segmentIndex].x >= 0 and line.segments[segmentIndex].y >= 0 and line.segments[segmentIndex].x <= game.width and line.segments[segmentIndex].y <= game.height then

                            love.graphics.setColor(0, 255, 0, 64 * decay * i)

                            love.graphics.line(line.segments[segmentIndex].x, line.segments[segmentIndex].y, line.segments[segmentIndex - 1].x, line.segments[segmentIndex - 1].y)
                            drawn = true
                        end
                    else
                        break
                    end
                end

                if not drawn and #line.segments > 3 then line.destroyed = true end
            end
        end
        love.graphics.pop()
        love.graphics.setColor(255, 255, 255)
        love.graphics.setLineWidth(1)

        -- Draw all entities.
        self.entities:draw()

        -- Draw HUD.
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

    local stage = Game.stages[self.activeStage]
    local waveType = stage.waves[love.math.random(#stage.waves)]

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

        if self.spawnTimer > (Game.stages[self.activeStage].waveTimer or 3) then
            self:spawnWave()
            self.spawnTimer = 0
        end

        if self.player.isDestroyed then
            self:endStage()
        end

        -- Update background lines.
        for i = 1, 3 do
            local line = self.backgroundLines[i]
            if not line or line.destroyed then
                self.backgroundLines[i] = {
                    segments = {},
                    numSegments = love.math.random(5, 30),
                    cooldown = love.math.random(5),
                    direction = {x = 0, y = 0},
                    destroyed = false,
                    timer = 0,
                    interval = 0.1,
                }
                line = self.backgroundLines[i]

                if love.math.random() < 0.5 then
                    self.backgroundLines[i].direction.x = (love.math.random(0, 1) * 2 - 1) * 20
                else
                    self.backgroundLines[i].direction.y = (love.math.random(0, 1) * 2 - 1) * 20
                end

                local segment = {x = 0, y = 0}
                if line.direction.x == 0 then
                    segment.x = love.math.random(game.width)
                    if line.direction.y < 0 then
                        segment.y = game.height
                    end
                else
                    segment.y = love.math.random(game.height)
                    if line.direction.x < 0 then
                        segment.x = game.width
                    end
                end

                table.insert(line.segments, segment)
            end

            line.cooldown = line.cooldown - delta

            if line.cooldown <= 0 then
                -- Change direction
                line.cooldown = love.math.random(5)

                local temp = line.direction.x
                line.direction.x = (love.math.random(0, 1) * 2 - 1) * line.direction.y
                line.direction.y = (love.math.random(0, 1) * 2 - 1) * temp
            end

            line.timer = line.timer + delta

            while line.timer > line.interval do
                line.timer = line.timer - line.interval

                -- Remove old segments.
                if #line.segments > line.numSegments then
                    table.remove(line.segments, 1)
                end

                -- Add a new segment.
                table.insert(line.segments, {
                    x = line.segments[#line.segments].x + line.direction.x,
                    y = line.segments[#line.segments].y + line.direction.y,
                })
            end
        end

        self:checkStageConditions()

        if self.transitionStage then
            -- Check if there are no more enemies and bullets left
            -- before transitioning to the next stage.
            local done = true
            for _, entity in ipairs(self.entities.entities) do
                if entity:IsInstanceOf(Enemy) or (entity:IsInstanceOf(Bullet) and not entity:isFriendly()) then
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
