Game = class()

function Game:construct()
    self.isActive = false

    self.entities = EntityManager()

    self.player = Player()
    self.entities:AddEntity(self.player)

    self.width = 1280
    self.height = 720

    self.player.x = self.width / 2
    self.player.y = self.height / 2
end

function Game:initStage()
    self.isActive = true

    self.entities:AddEntity(Enemy(100, 100))
    self.entities:AddEntity(Enemy(100, 600))
end

function Game:endStage()
    self.isActive = false
end

function Game:draw()
    if self.isActive then
        self.entities:draw()
    end
end

function Game:keypressed(key)
    if key == 'escape' then
        self.isActive = false
    end
end

function Game:update(delta)
    if self.isActive then
        self.entities:update(delta)
    end
end
