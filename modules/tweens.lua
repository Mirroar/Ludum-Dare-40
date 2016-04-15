TweenSample = class()

function TweenSample:construct()
    self.tweens = TweenManager()

    self.objects = {
        {
            name = 'Linear',
            y = 100,
        },
    }

    -- Add some standard properties
    for _, object in pairs(self.objects) do
        if not object.x then
            object.x = 100
        end

        if not object.size then
            object.size = 25
        end

        if not object.color then
            object.color = {255, 255, 255}
        end
    end
end

function TweenSample:draw()
    for _, object in pairs(self.objects) do
        love.graphics.setColor(unpack(object.color))
        love.graphics.circle("fill", object.x, object.y, object.size)
    end
end
