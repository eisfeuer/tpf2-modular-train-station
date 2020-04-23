local AssetSlotCache = {}

function AssetSlotCache:new(o)
    o = o or {}
    o.assetSlots = {}
    setmetatable(o, self)
    self.__index = self
    return o
end

function AssetSlotCache:addAssetSlot(assetSlot)
    if self.assetSlots[assetSlot.gridX] then
        if self.assetSlots[assetSlot.gridX][assetSlot.gridY] then
            table.insert(self.assetSlots[assetSlot.gridX][assetSlot.gridY], assetSlot)
        else
            self.assetSlots[assetSlot.gridX][assetSlot.gridY] = { assetSlot }
        end
    else
        self.assetSlots[assetSlot.gridX] = {
            [assetSlot.gridY] = {assetSlot}
        }
    end
end

function AssetSlotCache:getAllAssetSlotsForGridElement(gridElement)
    local gridX, gridY = gridElement:getGridX(), gridElement:getGridY()
    return (self.assetSlots[gridX] and self.assetSlots[gridX][gridY]) or {}
end

function AssetSlotCache:bindAssetSlotsToGridElement(gridElement)
    for i, assetSlot in ipairs(self:getAllAssetSlotsForGridElement(gridElement)) do
        gridElement:registerAsset(assetSlot.assetId, assetSlot)
    end
end

return AssetSlotCache