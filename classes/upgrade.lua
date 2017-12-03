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
    self.rotation = angle(game.player.rotation + self.attachAngle)

    if self.parentAttachment then
        self.rotation = self.parentAttachment:GetAngleTo(self.x, self.y)
    end
end

function Upgrade:moveToAttach(delta)
    -- Move more towards player
    local playerDistance = self:GetDistanceTo(game.player.x, game.player.y)
    for _, attachment in ipairs(game.player.attachments.entities) do
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
        while collides and self.attachDistance < 500 do
            collides = false
            self.attachDistance = self.attachDistance + 1
            self:moveWithPlayer()
            for _, attachment in ipairs(game.player.attachments.entities) do
                if attachment ~= self then
                    if self:GetDistanceTo(attachment.x, attachment.y) < self.radius + attachment.radius then
                        collides = true
                        self.parentAttachment = attachment
                        break
                    end
                end
            end
        end

        return
    end

    local force = 500 + math.max(1000 - playerDistance, 0)
    local vKeep = lerp(1, 0, self.attachTimer / 3)

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

function Upgrade:drawEarly()
    if self.isAttached then
        local offsetX = math.sin(self.rotation * math.pi / 180) * 10
        local offsetY = -math.cos(self.rotation * math.pi / 180) * 10
        textures:DrawSprite("upgrade_attach", self.x - offsetX, self.y - offsetY, self.rotation)
    end
end

function Upgrade:draw()
    if self.isAttached then
        textures:DrawSprite("upgrade", self.x, self.y, self.rotation)
    else
        textures:DrawSprite("upgrade_inflight", self.x, self.y, self.attachTimer * 30)
    end
end

function Upgrade:drawLate()
    if self.isAttached then
        local offsetX = math.sin(self.rotation * math.pi / 180) * 5
        local offsetY = -math.cos(self.rotation * math.pi / 180) * 5
        textures:DrawSprite("upgrade_turret", self.x + offsetX, self.y + offsetY, self.rotation)
    end
end

function Upgrade:Destroy()
    -- Check if any other attachmens have this one as parent, and destroy
    -- those, too.
    for _, attachment in ipairs(game.player.attachments.entities) do
        if attachment.parentAttachment and attachment.parentAttachment == self then
            attachment:Destroy()
        end
    end

    Actor.Destroy(self)
end
