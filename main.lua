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
}
local currentModule = null

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
    textures = TiledTextureAtlas("images/Textures.png")
    --textures:SetTileSize(32, 32)
    --textures:SetTilePadding(2, 2)
    --textures:SetTileOffset(2, 2)
    textures:DefineTile("Spinner1", 1, 1)
    textures:DefineTile("Spinner2", 2, 1)
    textures:DefineTile("Spinner3", 3, 1)
    textures:DefineTile("Spinner4", 4, 1)
end

local function LoadSounds()
    sounds = {
        --[[menu = {
            love.audio.newSource("sounds/Menu.wav", "static"),
        },--]]
    }
end

function PlaySound(id)
    if sounds[id] then
        local sound = sounds[id][math.random(1, #sounds[id])]
        love.audio.rewind(sound)
        love.audio.play(sound)
    end
end

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

function love.update(delta)
    menu:update(delta)

    if currentModule and currentModule.object.update then
        currentModule.object:update(delta)
    end
end

function love.draw()
    -- Clear screen.
    love.graphics.setBackgroundColor(32, 32, 32)
    love.graphics.clear()

    -- Draw active modules.
    if currentModule and currentModule.object.draw then
        love.graphics.push()
        love.graphics.translate(0, 200)
        currentModule.object:draw()
        love.graphics.pop()
    end

    menu:draw()
    log:draw()
end

function love.keypressed(key, isRepeat)
    menu:keypressed(key)
end
