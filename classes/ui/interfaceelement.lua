InterfaceElement = class()

function InterfaceElement:construct(parent)
    if parent then
        parent:AddChild(self)
    end

    self.children = {}
    self.hidden = false
end

function InterfaceElement:AddChild(child)
    self.AssertArgumentType(child, InterfaceElement)

    table.insert(self.children, child)
end

function InterfaceElement:Show()
    self.hidden = false
end

function InterfaceElement:Hide()
    self.hidden = true
end

function InterfaceElement:Draw()
end

function InterfaceElement:DrawWrapper()
    if not self.hidden then
        self:Draw()

        for _, child in ipairs(self.children) do
            child:DrawWrapper()
        end
    end
end