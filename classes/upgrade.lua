Upgrade = class(Actor)

function Upgrade:construct(x, y, ...)
    Actor.construct(self, x, y, ...)

    local startAngle = angle(game.player:GetAngleTo(self.x, self.y) + love.math.randomNormal(100, 0))
    self:SetMoveDirection(startAngle, 500)
    self.attachTimer = 0
end

function Upgrade:update(delta)
    Actor.update(self, delta)

    -- Move more towards player
    local playerAngle = self:GetAngleTo(game.player.x, game.player.y)
    local playerDistance = self:GetDistanceTo(game.player.x, game.player.y)
    local force = 500 + math.max(1000 - playerDistance, 0)

    local vKeep = lerp(1, 0, self.attachTimer)

    self.vx = self.vx * vKeep + (1 - vKeep) * math.sin(playerAngle / 180 * math.pi) * force
    self.vy = self.vy * vKeep - (1 - vKeep) * math.cos(playerAngle / 180 * math.pi) * force

    local totalSpeed = math.sqrt(self.vx * self.vx + self.vy * self.vy)
    if totalSpeed > 500 then
        selfvx = self.vx * 500 / totalSpeed
        selfvy = self.vy * 500 / totalSpeed
    end

    self.attachTimer = self.attachTimer + delta
end
