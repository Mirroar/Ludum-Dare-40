Enemy = class(Actor)

Enemy.types = {
    sideways = {
        draw = function (self)
            love.graphics.circle('fill', self.x, self.y, 20)
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
    }
}

function Enemy:construct(x, y, type, options, ...)
    Actor.construct(self, x, y, type, options, ...)

    if options then
        for k, v in pairs(options) do
            self[k] = v
        end
    end

    self.enemyType = type
    self.radius = Enemy.types[type].radius or 7
    self.cooldown = Enemy.types[type].cooldown or 1
    self.timer = 0
    self.startX = x
    self.startY = y
    if Enemy.types[type].draw then
        self.draw = Enemy.types[type].draw
    end
end

function Enemy:draw()
    textures:DrawSprite("enemy", self.x, self.y, self.rotation)
end

function Enemy:update(delta)
    Actor.update(self, delta)

    self.timer = self.timer + delta
    if Enemy.types[self.enemyType].update then
        Enemy.types[self.enemyType].update(self, delta)
    end
end

function Enemy:Destroy()
    -- Create a part that flies towards the player to "upgrade".
    local upgrade = Upgrade(self.x, self.y)
    game.entities:AddEntity(upgrade)

    Actor.Destroy(self)
end
