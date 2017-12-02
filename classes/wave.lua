Wave = class()

Wave.types = {
    sideways = {
        init = function (self)
            game.entities:AddEntity(Enemy(-100, 100, 'sideways'))
            game.entities:AddEntity(Enemy(-200, 100, 'sideways'))
            game.entities:AddEntity(Enemy(-300, 100, 'sideways'))

            game.entities:AddEntity(Enemy(game.width + 100, game.height - 100, 'sideways', {dir = "left"}))
            game.entities:AddEntity(Enemy(game.width + 200, game.height - 100, 'sideways', {dir = "left"}))
            game.entities:AddEntity(Enemy(game.width + 300, game.height - 100, 'sideways', {dir = "left"}))

            log:insert('sideways wave initialized')
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
