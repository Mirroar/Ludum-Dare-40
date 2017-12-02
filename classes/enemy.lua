Enemy = class(Actor)

function Enemy:draw()
    textures:DrawSprite("enemy", self.x, self.y, self.rotation)
end

function Enemy:Destroy()
    -- Create a part that flies towards the player to "upgrade".
    local upgrade = Upgrade(self.x, self.y)
    game.entities:AddEntity(upgrade)

    Actor.Destroy(self)
end
