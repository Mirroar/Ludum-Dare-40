IsometricSample = class()

function IsometricSample:construct()
    self.sizeX = 7
    self.sizeY = 7
    self.sizeZ = 4

    self.textures = TiledTextureAtlas("images/Isometric.png")
    self.textures:SetTileSize(32, 32)
    self.textures:SetTilePadding(2, 2)
    self.textures:SetTileOffset(2, 2)
    self.textures:DefineTile("Grass1", 1, 1)
    self.textures:DefineTile("Grass2", 2, 1)
    self.textures:DefineTile("Water", 3, 1)

    self.map = Map(self.sizeX, self.sizeY, self.sizeZ)
    self.map:SetTileset(self.textures)
    self.map:SetTileOffset(1, 16, 8)
    self.map:SetTileOffset(2, -16, 8)
    self.map:SetTileOffset(3, 0, -6)

    for x = 1, self.sizeX do
        for y = 1, self.sizeY do
            for z = 1, self.sizeZ do
                local tile = self.map:GetTile(x, y, z)
                if x + 2 * y + math.max(2, z) * 3 < 20 then
                    tile:SetType("Grass"..math.random(2))
                else
                    if z == 1 then
                        tile:SetType("Water")
                    end
                end
            end
        end
    end
end

function IsometricSample:draw()
    love.graphics.translate(100, 0)
    self.map:draw()
end