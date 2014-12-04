TopDownSample = class()

function TopDownSample:construct()
    self.sizeX = 7
    self.sizeY = 10

    self.textures = TiledTextureAtlas("images/TopDown.png")
    self.textures:SetTileSize(32, 16)
    self.textures:SetTilePadding(2, 2)
    self.textures:SetTileOffset(2, 2)
    self.textures:DefineTile("Grass1", 2, 2)
    self.textures:DefineTile("Grass2", 4, 1)
    self.textures:DefineTile("GrassTL", 1, 1)
    self.textures:DefineTile("GrassTC", 2, 1)
    self.textures:DefineTile("GrassTR", 3, 1)
    self.textures:DefineTile("GrassCL", 1, 2)
    --self.textures:DefineTile("GrassCC", 2, 2)
    self.textures:DefineTile("GrassCR", 3, 2)
    self.textures:DefineTile("GrassBL", 1, 3)
    self.textures:DefineTile("GrassBC", 2, 3)
    self.textures:DefineTile("GrassBR", 3, 3)

    self.textures:DefineTile("RockTop", 7, 2)
    self.textures:DefineTile("RockBottom", 7, 3)
    self.textures:DefineTile("RockWater", 8, 3)

    self.textures:DefineTile("River", 5, 1)
    self.textures:DefineTile("RiverCliff", 5, 2)
    self.textures:DefineTile("RiverFalling", 5, 3)

    self.map = Map(self.sizeX, self.sizeY)
    self.map:SetTileset(self.textures)
    self.map:SetTileOffset(1, 32, 0)
    self.map:SetTileOffset(2, 0, 16)

    for x = 1, self.sizeX do
        for y = 1, self.sizeY do
            local tile = self.map:GetTile(x, y)
            if y == 1 then
                if x == 1 then
                    tile:SetType("GrassTL")
                else
                    if x == self.sizeX then
                        tile:SetType("GrassTR")
                    else
                        tile:SetType("GrassTC")
                    end
                end
            else
                if y < 7 then
                    if x == 1 then
                        tile:SetType("GrassCL")
                    else
                        if x == self.sizeX then
                            tile:SetType("GrassCR")
                        else
                            tile:SetType("Grass"..math.random(1, 2))
                        end
                    end
                else
                    if y == 7 then
                        if x == 1 then
                            tile:SetType("GrassBL")
                        else
                            if x == self.sizeX then
                                tile:SetType("GrassBR")
                            else
                                tile:SetType("GrassBC")
                            end
                        end
                    else
                    end
                end
            end
        end
    end

    self.objectsMap = Map(self.sizeX, self.sizeY)
    self.objectsMap:SetTileset(self.textures)
    self.objectsMap:SetTileOffset(1, 32, 0)
    self.objectsMap:SetTileOffset(2, 0, 16)
    self.objectsMap:GetTile(4, 2):SetType("RockTop")
    self.objectsMap:GetTile(4, 3):SetType("RockBottom")
    self.objectsMap:GetTile(6, 1):SetType("RockTop")
    self.objectsMap:GetTile(6, 2):SetType("RockBottom")
    self.objectsMap:GetTile(3, 4):SetType("RockTop")
    self.objectsMap:GetTile(3, 5):SetType("RockWater")
    self.objectsMap:GetTile(3, 6):SetType("River")
    self.objectsMap:GetTile(3, 7):SetType("RiverCliff")
    for y = 8, self.sizeY do
        self.objectsMap:GetTile(3, y):SetType("RiverFalling")
    end
end

function TopDownSample:draw()
    self.map:draw()
    self.objectsMap:draw()
end