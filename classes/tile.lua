Tile = class()

function Tile:cunstruct()
    self.tileType = nil
end

function Tile:SetType(tileType)
    self.tileType = tileType
end

function Tile:GetType()
    return self.tileType
end