local Slot = require('motras_slot')
local t = require('motras_types')
local AssetBlueprint = require('motras_asset_blueprint')

local Blueprint = {}

function Blueprint:new(o)
    o = o or {}
    o.tpf2Template = o.tpf2Template or {}
    o.platformDecorationFunc = function () end
    o.trackDecorationFunc = function () end
    setmetatable(o, self)
    self.__index = self
    return o
end

function Blueprint:addModuleToTemplate(slotId, moduleName)
    self.tpf2Template[slotId] = moduleName
    return self
end

function Blueprint:createStation(pattern)
    local startY, endY = pattern:getVerticalRange()

    for iY = startY, endY do
        local startX, endX = pattern:getHorizontalRange(iY)
        for iX = startX, endX do
            local slotType, moduleName, options = pattern:getTypeAndModule(iX, iY)
            self:addModuleToTemplate(Slot.makeId{type = slotType, gridX = iX, gridY = iY}, moduleName)

            local assetBlueprint = AssetBlueprint:new{
                blueprint = self,
                gridX = iX,
                gridStartX = startX,
                gridEndX = endX,
                gridY = iY,
                gridStartY = startY,
                gridEndY = endY,
                options = options or {}
            }
            if Slot.getGridTypeFromSlotType(slotType) == t.GRID_TRACK then
                self.trackDecorationFunc(assetBlueprint)
            end
            if Slot.getGridTypeFromSlotType(slotType) == t.GRID_PLATFORM then
                self.platformDecorationFunc(assetBlueprint)
            end
        end
    end

    return self
end

function Blueprint:decorateEachPlatform(platformDecorationFunc)
    self.platformDecorationFunc = platformDecorationFunc
    return self
end

function Blueprint:decorateEachTrack(trackDecorationFunc)
    self.trackDecorationFunc = trackDecorationFunc
    return self
end

function Blueprint:toTpf2Template()
    return self.tpf2Template
end

return Blueprint