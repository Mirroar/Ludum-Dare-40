require('classes/class')
require('classes/textureatlas')
require('classes/tiledtextureatlas')
require('classes/tile')
require('classes/map')
require('classes/entity')
require('classes/bullet')
require('classes/actor')
require('classes/player')
require('classes/entitymanager')

require('modules/topdown')
require('modules/isometric')
require('modules/linear')

function angle(x)
    -- helper function that makes sure angles are always between 0 and 360
    return x % 360
end

function lerp(min, max, percentile)
    -- linear interpolation between min and max
    return min + (max - min) * math.max(0, math.min(1, percentile))
end

function lerpAngle(min, max, percentile)
    -- linear interpolation for angles
    min = angle(min)
    max = angle(max)

    if min > max then
        -- switch everything around to make sure min is always less than max (necessary for next step)
        local temp = max
        max = min
        min = temp
        percentile = 1 - percentile
    end

    if math.abs(min - max) > 180 then
        -- interpolate in the opposite (shorter) direction by putting max on the other side of min
        max = max - 360
    end

    return angle(lerp(min, max, percentile))
end

local function LoadTextures()
end

function love.load()
    LoadTextures()

    topDown = TopDownSample()
    iso = IsometricSample()
    linear = LinearSample()
end

function love.update(delta)
    linear:update(delta)
end

function love.draw()
    love.graphics.setBackgroundColor(32, 32, 32)
    love.graphics.clear()

    topDown:draw()

    love.graphics.translate(500, 100)
    iso:draw()

    love.graphics.translate(-500, 200)
    linear:draw()
end