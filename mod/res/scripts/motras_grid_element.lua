local GridElement = {}

function GridElement:new(o)
    if not (o and o.slot) then
        error("Required Property Slot is missing")
    end
    if not (o and o.grid) then
        error("Required Property Grid is missing")
    end
    o.handleFunction = o.handleFunction or function (result)
        
    end

    setmetatable(o, self)
    self.__index = self
    return o
end

function GridElement:getGrid()
    return self.grid
end

function GridElement:getSlotId()
    return self.slot.id
end

function GridElement:getGridType()
    return self.slot.gridType
end

function GridElement:getType()
    return self.slot.type
end

function GridElement:getGridX()
    return self.slot.gridX
end

function GridElement:getGridY()
    return self.slot.gridY
end

function GridElement:isTrack()
    return false
end

function GridElement:isPlatform()
    return false
end

function GridElement:isPlace()
    return false
end

function GridElement:isBlank()
    return false
end

function GridElement:handle(handleFunction)
    self.handleFunction = handleFunction
end

function GridElement:call(result)
    self.handleFunction(result)
end

function GridElement:getAbsoluteX()
    return self.grid:getHorizontalDistance() * self:getGridX()
end

function GridElement:getAbsoluteY()
    return self.grid:getVerticalDistance() * self:getGridY()
end

function GridElement:getAbsoluteZ()
    return self.grid:getBaseHeight()
end

return GridElement