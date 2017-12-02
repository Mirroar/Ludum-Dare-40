Upgrade = class(Actor)

function Upgrade:construct(x, y, ...)
    Actor.construct(self, x, y, ...)

    local startAngle = angle(game.player:GetAngleTo(self.x, self.y) + love.math.randomNormal(100, 0))
    self:SetMoveDirection(startAngle, 500)
    self.attachTimer = 0
    self.isAttached = false
    self.radius = 7
end

function Upgrade:update(delta)
    Actor.update(self, delta)

    if not self.isAttached then
        self:moveToAttach(delta)
    else
        self:moveWithPlayer()
    end
end

function Upgrade:moveWithPlayer()
    -- Update position relative to player.
    local actualAngle = self.attachAngle + game.player.rotation
    local dx = math.sin(actualAngle / 180 * math.pi) * self.attachDistance
    local dy = -math.cos(actualAngle / 180 * math.pi) * self.attachDistance

    self.x = game.player.x + dx
    self.y = game.player.y + dy
end

function Upgrade:moveToAttach(delta)
    -- Move more towards player
    local playerDistance = self:GetDistanceTo(game.player.x, game.player.y)
    for _, attachment in ipairs(game.player.attachments) do
        playerDistance = math.min(playerDistance, self:GetDistanceTo(attachment.x, attachment.y))
    end

    if playerDistance < self.radius + game.player.radius then
        -- Attach!
        self.isAttached = true
        self.attachTimer = 0
        self.vx = 0
        self.vy = 0
        local attachmentAngle = game.player:GetAngleTo(self.x, self.y)
        self.attachAngle = angle(attachmentAngle - game.player.rotation)
        self.attachDistance = self.radius + game.player.radius - 1
        game.player:attach(self)

        -- Calculate attach distance if other parts are in the way.
        local collides = true
        while collides and self.attachDistance < 100 do
            collides = false
            self.attachDistance = self.attachDistance + 1
            self:moveWithPlayer()
            for _, attachment in ipairs(game.player.attachments) do
                if attachment ~= self then
                    if self:GetDistanceTo(attachment.x, attachment.y) < self.radius + attachment.radius then
                        collides = true
                        break
                    end
                end
            end
        end

        return
    end

    local force = 500 + math.max(1000 - playerDistance, 0)
    local vKeep = lerp(1, 0, self.attachTimer)

    local playerAngle = self:GetAngleTo(game.player.x, game.player.y)
    self.vx = self.vx * vKeep + (1 - vKeep) * math.sin(playerAngle / 180 * math.pi) * force
    self.vy = self.vy * vKeep - (1 - vKeep) * math.cos(playerAngle / 180 * math.pi) * force

    local totalSpeed = math.sqrt(self.vx * self.vx + self.vy * self.vy)
    if totalSpeed > 500 then
        selfvx = self.vx * 500 / totalSpeed
        selfvy = self.vy * 500 / totalSpeed
    end

    self.attachTimer = self.attachTimer + delta
end

function Upgrade:draw()
    textures:DrawSprite("upgrade", self.x, self.y, self.rotation)
end
