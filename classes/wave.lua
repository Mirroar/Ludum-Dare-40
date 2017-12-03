Wave = class()

Wave.types = {
    sideways = {
        init = function (self)
            local dir = 'right'
            local x = 0
            local xOffset = -100
            if love.math.random() < 0.5 then
                dir = 'left'
                x = game.width
                xOffset = 100
            end

            local y = love.math.random(100, game.height - 100)

            for i = 1, 3 do
                game.entities:AddEntity(Enemy(x + xOffset * i, y, 'sideways', {dir = dir, timerSpeed = 0.5}))
            end
        end,
    },
}

function Wave:construct(type)
    self.type = type
    self.timer = 0

    if Wave.types[type].init then
        Wave.types[type].init(self)
    end
end

function Wave:update(delta)
    self.timer = self.timer + delta
end
