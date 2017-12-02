Bullet = class(Entity)

Bullet.PLAYER_SHOT = 1

Bullet.definitions = {
    [Bullet.PLAYER_SHOT] = {
        speed = 500,
        lifetime = 3,
    }
}

function Bullet:construct(x, y, type, direction)
    Entity.construct(self, x, y)

    self.bulletType = type
    self.rotation = direction
    self:SetMoveDirection(direction, Bullet.definitions[type].speed)

    self.lifetime = Bullet.definitions[type].lifetime
end

function Bullet:update(delta)
    Entity.update(self, delta)

    self.lifetime = self.lifetime - delta
    if self.lifetime <= 0 then
        self:Destroy()
    end
end

function Bullet:draw()
    textures:DrawSprite("bullet", self.x, self.y, self.rotation)
end
