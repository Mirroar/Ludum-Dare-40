EntityManager = class()

function EntityManager:construct()
    self.entities = {}
end

function EntityManager:AddEntity(entity)
    self.AssertArgumentType(entity, Entity)

    table.insert(self.entities, entity)
end

function EntityManager:GetCount()
    return #(self.entities)
end

function EntityManager:update(delta)
    for _, entity in ipairs(self.entities) do
        entity:update(delta)
    end
end

function EntityManager:draw()
    for _, entity in ipairs(self.entities) do
        entity:draw()
    end
end