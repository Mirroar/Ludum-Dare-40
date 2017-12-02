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
    local toRemove = {}
    for index, entity in ipairs(self.entities) do
        if delta then
            entity:update(delta)
        end

        if entity.isDestroyed then
            -- We insert entity indexes in reverse order to remove them
            -- from the back later.
            table.insert(toRemove, 1, index)
        end
    end

    for _, index in ipairs(toRemove) do
        table.remove(self.entities, index)
    end
end

function EntityManager:draw()
    for _, entity in ipairs(self.entities) do
        entity:draw()
    end
end
