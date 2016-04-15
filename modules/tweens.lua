TweenSample = class()

function TweenSample:construct()
    self.tweens = TweenManager()

    self.objects = {
        {
            name = 'Ease In',
            y = 100,
            init = function (object)
                self.tweens:Tween(object, {x = 300}, {type = 'square'}, function()
                    self.tweens:Tween(object, {x = 100}, {type = 'square'}, object.init)
                end)
            end,
        },
        {
            name = 'Linear',
            y = 150,
            init = function (object)
                self.tweens:Tween(object, {x = 300}, nil, function()
                    self.tweens:Tween(object, {x = 100}, nil, object.init)
                end)
            end,
        },
        {
            name = 'Ease Out',
            y = 200,
            init = function (object)
                self.tweens:Tween(object, {x = 300}, {type = 'square', direction = 'out'}, function()
                    self.tweens:Tween(object, {x = 100}, {type = 'square', direction = 'out'}, object.init)
                end)
            end,
        },
        {
            name = 'Ease In and Out',
            y = 250,
            init = function (object)
                self.tweens:Tween(object, {x = 300}, {type = 'square', direction = 'inout'}, function()
                    self.tweens:Tween(object, {x = 100}, {type = 'square', direction = 'inout'}, object.init)
                end)
            end,
        },
        {
            name = 'Ease Out and In',
            y = 300,
            init = function (object)
                self.tweens:Tween(object, {x = 300}, {type = 'square', direction = 'outin'}, function()
                    self.tweens:Tween(object, {x = 100}, {type = 'square', direction = 'outin'}, object.init)
                end)
            end,
        },
        {
            name = 'Ease In and Out using math.sin',
            y = 350,
            init = function (object)
                self.tweens:Tween(object, {x = 300}, {type = 'sin', direction = 'inout'}, function()
                    self.tweens:Tween(object, {x = 100}, {type = 'sin', direction = 'inout'}, object.init)
                end)
            end,
        },
        {
            name = 'Ease Out and In using math.sin',
            y = 400,
            init = function (object)
                self.tweens:Tween(object, {x = 300}, {type = 'sin', direction = 'outin'}, function()
                    self.tweens:Tween(object, {x = 100}, {type = 'sin', direction = 'outin'}, object.init)
                end)
            end,
        },
        {
            name = 'Ease In and Out using backswing',
            y = 450,
            init = function (object)
                self.tweens:Tween(object, {x = 300}, {type = 'back', direction = 'inout'}, function()
                    self.tweens:Tween(object, {x = 100}, {type = 'back', direction = 'inout'}, object.init)
                end)
            end,
        },
        {
            name = 'Ease In and Out using elastic',
            y = 500,
            init = function (object)
                self.tweens:Tween(object, {x = 300}, {type = 'elastic', direction = 'inout', duration = 4}, function()
                    self.tweens:Tween(object, {x = 100}, {type = 'elastic', direction = 'inout', duration = 4}, object.init)
                end)
            end,
        },

        {
            name = 'Slow Bounce',
            x = 800,
            y = 100,
            init = function (object)
                object.x = 800
                object.y = 100
                self.tweens:Tween(object, {y = 300}, {type = 'bounce', duration = 3, direction = 'out'})
                self.tweens:Tween(object, {x = 1000}, {duration = 4}, object.init)
            end,
        },

        {
            name = 'Sizes',
            x = 500,
            y = 150,
            forward = true,
            init = function (object)
                local newSize = 5
                if not object.forward then
                    newSize = 20
                end
                object.forward = not object.forward

                self.tweens:Tween(object, {size = newSize}, {type = 'square', direction = 'inout'}, function (object)
                    -- Wait a second before tweening again.
                    self.tweens:Tween(object, {size = object.size}, nil, object.init)
                end)
            end,
        },

        {
            name = 'Circle',
            x = 500,
            y = 300,
            size = 5,
            color = {0, 255, 0},
            init = function (object)
                self.tweens:Tween(object, {x = 600}, {type = 'sin', direction = 'in'}, function (object)
                    self.tweens:Tween(object, {x = 700}, {type = 'sin', direction = 'out'}, function (object)
                        self.tweens:Tween(object, {x = 600}, {type = 'sin', direction = 'in'}, function (object)
                            self.tweens:Tween(object, {x = 500}, {type = 'sin', direction = 'out'}, object.init)
                        end)
                    end)
                end)
                self.tweens:Tween(object, {y = 200}, {type = 'sin', direction = 'out'}, function (object)
                    self.tweens:Tween(object, {y = 300}, {type = 'sin', direction = 'in'}, function (object)
                        self.tweens:Tween(object, {y = 400}, {type = 'sin', direction = 'out'}, function (object)
                            self.tweens:Tween(object, {y = 300}, {type = 'sin', direction = 'in'}, nil)
                        end)
                    end)
                end)
            end,
        },
        {
            name = 'Not a Circle',
            x = 700,
            y = 300,
            size = 5,
            color = {255, 0, 0},
            init = function (object)
                self.tweens:Tween(object, {x = 600}, {type = 'square', direction = 'in'}, function (object)
                    self.tweens:Tween(object, {x = 500}, {type = 'square', direction = 'out'}, function (object)
                        self.tweens:Tween(object, {x = 600}, {type = 'square', direction = 'in'}, function (object)
                            self.tweens:Tween(object, {x = 700}, {type = 'square', direction = 'out'}, object.init)
                        end)
                    end)
                end)
                self.tweens:Tween(object, {y = 400}, {type = 'square', direction = 'out'}, function (object)
                    self.tweens:Tween(object, {y = 300}, {type = 'square', direction = 'in'}, function (object)
                        self.tweens:Tween(object, {y = 200}, {type = 'square', direction = 'out'}, function (object)
                            self.tweens:Tween(object, {y = 300}, {type = 'square', direction = 'in'}, nil)
                        end)
                    end)
                end)
            end,
        },
    }

    -- Add some standard properties
    for _, object in pairs(self.objects) do
        if not object.x then
            object.x = 100
        end

        if not object.size then
            object.size = 20
        end

        if not object.color then
            object.color = {255, 255, 255}
        end

        -- Call init function.
        if object.init then
            object:init()
        end
    end
end

function TweenSample:draw()
    love.graphics.setColor(128, 128, 128)
    love.graphics.circle("line", 600, 300, 100)

    for _, object in pairs(self.objects) do
        love.graphics.setColor(unpack(object.color))
        love.graphics.circle("fill", object.x, object.y, object.size)
    end
end

function TweenSample:update(delta)
    self.tweens:update(delta)
end
