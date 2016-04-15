TweenManager = class()

function TweenManager:construct()
    self.tweens = {}

    -- Tween functions take values from 0 to 1.
    self.tweenFunctions = {
        linear = function (x)
            return x
        end,
        square = function (x)
            return x * x
        end,
        sin = function (x)
            return 1 - math.sin(math.pi * (1 - x) / 2)
        end,
        back = function(x)
            return 2 * x * x * x * x * x - x * x
        end,
        bounce = function(x)
            if x < 2 / 15 then
                x = x * 15 / 2 * 2 - 1
                return (1 - x * x) / 8
            elseif x < 5 / 15 then
                x = (x - 2 / 15) * 15 / 3 * 2 - 1
                return (1 - x * x) / 4
            elseif x < 10 / 15 then
                x = (x - 5 / 15) * 15 / 5 * 2 - 1
                return (1 - x * x) / 2
            else
                x = 1 - (x - 10 / 15) * 15 / 5
                return 1 - x * x
            end
        end,
        elastic = function(x)
            return x * x * (x * x * x + math.sin(math.pi * 4 * x))
        end,
    }

    self.defaultSettings = {
        duration = 1,
        type = 'linear',
        direction = 'in',
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
            if tween.direction == 'in' then
                -- Use tween function directly.
                percentage = self.tweenFunctions[tween.type](percentage)
            elseif tween.direction == 'out' then
                -- Mirror tween function at the center.
                percentage = 1 - percentage
                percentage = self.tweenFunctions[tween.type](percentage)
                percentage = 1 - percentage
            elseif tween.direction == 'inout' then
                -- First ease in and then ease out.
                percentage = percentage * 2
                if percentage < 1 then
                    percentage = self.tweenFunctions[tween.type](percentage)
                    percentage = percentage / 2
                else
                    percentage = 2 - percentage
                    percentage = self.tweenFunctions[tween.type](percentage)
                    percentage = 1 - percentage / 2
                end
            elseif tween.direction == 'outin' then
                -- First ease out and then ease in.
                percentage = percentage * 2
                if percentage < 1 then
                    percentage = 1 - percentage
                    percentage = self.tweenFunctions[tween.type](percentage)
                    percentage = (1 - percentage) / 2
                else
                    percentage = percentage - 1
                    percentage = self.tweenFunctions[tween.type](percentage)
                    percentage = (1 + percentage) / 2
                end
            end
            local newValue = lerp(tween.low, tween.high, percentage, true)
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
