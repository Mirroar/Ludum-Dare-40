Game = class()

function Game:construct()
    self.isActive = false
end

function Game:initStage()
    self.isActive = true
end

function Game:endStage()
    self.isActive = false
end

function Game:draw()
    if self.isActive then
    end
end

function Game:keypressed(key)
    if key == 'escape' then
        self.isActive = false
    end
end

function Game:update(delta)
    if self.isActive then
    end
end
