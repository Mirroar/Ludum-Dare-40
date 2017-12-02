Player = class(Actor)

function Player:construct(...)
    Actor.construct(self, ...)
    self.rotation = 0
    self.speed = 200

    self.cooldown = 0.3
end

function Player:draw()
    textures:DrawSprite("player", self.x, self.y, self.rotation)
end

function Player:update(delta)
    Actor.update(self, delta)

    -- @todo Maybe even support game pad!

    -- Try to face the mouse cursor.
    local mouseX, mouseY = love.mouse.getPosition()

    -- @todo Turn towards the rotation, don't snap do it instantly.
    self.rotation = self:GetAngleTo(mouseX, mouseY)

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

        self.x = self.x - self.speed * delta * math.sin(mAngle)
        self.y = self.y + self.speed * delta * math.cos(mAngle)
    end

    -- Let the player fire
    if love.mouse.isDown(1) or love.keyboard.isDown('space') then
        if self:TryFire() then
            local bullet = Bullet(self.x, self.y, Bullet.PLAYER_SHOT, self.rotation)
            game.entities:AddEntity(bullet)
        end
    end
end
