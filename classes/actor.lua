Actor = class(Entity)

function Actor:construct(...)
    Entity.construct(self, ...)

    self.cooldown = 1
    self.currentCooldown = 0
    self.hasFired = false
    self.maxHitpoints = 5
    self.hitpoints = self.maxHitpoints
    self.radius = 7
end

function Actor:Hit(damage)
    self.hitpoints = self.hitpoints - (damage or 1)
    if self.hitpoints <= 0 then
        self:Destroy()
    end
end

function Actor:TryFire()
    if self.hasFired then
        return false
    end
    self.hasFired = true
    self.currentCooldown = self.cooldown
    return true
end

function Actor:update(delta)
    Entity.update(self, delta)

    if self.hasFired then
        self.currentCooldown = self.currentCooldown - delta

        if self.currentCooldown <= 0 then
            self.currentCooldown = 0
            self.hasFired = false
        end
    end
end
