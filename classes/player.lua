Player = class(Actor)

function Player:construct(...)
    Actor.construct(self, ...)

    self.turretRotation = 0
end

function Player:GetTurretRotation()
    return self.turretRotation
end

function Player:SetTurretRotation(rotation)
    self.turretRotation = angle(rotation)
end

function Player:draw()
    textures:DrawSprite("Wheels", self.x, self.y, self.rotation)
    textures:DrawSprite("Gun", self.x, self.y, self.turretRotation)
end