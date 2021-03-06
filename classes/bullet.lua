Bullet = class(Entity)

Bullet.PLAYER_SHOT = 1
Bullet.PLAYER_SHOT_SLOW = 2
Bullet.ENEMY_SHOT = 11

Bullet.types = {
    [Bullet.PLAYER_SHOT] = {
        speed = 500,
        lifetime = 3,
        radius = 5,
        friendly = true,
    },
    [Bullet.PLAYER_SHOT_SLOW] = {
        speed = 200,
        lifetime = 5,
        radius = 5,
        friendly = true,
    },
    [Bullet.ENEMY_SHOT] = {
        speed = 200,
        lifetime = 5,
        radius = 3,
        friendly = false,
    },
}

function Bullet:construct(x, y, type, direction)
    Entity.construct(self, x, y)

    self.bulletType = type
    self.rotation = direction
    self:SetMoveDirection(direction, Bullet.types[type].speed)

    self.lifetime = Bullet.types[type].lifetime
    self.radius = Bullet.types[type].radius
end

function Bullet:isFriendly()
    return Bullet.types[self.bulletType].friendly
end

function Bullet:update(delta)
    Entity.update(self, delta)

    if self:isFriendly() then
        -- Check if we hit an enemy.
        for _, entity in ipairs(game.entities.entities) do
            if entity:IsInstanceOf(Enemy) then
                if self:GetDistanceTo(entity.x, entity.y) < self.radius + entity.radius then
                    self:Destroy()
                    entity:Hit()
                    break
                end
            end
        end
    else
        -- Check if the player is hit.
        for _, attachment in ipairs(game.player.attachments.entities) do
            if self:GetDistanceTo(attachment.x, attachment.y) < self.radius + attachment.radius then
                self:Destroy()
                attachment:Hit()
                break
            end
        end

        if self:GetDistanceTo(game.player.x, game.player.y) < self.radius + game.player.radius then
            self:Destroy()
            game.player:Hit()
        end
    end

    self.lifetime = self.lifetime - delta
    if self.lifetime <= 0 then
        self:Destroy()
    end
end

-- This is a placeholder function for what could become more precise collission
-- checking. In particular, we'd like to calculate whether an enemy has been
-- hit anywhere on the line that the bullet travelled between frames.
function Bullet:debugMath()
    -- Calculate line along which the bullet is travelling.
    local dx = self.x - self.oldX
    local dy = self.y - self.oldY
    if dx == 0 then
        -- Cheat a bit to work around division by 0.
        -- If we were to be exact, we'd use a different formula for
        -- positions in that case.
        dx = 0.001
    end
    self.inclination = dy / dx
    self.start = (self.x * self.oldY - self.oldX * self.y) / dx

    love.graphics.setColor(128, 128, 128)
    love.graphics.line(0, self.start, 1280, self.start + self.inclination * 1280)
    love.graphics.setColor(255, 0, 0)
    love.graphics.line(self.oldX, self.start + self.inclination * self.oldX, self.x, self.start + self.inclination * self.x)
    love.graphics.setColor(255, 255, 255)
end

function Bullet:draw()
    -- self:debugMath()
    if self.bulletType == Bullet.PLAYER_SHOT then
        textures:DrawSprite("bullet", self.x, self.y, self.rotation)
    elseif self.bulletType == Bullet.PLAYER_SHOT_SLOW then
        textures:DrawSprite("enemy_bullet", self.x, self.y, self.rotation)
    elseif self.bulletType == Bullet.ENEMY_SHOT then
        textures:DrawSprite("enemy_bullet", self.x, self.y, self.rotation)
    end
end

function Bullet:drawLate()
    -- self:debugMath()
    if self.bulletType == Bullet.ENEMY_SHOT then
        love.graphics.draw(images.redLight, self.x - 50, self.y - 50, 0, 0.5, 0.5)
    end
end
