local Slot = require('motras_slot')

local DecorationBlueprint = {}

function DecorationBlueprint:new(o)
    o = o or {}
    setmetatable(o, self)
    self.__index = self
    return o
end

function DecorationBlueprint:decorate(slotType, moduleName, assetDecorationId)
    local slotId = Slot.makeId({type = slotType, gridX = self:getGridX(), gridY = self:getGridY(), assetId = self.assetId, assetDecorationId = assetDecorationId})
    self.assetBlueprint:getBlueprint():addModuleToTemplate(slotId, moduleName)
end

function DecorationBlueprint:getGridX()
    return self.assetBlueprint:getGridX()
end

function DecorationBlueprint:getGridY()
    return self.assetBlueprint:getGridY()
end

return DecorationBlueprint