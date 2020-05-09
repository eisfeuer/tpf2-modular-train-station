local Slot = require('motras_slot')

local AssetBlueprint = {}

function AssetBlueprint:new(o)
    o = o or {}
    setmetatable(o, self)
    self.__index = self
    return o
end

function AssetBlueprint:addAssetToTemplate(slotType, moduleName, assetId)
    local slotId = Slot.makeId({type = slotType, gridX = self:getGridX(), gridY = self:getGridY(), assetId = assetId})
    self.blueprint:addModuleToTemplate(slotId, moduleName)
end

function AssetBlueprint:getGridX()
    return self.gridX
end

function AssetBlueprint:getGridY()
    return self.gridY
end

function AssetBlueprint:hasIslandPlatformSlots()
    return self.islandPlatformSlots == true
end

function AssetBlueprint:isSidePlatformTop()
    return self.sidePlatformTop == true
end

function AssetBlueprint:isSidePlatformBottom()
    return self.sidePlatformBottom == true
end

function AssetBlueprint:isSidePlatform()
    return self:isSidePlatformTop() or self:isSidePlatformBottom()
end

function AssetBlueprint:isIslandPlatform()
    return not self:isSidePlatform()
end

return AssetBlueprint