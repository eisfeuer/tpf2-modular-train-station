local AssetDecoration = {}

function AssetDecoration:new(o)
    o = o or {}

    if not o.slot and o.parent then
        error ('Required parameter slot or parent is missing')
    end

    o.options = o.options or {}
    o.decorations = {}
    o.handleFunction = function ()

    end

    setmetatable(o, self)
    self.__index = self
    return o
end

function AssetDecoration:getId()
    return self.slot.assetDecorationId
end

function AssetDecoration:getSlotId()
    return self.slot.id
end

function AssetDecoration:getGridX()
    return self.slot.gridX
end

function AssetDecoration:getGridY()
    return self.slot.gridY
end

function AssetDecoration:getAssetId()
    return self.slot.assetId
end

function AssetDecoration:getParentAsset()
    return self.parent
end

function AssetDecoration:getParentGridElement()
    return self.parent:getParentGridElement()
end

function AssetDecoration:setOptions(options)
    for key, value in pairs(options) do
        self:setOption(key, value)
    end
end

function AssetDecoration:setOption(key, value)
    if not self.options then
        self.options = {}
    end

    self.options[key] = value
end

function AssetDecoration:getOption(option, default)
    return self.options[option] or default
end

function AssetDecoration:getGrid()
    return self.parent:getGrid()
end

function AssetDecoration:handle(handleFunction)
    self.handleFunction = handleFunction
end

function AssetDecoration:call(result)
    self.handleFunction(result)
end

return AssetDecoration