Enemy = class(Actor)

function Enemy:draw()
    textures:DrawSprite("enemy", self.x, self.y, self.rotation)
end
