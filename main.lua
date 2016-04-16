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
require('classes/menu')
require('classes/log')
require('classes/tweenmanager')

-- List of example modules for showing off functionality.
local modules = {
    isometric = {
        name = 'Isometric Map',
        className = 'IsometricSample',
    },
    linear = {
        name = 'Linear Map',
        className = 'LinearSample',
    },
    topdown = {
        name = 'Top-Down Map',
        className = 'TopDownSample',
    },
    tweens = {
        name = 'Tweens',
        className = 'TweenSample',
    },
}
local currentModule = nil

-- Makes sure angles are always between 0 and 360.
function angle(x)
    return x % 360
end

-- Interpolates linearly between min and max.
function lerp(min, max, percentile, unbound)
    if not unbound then
        percentile = math.max(0, math.min(1, percentile))
    end
    return min + (max - min) * percentile
end

-- Interpolation linearly for angles.
function lerpAngle(min, max, percentile)
    min = angle(min)
    max = angle(max)

    if min > max then
        -- Switch everything around to make sure min is always less than max
        -- (necessary for next step).
        local temp = max
        max = min
        min = temp
        percentile = 1 - percentile
    end

    if math.abs(min - max) > 180 then
        -- Interpolate in the opposite (shorter) direction by putting max on
        -- the other side of min.
        max = max - 360
    end

    return angle(lerp(min, max, percentile))
end

-- Loads and defines all needed textures.
local function LoadTextures()
    textures = TiledTextureAtlas("images/Textures.png")
    --textures:SetTileSize(32, 32)
    --textures:SetTilePadding(2, 2)
    --textures:SetTileOffset(2, 2)
    textures:DefineTile("Spinner1", 1, 1)
    textures:DefineTile("Spinner2", 2, 1)
    textures:DefineTile("Spinner3", 3, 1)
    textures:DefineTile("Spinner4", 4, 1)
end

-- Loads and defines all needed sounds.
local function LoadSounds()
    sounds = {
        menu = {
            love.audio.newSource("sounds/Menu.wav", "static"),
        },
    }
end

-- Play a defined sound.
function PlaySound(id)
    if sounds[id] then
        local sound = sounds[id][math.random(1, #sounds[id])]
        love.audio.rewind(sound)
        love.audio.play(sound)
    end
end

-- Initializes the application.
function love.load()
    love.window.setTitle("Ludum Dare")
    love.window.setMode(1280, 720)

    LoadTextures()
    LoadSounds()

    menu = Menu()

    for moduleName, moduleInfo in pairs(modules) do
        menu:AddItem(moduleInfo.name, function()
            if not moduleInfo.initialized then
                moduleInfo.initialized = true
                require('modules/' .. moduleName)
                moduleInfo.object = _G[moduleInfo.className]()
            end

            currentModule = moduleInfo
        end)
    end

    menu:AddItem("Exit", function()
        love.event.quit()
    end)

    log = Log()
    log:insert('initialized...')
end

-- Handles per-frame state updates.
function love.update(delta)
    menu:update(delta)

    if currentModule and currentModule.object.update then
        currentModule.object:update(delta)
    end
end

-- Draws a frame.
function love.draw()
    -- Clear screen.
    love.graphics.setBackgroundColor(32, 32, 32)
    love.graphics.clear()

    -- Draw active modules.
    if currentModule and currentModule.object.draw then
        love.graphics.push()
        love.graphics.translate(0, 200)
        love.graphics.setColor(255, 255, 255)
        currentModule.object:draw()
        love.graphics.pop()
    end

    love.graphics.setColor(255, 255, 255)
    menu:draw()
    log:draw()
end

-- Handles pressed keys.
function love.keypressed(key, isRepeat)
    menu:keypressed(key)
end
