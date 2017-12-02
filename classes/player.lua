Player = class(Actor)

function Player:construct(...)
    Actor.construct(self, ...)
    self.rotation = 0
    self.speed = 100
end

function Player:draw()
    textures:DrawSprite("player", self.x, self.y, self.rotation)
end

function Player:update(delta)
    -- @todo Maybe even support game pad!

    -- Try to face the mouse cursor.
    local x, y = love.mouse.getPosition()

    -- @todo Turn towards the rotation, don't snap do it instantly.
    self.rotation = self:GetAngleTo(x, y)

    -- Detect direction of player movement.
    local mx, my = 0, 0
    if love.keyboard.isDown('w') then
        my = my - 1
    end
    if love.keyboard.isDown('s') then
        my = my + 1
    end
    if love.keyboard.isDown('a') then
        mx = mx - 1
    end
    if love.keyboard.isDown('d') then
        mx = mx + 1
    end

    if mx ~= 0 or my ~= 0 then
        local mAngle = math.atan2(-mx, my)

        self.x = self.x - self.speed * delta * math.sin(mAngle)
        self.y = self.y + self.speed * delta * math.cos(mAngle)
    end
end
