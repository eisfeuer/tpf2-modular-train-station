local Slot = require('motras_slot')
local t = require('motras_types')
local Station = require('motras_station')

local AssetSlotCache = require('motras_asset_slot_cache')

describe('AssetSlotCache', function ()
    local assetSlotId = Slot.makeId({type = t.UNDERPASS, gridX = 1, gridY = 2, assetId = 3})
    local assetSlot = Slot:new{id = assetSlotId}

    local station = Station:new{}
    local platform = station:initializeAndRegister(Slot.makeId({type = t.PLATFORM, gridX = 1, gridY = 2}))

    describe('addAssetSlot', function ()

        it ('adds asset slot to cache', function ()
            local assetSlotCache = AssetSlotCache:new{}

            assetSlotCache:addAssetSlot(assetSlot)

            assert.are.equal(assetSlot, assetSlotCache.assetSlots[1][2][1])
        end)

        
    end)

    describe('getAllAssetSlotsForGridElement', function ()
        it ('gets all slots for specific grid element', function ()
            local assetSlotCache = AssetSlotCache:new{}

            assetSlotCache:addAssetSlot(assetSlot)

            assert.are.same({
                assetSlot
            }, assetSlotCache:getAllAssetSlotsForGridElement(platform))
        end)

        it ('returns empty table, when no asset slot is added for this element', function ()
            local assetSlotCache = AssetSlotCache:new{}

            local otherPlatform = station:initializeAndRegister(Slot.makeId({type = t.PLATFORM, gridX = 0, gridY = 0}))
            assert.are.same({}, assetSlotCache:getAllAssetSlotsForGridElement(otherPlatform))
        end)
    end)


    describe('bindAssetSlotsToGridElement', function ()
        it ('binds asset slots to grid element', function ()
            local assetSlotCache = AssetSlotCache:new{}

            assetSlotCache:addAssetSlot(assetSlot)
            assetSlotCache:bindAssetSlotsToGridElement(platform)

            assert.are.equal(assetSlotId, platform:getAsset(3):getSlotId())
        end)
    end)

end)