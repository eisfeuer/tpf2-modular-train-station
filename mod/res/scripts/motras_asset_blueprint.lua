local Slot = require('motras_slot')
local DecorationBlueprint = require("motras_decoration_blueprint")

local AssetBlueprint = {}

function AssetBlueprint:new(o)
    o = o or {}
    setmetatable(o, self)
    self.__index = self
    return o
end

function AssetBlueprint:addAsset(slotType, moduleName, assetId, decorationFunc)
    local slotId = Slot.makeId({type = slotType, gridX = self:getGridX(), gridY = self:getGridY(), assetId = assetId})
    self.blueprint:addModuleToTemplate(slotId, moduleName)
    if decorationFunc then
        decorationFunc(DecorationBlueprint:new{assetBlueprint = self, assetId = assetId})
    end
end

function AssetBlueprint:getGridX()
    return self.gridX
end

function AssetBlueprint:getGridY()
    return self.gridY
end

function AssetBlueprint:isOnTopBorder()
    return self.gridY == self.gridEndY
end

function AssetBlueprint:isOnBottomBorder()
    return self.gridY == self.gridStartY
end

function AssetBlueprint:isOnLeftBorder()
    return self.gridX == self.gridStartX
end

function AssetBlueprint:isOnRightBorder()
    return self.gridX == self.gridEndX
end

function AssetBlueprint:getOption(key, default)
    return self.options[key] or default
end

function AssetBlueprint:getHorizontalSize()
    return self.gridEndX - self.gridStartX + 1
end

function AssetBlueprint:horizontalSizeIsEven()
    return self:getHorizontalSize() % 2 == 0
end

function AssetBlueprint:horizontalSizeIsOdd()
    return self:getHorizontalSize() % 2 == 1
end

function AssetBlueprint:getRelativeHorizontalDistanceToCenter()
    if self:horizontalSizeIsEven() then
        return math.abs(self:getGridX() + 0.5)
    end
    return math.abs(self:getGridX())
end

function AssetBlueprint:isNthSegmentFromCenter(n)
    return math.ceil(self:getRelativeHorizontalDistanceToCenter()) == n
end

function AssetBlueprint:isInEveryNthSegmentFromCenter(n)
    return math.ceil(self:getRelativeHorizontalDistanceToCenter()) % n == 0
end

-- platform related function and aliases

function AssetBlueprint:hasIslandPlatformSlots()
    return self:getOption('hasIslandPlatformSlots', false)
end

function AssetBlueprint:isSidePlatformTop()
    return self:isOnTopBorder()
end

function AssetBlueprint:isSidePlatformBottom()
    return self:isOnBottomBorder()
end

function AssetBlueprint:isSidePlatform()
    return self:isOnTopBorder() or self:isOnBottomBorder()
end

function AssetBlueprint:isIslandPlatform()
    return not self:isSidePlatform()
end

function AssetBlueprint:getBlueprint()
    return self.blueprint
end

return AssetBlueprint