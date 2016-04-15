LinearSample = class()

function LinearSample:construct()
    self.sizeX = 10
    --self.sizeY = 7

    self.textures = TiledTextureAtlas("images/Linear.png")
    self.textures:SetTileSize(32, 64)
    self.textures:SetTilePadding(2, 2)
    self.textures:SetTileOffset(2, 2)
    self.textures:DefineTile("Mountain", 1, 1)
    self.textures:DefineTile("MountainGrass", 2, 1)
    self.textures:DefineTile("Grass", 3, 1)
    self.textures:DefineTile("GrassMountain", 4, 1)
    self.textures:DefineTile("Cloud-1-1", 5, 1)
    self.textures:DefineTile("Cloud-1-2", 6, 1)
    self.textures:DefineTile("Cloud-2-1", 7, 1)
    self.textures:DefineTile("Cloud-2-2", 8, 1)
    self.textures:DefineTile("Cloud-3-1", 1, 2)
    self.textures:DefineTile("Cloud-3-2", 2, 2)

    self.map = Map(self.sizeX)
    self.map:SetTileset(self.textures)
    self.map:SetTileOffset(1, 32, 0)
    --self.map:SetTileOffset(2, 0, 32)

    for x = 1, self.sizeX do
        --for y = 1, self.sizeY do
            local tile = self.map:GetTile(x)
            if x < 3 then
                tile:SetType("Mountain")
            else
                if x == 3 then
                    tile:SetType("MountainGrass")
                else
                    if x < 6 then
                        tile:SetType("Grass")
                    else
                        if x == 6 then
                            tile:SetType("GrassMountain")
                        else
                            tile:SetType("Mountain")
                        end
                    end
                end
            end
        --end
    end

    self.cloudOffset = 0
    self.cloudBuffer = 10
    self.cloudLevels = 3
    self.cloudMap = Map(self.sizeX + self.cloudBuffer, self.cloudLevels + 1)
    self.cloudMap:SetTileset(self.textures)
    self.cloudMap:SetTileOffset(1, 32, 0)
    self.cloudMap:SetTileOffset(2, 0, 0) -- this will be changing over time to move the clouds around

    for x = 1, self.sizeX + self.cloudBuffer do
        for y = 2, self.cloudLevels + 1 do
            if math.random() > 0.7 then
                local tile = self.cloudMap:GetTile(x, y)
                tile:SetType("Cloud-"..(y-1).."-"..math.random(1, 2))
            end
        end
    end
end

function LinearSample:update(delta)
    -- move clouds
    self.cloudOffset = self.cloudOffset + delta * 2
    if self.cloudOffset > 32 then
        -- rotate / regenerate tiles and reset offset
        self.cloudOffset = self.cloudOffset - 32

        for x = self.sizeX + self.cloudBuffer - self.cloudLevels, 1, -1 do
            for y = 2, self.cloudLevels + 1 do
                local tile = self.cloudMap:GetTile(x, y)
                self.cloudMap:GetTile(x + (y - 1), y):SetType(tile:GetType())
            end
        end

        for y = 2, self.cloudLevels + 1 do
            for x = 1, y - 1 do
                local tile = self.cloudMap:GetTile(x, y)
                if math.random() > 0.7 then
                    tile:SetType("Cloud-"..(y - 1).."-"..math.random(1, 2))
                else
                    tile:SetType()
                end
            end
        end
    end
    self.cloudMap:SetTileOffset(2, self.cloudOffset, 0)
end

function LinearSample:draw()
    self.map:draw()
    love.graphics.translate(-100, 0)
    love.graphics.setScissor(0, 200, 32 * self.sizeX, 64)
    self.cloudMap:draw()
    love.graphics.setScissor()
    love.graphics.translate(100, 0)
end