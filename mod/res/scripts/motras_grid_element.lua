local Asset = require('motras_asset')
local Slot = require('motras_slot')
local MatrixUtils = require('motras_matrixutils')
local c = require('motras_constants')
local t = require('motras_types')

local GridElement = {}

function GridElement:new(o)
    if not (o and o.slot) then
        error("Required Property Slot is missing")
    end
    if not (o and o.grid) then
        error("Required Property Grid is missing")
    end
    o.options = o.options or {}
    o.handleFunction = o.handleFunction or function (result)
        
    end
    o.assets = o.assets or {}

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
    for assetId, asset in pairs(self.assets) do
        asset:call(result)
    end
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

function GridElement:hasAsset(assetId, assetType)
    return self:getAsset(assetId) ~= nil and (assetType == nil or self:getAsset(assetId):getType() == assetType)
end

function GridElement:getAsset(assetId)
    return self.assets[assetId]
end

function GridElement:setOptions(options)
    self.options = options
end

function GridElement:getOption(option, default)
    return self.options and self.options[option] or default
end

function GridElement:setAsset(assetId, asset)
    self.assets[assetId] = asset
end

function GridElement:registerAsset(assetId, assetSlot, assetOptions)
    if self:hasAsset(assetId) then
        error("An asset is already registerd with assetId " .. assetId)
    end

    local asset = Asset:new{slot = assetSlot, parent = self, options = assetOptions or {}}
    self:setAsset(assetId, asset)

    return asset
end

function GridElement:addAssetSlot(slotCollection, assetId, options)
    if not slotCollection then
        error('slot collection parameter is required (normally result.slots)')
    end
    if not assetId then
        error('asset id parameter is required')
    end

    options = options or {}
    local assetSlotId = Slot.makeId({
        type = options.assetType or t.ASSET,
        gridX = self:getGridX(),
        gridY = self:getGridY(),
        assetId = assetId
    })

    local position = options.position or {0, 0, 0}
    if not options.global then
        position = {position[1] + self:getAbsoluteX(), position[2] + self:getAbsoluteY(), position[3] + self:getAbsoluteZ()}
        if not options.position then
            position[3] = position[3] + 1
        end
    end

    local transformation = {
        1, 0, 0, 0,
        0, 1, 0, 0,
        0, 0, 1, 0,
        position[1], position[2], position[3], 1
    }

    if options.rotation then
        transformation = MatrixUtils.rotateAroundZAxis(options.rotation, transformation)
    end

    table.insert(slotCollection, {
        id = assetSlotId,
        transf = transformation,
        type = options.slotType or self.grid:getModulePrefix() .. '_asset',
        spacing = options.spacing or c.DEFAULT_ASSET_SLOT_SPACING,
        shape = options.shape or 0
    })
end

function GridElement:hasNeighborLeft()
    return self:getGrid():has(self:getGridX() - 1, self:getGridY())
end

function GridElement:getNeighborLeft()
    return self:getGrid():get(self:getGridX() - 1, self:getGridY())
end

function GridElement:hasNeighborRight()
    return self:getGrid():has(self:getGridX() + 1, self:getGridY())
end

function GridElement:getNeighborRight()
    return self:getGrid():get(self:getGridX() + 1, self:getGridY())
end

function GridElement:hasNeighborTop()
    return self:getGrid():has(self:getGridX(), self:getGridY() + 1)
end

function GridElement:getNeighborTop()
    return self:getGrid():get(self:getGridX(), self:getGridY() + 1)
end

function GridElement:hasNeighborBottom()
    return self:getGrid():has(self:getGridX(), self:getGridY() - 1)
end

function GridElement:getNeighborBottom()
    return self:getGrid():get(self:getGridX(), self:getGridY() - 1)
end

return GridElement