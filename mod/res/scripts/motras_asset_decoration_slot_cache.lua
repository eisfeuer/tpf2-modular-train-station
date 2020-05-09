local AssetDecorationSlotCache = {}

local function getOrNew(table, index)
    if not table[index] then
        table[index] = {}
    end

    return table[index]
end

function AssetDecorationSlotCache:new(o)
    o = o or {}
    o.assetDecorationSlots = {}
    setmetatable(o, self)
    self.__index = self
    return o
end

function AssetDecorationSlotCache:addAssetDecorationSlotToCache(assetDecorationSlot)
    local decorationSlotsForGivenAsset = getOrNew(getOrNew(getOrNew(self.assetDecorationSlots, assetDecorationSlot.gridX), assetDecorationSlot.gridY), assetDecorationSlot.assetId)

    if decorationSlotsForGivenAsset[assetDecorationSlot.assetDecorationId] then
        error('decoration slot is occupied')
    end

    decorationSlotsForGivenAsset[assetDecorationSlot.assetDecorationId] = assetDecorationSlot
end

function AssetDecorationSlotCache:find(slot)
    local decorationSlotForGivenGridX = self.assetDecorationSlots[slot.gridX]
    if not decorationSlotForGivenGridX then
        return nil
    end

    local decorationSlotForGivenGridY = decorationSlotForGivenGridX[slot.gridY]
    if not decorationSlotForGivenGridY or slot.assetId == 0 then
        return decorationSlotForGivenGridY
    end

    local decorationSlotForGivenAsset = decorationSlotForGivenGridY[slot.assetId]
    if not decorationSlotForGivenAsset or slot.assetDecorationId == 0 then
        return decorationSlotForGivenAsset
    end

    return decorationSlotForGivenAsset[slot.assetDecorationId]
end

function AssetDecorationSlotCache:getAllAssetDecorationSlotsForAsset(asset)
    return self:find(asset.slot) or {}
end

function AssetDecorationSlotCache:bindAssetDecorationSlotsToAsset(asset)
    for assetDecorationId, assetDecorationSlot in pairs(self:getAllAssetDecorationSlotsForAsset(asset)) do
        asset:registerDecoration(assetDecorationId, assetDecorationSlot)
    end
end

return AssetDecorationSlotCache