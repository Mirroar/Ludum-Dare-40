Enemy = class(Actor)

Enemy.types = {
    sideways = {
        draw = function (self)
            textures:DrawSprite("enemy_sideways", self.x, self.y, self.rotation, 2, 2)
        end,
        update = function (self, delta)
            local timerInt = math.floor(self.timer)
            local fract = 1
            if timerInt % 2 == 0 then
                fract = self.timer - timerInt
            else
                -- We're standing still, time to fire!
                if self:TryFire() then
                    game.entities:AddEntity(Bullet(self.x, self.y, Bullet.ENEMY_SHOT, 0))
                    game.entities:AddEntity(Bullet(self.x, self.y, Bullet.ENEMY_SHOT, 180))
                end
            end
            local distance = (math.floor(timerInt / 2) + fract) * 500

            if self.dir == 'left' then
                self.x = self.startX - distance
            else
                self.x = self.startX + distance
            end
        end,
        radius = 20,
        cooldown = 0.5,
    },
    spinner = {
        draw = function (self)
            textures:DrawSprite("enemy_sideways", self.x, self.y, self.rotation, 2, 2)
        end,
        update = function (self, delta)
            self.rotation = angle(self.rotation + delta * 60)
            if self:TryFire() then
                game.entities:AddEntity(Bullet(self.x, self.y, Bullet.ENEMY_SHOT, self.rotation))
                game.entities:AddEntity(Bullet(self.x, self.y, Bullet.ENEMY_SHOT, angle(self.rotation + 180)))
            end
        end,
        radius = 20,
        cooldown = 0.2,
    },
    seeker = {
        draw = function (self, delta)
            local xOffset = math.sin(self.rotation * math.pi / 180) * 30
            local yOffset = -math.cos(self.rotation * math.pi / 180) * 30
            xOffset = xOffset + math.sin(angle(self.rotation - 90) * math.pi / 180) * 50
            yOffset = yOffset + -math.cos(angle(self.rotation - 90) * math.pi / 180) * 50

            love.graphics.setColor(255, 255, 255, love.math.random(128, 255))
            love.graphics.draw(images.exhaust, self.x + xOffset, self.y + yOffset, self.rotation * math.pi / 180)

            love.graphics.setColor(255, 255, 255)
            textures:DrawSprite("enemy_seeker", self.x, self.y, self.rotation, 2, 2)
            love.graphics.draw(images.redLight, self.x - 100, self.y - 100)
        end,
        update = function (self, delta)
            local angle = self:GetAngleTo(game.player)
            self:SetMoveDirection(angle, math.sqrt(self.timer) * 100)
            self.rotation = angle

            -- Check if the player is hit.
            for _, attachment in ipairs(game.player.attachments.entities) do
                if self:GetDistanceTo(attachment.x, attachment.y) < self.radius + attachment.radius then
                    self:Destroy()
                    attachment:Hit(3)
                    break
                end
            end

            if self:GetDistanceTo(game.player.x, game.player.y) < self.radius + game.player.radius then
                self:Destroy()
                game.player:Hit(3)
            end
        end,
        radius = 20,
    },
}

function Enemy:construct(x, y, type, options, ...)
    Actor.construct(self, x, y, type, options, ...)

    self.timer = 0
    self.enemyType = type

    for k, v in pairs(Enemy.types[type]) do
        if k ~= 'update' then
            self[k] = v
        end
    end

    if options then
        for k, v in pairs(options) do
            self[k] = v
        end
    end

    self.timerSpeed = self.timerSpeed or 1
    self.startX = x
    self.startY = y
end

function Enemy:draw()
    love.graphics.circle('fill', self.x, self.y, self.radius)
end

function Enemy:update(delta)
    Actor.update(self, delta)

    self.timer = self.timer + delta * self.timerSpeed
    if Enemy.types[self.enemyType].update then
        Enemy.types[self.enemyType].update(self, delta)
    end

    -- Destroy enemies that move too far out of bounds
    if self.x < -1000 or self.y < -1000 or self.x > game.width + 1000 or self.y > game.height + 1000 then
        self.isDestroyed = true
    end
end

function Enemy:Destroy()
    -- Create a part that flies towards the player to "upgrade".
    if love.math.random() < 0.3 then
        local upgrade = Upgrade(self.x, self.y)
        game.entities:AddEntity(upgrade)
        game.kills = game.kills + 1
    end

    Actor.Destroy(self)
end
