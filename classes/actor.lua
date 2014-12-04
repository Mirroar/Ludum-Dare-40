Actor = class(Entity)

function Actor:construct(...)
    Entity.construct(self, ...)

    self.hasFired = false
end

function Actor:TryFire()
    if self.hasFired then
        return false
    end
    self.hasFired = true
    return true
end