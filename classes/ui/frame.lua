Frame = class()

function Frame:construct(x, y, width, height)
    self.x = x or 0
    self.y = y or 0
    self.width = width or 32
    self.height = height or 32
end
