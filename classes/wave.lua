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
    double_spinner = {
        init = function (self)
            local x, y = game.player.x, game.player.y
            while game.player:GetDistanceTo(x, y) < 200 or game.player:GetDistanceTo(game.width - x, game.height - y) < 200 do
                x, y = love.math.random(100, game.width - 100), love.math.random(100, game.height - 100)
            end
            game.entities:AddEntity(Enemy(x, y, 'spinner', {}))
            game.entities:AddEntity(Enemy(game.width - x, game.height - y, 'spinner', {}))
        end,
    },
    seeker = {
        init = function (self)
            if love.math.random() < 0.5 then
                for i = 1, love.math.random(1, 5) do
                    game.entities:AddEntity(Enemy(love.math.random(100, game.width), (love.math.random(0, 1) * (game.height + 200)) - 100, 'seeker'))
                end
            else
                for i = 1, love.math.random(1, 5) do
                    game.entities:AddEntity(Enemy((love.math.random(0, 1) * (game.width + 200)) - 100, love.math.random(100, game.height), 'seeker'))
                end
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
