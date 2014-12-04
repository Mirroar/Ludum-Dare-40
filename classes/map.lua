-- tiled map class that works with any number of dimensions
Map = class()

function Map:construct(...)
    self.tileset = nil
    self.dimensions = #{...}
    self:SetSize(...)
    self.xTileSize = {}
    self.yTileSize = {}
    for i = 1, self.dimensions do
        self.xTileSize[i] = 16
        self.yTileSize[i] = 16
    end
    self.yTileSize[1] = 0
    if self.dimensions > 1 then
        self.xTileSize[2] = 0
    end
end

function Map:SetSize(...)
    if not self.tiles then self.tiles = {} end

    self:_SetSizeRecursive(self.tiles, self.dimensions, ...)
end

function Map:_SetSizeRecursive(table, dimension, size, ...)
    for i = 1, size do
        if dimension == 1 then
            table[i] = Tile()
        else
            table[i] = {}
            self:_SetSizeRecursive(table[i], dimension - 1, ...)
        end
    end

    --TODO: reduce table if size is less than before
end

function Map:GetTile(...)
    return self:_GetTileRecursive(self.tiles, self.dimensions, ...)
end

function Map:_GetTileRecursive(table, dimension, coord, ...)
    if dimension == 1 then
        return table[coord]
    else
        return self:_GetTileRecursive(table[coord], dimension - 1, ...)
    end
end

function Map:SetTileset(tileset)
    self.AssertArgumentType(tileset, TextureAtlas)

    self.tileset = tileset
end

function Map:SetTileOffset(dimension, xOffset, yOffset)
    self.xTileSize[dimension] = xOffset
    self.yTileSize[dimension] = yOffset
end

function Map:GetScreenPosition(...)
    local coords = {...}
    local x, y = 0, 0
    for i = 1, self.dimensions do
        x = x + self.xTileSize[i] * (coords[i] - 1)
        y = y + self.yTileSize[i] * (coords[i] - 1)
    end

    return x, y
end

-- given a screen position, find tiles that are on that position
function Map:GetTileCoordinates(x, y, validityCallback)
    --TODO: create a better solution than brute-forcing it!
    return self:_GetTileCoordinatesRecursive()
end

function Map:_GetTileCoordinatesRecursive(dimension)
end

function Map:draw()
    self.AssertArgumentType(self.tileset, TextureAtlas)

    self:_DrawRecursive(self.tiles, 1, 0, 0)
end

function Map:_DrawRecursive(table, dimension, currentX, currentY)
    for i = 1, #table do
        if dimension == self.dimensions then
            local tileType = table[i]:GetType()
            if tileType then
                self.tileset:DrawSprite(tileType, currentX, currentY)
            end
        else
            self:_DrawRecursive(table[i], dimension + 1, currentX, currentY)
        end
        currentX = currentX + self.xTileSize[dimension]
        currentY = currentY + self.yTileSize[dimension]
    end
end