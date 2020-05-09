local Station = require('motras_station')
local Slot = require('motras_slot')
local t = require('motras_types')

local AssetDecorationSlotCache = require('motras_asset_decoration_slot_cache')

describe('AssetDecorationSlotCache', function ()
    describe('addAssetDecorationSlotToCache', function ()
        it('addsAssetDecorationSlotToCache', function ()
            local assetDecorationSlotId = Slot.makeId({type = t.ASSET_DECORATION, gridX = 1, gridY = 2, assetId = 5, assetDecorationId = 4})
            local assetDecorationSlot = Slot:new{id = assetDecorationSlotId}

            local cache = AssetDecorationSlotCache:new{}
            cache:addAssetDecorationSlotToCache(assetDecorationSlot)

            assert.are.equal(assetDecorationSlot, cache:find(assetDecorationSlot))
        end)

        it('getAllAssetDecorationSlotsForAsset', function ()
            local station = Station:new()
            station:initializeAndRegister(Slot.makeId({type = t.PLATFORM, gridX = 1, gridY = 2}))
            local asset = station:initializeAndRegister(Slot.makeId({type = t.PLATFORM, gridX = 1, gridY = 2, assetId = 5}))

            local assetDecorationSlotId = Slot.makeId({type = t.ASSET_DECORATION, gridX = 1, gridY = 2, assetId = 5, assetDecorationId = 4})
            local assetDecorationSlot = Slot:new{id = assetDecorationSlotId}

            local cache = AssetDecorationSlotCache:new{}
            cache:addAssetDecorationSlotToCache(assetDecorationSlot)

            local result = cache:getAllAssetDecorationSlotsForAsset(asset)

            assert.are.equal(assetDecorationSlot, result[4])
        end)

        it('bindAssetDecorationSlotsToAsset', function ()
            local station = Station:new()
            station:initializeAndRegister(Slot.makeId({type = t.PLATFORM, gridX = 1, gridY = 2}))
            local asset = station:initializeAndRegister(Slot.makeId({type = t.ASSET, gridX = 1, gridY = 2, assetId = 5}))

            local assetDecorationSlotId = Slot.makeId({type = t.ASSET_DECORATION, gridX = 1, gridY = 2, assetId = 5, assetDecorationId = 4})
            local assetDecorationSlot = Slot:new{id = assetDecorationSlotId}

            local cache = AssetDecorationSlotCache:new{}
            cache:addAssetDecorationSlotToCache(assetDecorationSlot)

            cache:bindAssetDecorationSlotsToAsset(asset)

            assert.are.equal(assetDecorationSlotId, asset:getDecoration(4):getSlotId())
        end)
    end)
end)