local Asset = {}

function Asset:new(o)
    o = o or {}

    if not o.slot and o.parent then
        error ('Required parameter slot or parent is missing')
    end

    o.handleFunction = function ()
        
    end

    setmetatable(o, self)
    self.__index = self
    return o
end

function Asset:getParentGridElement()
    return self.parent
end

function Asset:getGrid()
    return self.parent:getGrid()
end

function Asset:getSlotId()
    return self.slot.id
end

function Asset:getType()
    return self.slot.type
end

function Asset:getGridX()
    return self.slot.gridX
end

function Asset:getGridY()
    return self.slot.gridY
end

function Asset:handle(handleFunction)
    self.handleFunction = handleFunction
end

function Asset:call(result)
    self.handleFunction(result)
end

function Asset:setOptions(options)
    self.options = options
end

function Asset:getOption(option, default)
    return self.options and self.options[option] or default
end


return Asset