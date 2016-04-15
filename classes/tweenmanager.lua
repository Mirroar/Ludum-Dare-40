TweenManager = class()

function TweenManager:construct()
    self.tweens = {}

    self.tweenFunctions = {
        linear = function (x)
            return x
        end,
        square = function (x)
            return x * x
        end,
    }

    self.defaultSettings = {
        duration = 1,
        type = 'linear',
    }
end

function TweenManager:update(delta)
    for object, tweens in pairs(self.tweens) do
        local finishedTweens = {}
        for key, tween in pairs(tweens) do
            tween.currentTime = tween.currentTime + delta
            if tween.currentTime >= tween.duration then
                tween.currentTime = tween.duration
                table.insert(finishedTweens, key)
            end

            local percentage = tween.currentTime / tween.duration
            percentage = self.tweenFunctions[tween.type](percentage)
            local newValue = lerp(tween.low, tween.high, percentage)
            object[key] = newValue
        end

        -- Clean up finished tweens.
        for _, key in ipairs(finishedTweens) do
            local callback = tweens[key].callback
            tweens[key] = nil

            if callback then
                callback(object)
            end
        end
    end
end

function TweenManager:Tween(object, attributes, settings, callback)
    if not settings then
        -- Use default settings to avoid having to create a new table.
        settings = self.defaultSettings
    end

    if not self.tweens[object] then
        self.tweens[object] = {}
    end

    -- Save settings for all attributes.
    for key, value in pairs(attributes) do
        if not object[key] then
            object[key] = 0
        end

        if not self.tweens[object][key] then
            self.tweens[object][key] = {}
        end

        for setting, defaultValue in pairs(self.defaultSettings) do
            if settings[setting] then
                self.tweens[object][key][setting] = settings[setting]
            else
                self.tweens[object][key][setting] = self.defaultSettings[setting]
            end
        end
        self.tweens[object][key].low = object[key]
        self.tweens[object][key].high = value
        self.tweens[object][key].currentTime = 0
        self.tweens[object][key].callback = callback
    end
end