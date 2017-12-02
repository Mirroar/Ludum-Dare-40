Bullet = class(Entity)

Bullet.PLAYER_SHOT = 1

Bullet.definitions = {
    [Bullet.PLAYER_SHOT] = {
        speed = 500,
    }
}

function Bullet:construct(x, y, type, direction)
    Entity.construct(self, x, y)

    self.bulletType = type
    self.rotation = direction
    self:SetMoveDirection(direction, Bullet.definitions[type].speed)
end

function Bullet:draw()
    textures:DrawSprite("bullet", self.x, self.y, self.rotation)
end
