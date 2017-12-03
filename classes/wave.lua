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
    spinner = {
        init = function (self)
            local x, y = game.player.x, game.player.y
            while game.player:GetDistanceTo(x, y) < 200 do
                x, y = love.math.random(100, game.width - 100), love.math.random(100, game.height - 100)
            end
            game.entities:AddEntity(Enemy(x, y, 'spinner', {}))
        end,
    },
    seeker = {
        init = function (self)
            for i = 1, 4 do
                game.entities:AddEntity(Enemy(i * 200, -100, 'seeker', {rotation = 180}))
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

    if Wave.types[self.type].update then
        Wave.types[self.type].update(self)
    end
end
