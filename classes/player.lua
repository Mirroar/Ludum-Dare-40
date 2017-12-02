Player = class(Actor)

function Player:construct(...)
    Actor.construct(self, ...)
    self.rotation = 0
    self.speed = 200

    self.cooldown = 0.3

    self.maxHitpoints = 10
    self.hitpoints = self.maxHitpoints

    self.attachments = EntityManager()
end

function Player:attach(attachment)
    for _, attachment in ipairs(self.attachments.entities) do
        -- Move old attachments closer to core.
        attachment.attachDistance = attachment.attachDistance * 0.99
    end
    self.attachments:AddEntity(attachment)
end

function Player:draw()
    -- Draw aim assistance line.
    local dx = math.sin(self.rotation * math.pi / 180)
    local dy = -math.cos(self.rotation * math.pi / 180)
    love.graphics.setColor(128, 128, 128)
    love.graphics.line(self.x, self.y, self.x + 300 * dx, self.y + 300 * dy)

    love.graphics.setColor(255, 255, 255)
    textures:DrawSprite("player", self.x, self.y, self.rotation)
end

function Player:update(delta)
    Actor.update(self, delta)

    -- @todo Maybe even support game pad!

    -- Try to face the mouse cursor.
    local mouseX, mouseY = love.mouse.getPosition()

    -- Turn towards the rotation.
    local rotationSpeed = 10
    for i = 1, #self.attachments.entities do
        rotationSpeed = rotationSpeed * 0.95
    end
    self.rotation = lerpAngle(self.rotation, self:GetAngleTo(mouseX, mouseY), rotationSpeed * delta)

    -- Detect direction of player movement.
    local mx, my = 0, 0
    if love.keyboard.isDown('w', 'up') then
        my = my - 1
    end
    if love.keyboard.isDown('s', 'down') then
        my = my + 1
    end
    if love.keyboard.isDown('a', 'left') then
        mx = mx - 1
    end
    if love.keyboard.isDown('d', 'right') then
        mx = mx + 1
    end

    if mx ~= 0 or my ~= 0 then
        local mAngle = math.atan2(-mx, my)
        local speedFactor = 10 / (10 + #self.attachments.entities)

        self.x = self.x - self.speed * speedFactor * delta * math.sin(mAngle)
        self.y = self.y + self.speed * speedFactor * delta * math.cos(mAngle)
    end

    -- Let the player fire.
    if love.mouse.isDown(1) or love.keyboard.isDown('space') then
        if self:TryFire() then
            local bullet = Bullet(self.x, self.y, Bullet.PLAYER_SHOT, self.rotation)
            game.entities:AddEntity(bullet)
        end

        for _, attachment in ipairs(self.attachments.entities) do
            attachment.cooldown = math.sqrt(#self.attachments.entities) + love.math.randomNormal(#self.attachments.entities) / 10
            if attachment:TryFire() then
                local bullet = Bullet(attachment.x, attachment.y, Bullet.PLAYER_SHOT, angle(self:GetAngleTo(mouseX, mouseY) + love.math.randomNormal(#self.attachments.entities)))
                game.entities:AddEntity(bullet)
            end
        end
    end

    -- Slowly recover hp if core is damaged.
    if self.hitpoints < self.maxHitpoints then
        self.hitpoints = self.hitpoints + delta * 0.1

        if self.hitpoints > self.maxHitpoints then
            self.hitpoints = self.maxHitpoints
        end
    end

    -- Allow attachment entities to get removed and stuff.
    self.attachments:update()
end

function Player:Destroy()
    -- Also destroy all attachments.
    for _, attachment in ipairs(self.attachments.entities) do
        attachment:Destroy()
    end

    Actor.Destroy(self)
end
