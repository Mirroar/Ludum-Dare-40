TweenSample = class()

function TweenSample:construct()
    self.tweens = TweenManager()

    self.objects = {
        {
            name = 'Linear',
            y = 100,
            init = function (object)
                object.x = 100
                self.tweens:Tween(object, {x = 300}, nil, object.init)
            end,
        },
        {
            name = 'Slow Bounce',
            y = 150,
            forward = true,
            init = function (object)
                local newX = 300
                if not object.forward then
                    newX = 100
                end
                object.forward = not object.forward

                self.tweens:Tween(object, {x = newX}, {duration = 5}, object.init)
            end,
        },

        {
            name = 'Sizes',
            x = 500,
            y = 100,
            forward = true,
            init = function (object)
                local newSize = 5
                if not object.forward then
                    newSize = 20
                end
                object.forward = not object.forward

                self.tweens:Tween(object, {size = newSize}, {type = 'square'}, function (object)
                    -- Wait a second before tweening again.
                    self.tweens:Tween(object, {size = object.size}, nil, object.init)
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
    for _, object in pairs(self.objects) do
        love.graphics.setColor(unpack(object.color))
        love.graphics.circle("fill", object.x, object.y, object.size)
    end
end

function TweenSample:update(delta)
    self.tweens:update(delta)
end
