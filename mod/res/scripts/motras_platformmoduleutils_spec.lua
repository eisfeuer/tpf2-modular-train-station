local Station = require('motras_station')
local Slot = require('motras_slot')
local t = require('motras_types')
local c = require('motras_constants')

local PlatformModuleUtils = require('motras_platformmoduleutils')

describe('PlatformModuleUtils', function ()
    describe('addBuildingSlotsFor40mPlatform', function ()
        it('adds no slots when platform is occupied', function ()
            local slots = {}

            local station = Station:new()
            local platform = station:initializeAndRegister(Slot.makeId({type = t.PLATFORM, gridX = 0, gridY = 0}))
            station:initializeAndRegister(Slot.makeId({type = t.PLATFORM, gridX = 0, gridY = 1}))
            station:initializeAndRegister(Slot.makeId({type = t.PLATFORM, gridX = 0, gridY = -1}))

            PlatformModuleUtils.addBuildingSlotsFor40mPlatform(platform, slots)

            assert.are.same({}, slots)
        end)

        it('adds building slots', function ()
            local slots = {}
            local expectedSlots = {}

            local station = Station:new()
            local platform = station:initializeAndRegister(Slot.makeId({type = t.PLATFORM, gridX = 0, gridY = 0}))

            PlatformModuleUtils.addBuildingSlotsFor40mPlatform(platform, slots)

            platform:addAssetSlot(expectedSlots, 1, {
                assetType = t.BUILDING,
                slotType = 'motras_building_platform40m_small',
                position = {-15, 10, 0},
                rotation = 180,
                spacing = c.BUILDING_PLATFORM40M_SMALL_SPACING
            })
            platform:addAssetSlot(expectedSlots, 2, {
                assetType = t.BUILDING,
                slotType = 'motras_building_platform40m_small',
                position = {-5, 10, 0},
                rotation = 180,
                spacing = c.BUILDING_PLATFORM40M_SMALL_SPACING
            })
            platform:addAssetSlot(expectedSlots, 3, {
                assetType = t.BUILDING,
                slotType = 'motras_building_platform40m_small',
                position = {5, 10, 0},
                rotation = 180,
                spacing = c.BUILDING_PLATFORM40M_SMALL_SPACING
            })
            platform:addAssetSlot(expectedSlots, 4, {
                assetType = t.BUILDING,
                slotType = 'motras_building_platform40m_small',
                position = {15, 10, 0},
                rotation = 180,
                spacing = c.BUILDING_PLATFORM40M_SMALL_SPACING
            })

            platform:addAssetSlot(expectedSlots, 5, {
                assetType = t.BUILDING,
                slotType = 'motras_building_platform40m_medium',
                position = {-20, 10, 0},
                rotation = 180,
                spacing = c.BUILDING_PLATFORM40M_MEDIUM_SPACING
            })
            platform:addAssetSlot(expectedSlots, 6, {
                assetType = t.BUILDING,
                slotType = 'motras_building_platform40m_medium',
                position = {-10, 10, 0},
                rotation = 180,
                spacing = c.BUILDING_PLATFORM40M_MEDIUM_SPACING
            })
            platform:addAssetSlot(expectedSlots, 7, {
                assetType = t.BUILDING,
                slotType = 'motras_building_platform40m_medium',
                position = {0, 10, 0},
                rotation = 180,
                spacing = c.BUILDING_PLATFORM40M_MEDIUM_SPACING
            })
            platform:addAssetSlot(expectedSlots, 8, {
                assetType = t.BUILDING,
                slotType = 'motras_building_platform40m_medium',
                position = {10, 10, 0},
                rotation = 180,
                spacing = c.BUILDING_PLATFORM40M_MEDIUM_SPACING
            })

            platform:addAssetSlot(expectedSlots, 9, {
                assetType = t.BUILDING,
                slotType = 'motras_building_platform40m_large',
                position = {-20, 10, 0},
                rotation = 180,
                spacing = c.BUILDING_PLATFORM40M_LARGE_SPACING
            })
            platform:addAssetSlot(expectedSlots, 10, {
                assetType = t.BUILDING,
                slotType = 'motras_building_platform40m_large',
                position = {-10, 10, 0},
                rotation = 180,
                spacing = c.BUILDING_PLATFORM40M_LARGE_SPACING
            })
            platform:addAssetSlot(expectedSlots, 11, {
                assetType = t.BUILDING,
                slotType = 'motras_building_platform40m_large',
                position = {0, 10, 0},
                rotation = 180,
                spacing = c.BUILDING_PLATFORM40M_LARGE_SPACING
            })
            platform:addAssetSlot(expectedSlots, 12, {
                assetType = t.BUILDING,
                slotType = 'motras_building_platform40m_large',
                position = {10, 10, 0},
                rotation = 180,
                spacing = c.BUILDING_PLATFORM40M_LARGE_SPACING
            })

            platform:addAssetSlot(expectedSlots, 35, {
                assetType = t.BUILDING,
                slotType = 'motras_building_platform40m_access',
                position = {0, 10, 0},
                rotation = 180,
                spacing = c.BUILDING_PLATFORM40M_SMALL_SPACING
            })

            -- platform:addAssetSlot(expectedSlots, 49, {
            --     assetType = t.BUILDING,
            --     slotType = 'motras_building_platform40m_underpass',
            --     position = {0, 10, 0},
            --     rotation = 180,
            --     spacing = c.BUILDING_PLATFORM40M_SMALL_SPACING
            -- })

            platform:addAssetSlot(expectedSlots, 13, {
                assetType = t.BUILDING,
                slotType = 'motras_building_platform40m_small',
                position = {15, -10, 0},
                rotation = 0,
                spacing = c.BUILDING_PLATFORM40M_SMALL_SPACING
            })
            platform:addAssetSlot(expectedSlots, 14, {
                assetType = t.BUILDING,
                slotType = 'motras_building_platform40m_small',
                position = {5, -10, 0},
                rotation = 0,
                spacing = c.BUILDING_PLATFORM40M_SMALL_SPACING
            })
            platform:addAssetSlot(expectedSlots, 15, {
                assetType = t.BUILDING,
                slotType = 'motras_building_platform40m_small',
                position = {-5, -10, 0},
                rotation = 0,
                spacing = c.BUILDING_PLATFORM40M_SMALL_SPACING
            })
            platform:addAssetSlot(expectedSlots, 16, {
                assetType = t.BUILDING,
                slotType = 'motras_building_platform40m_small',
                position = {-15, -10, 0},
                rotation = 0,
                spacing = c.BUILDING_PLATFORM40M_SMALL_SPACING
            })

            platform:addAssetSlot(expectedSlots, 17, {
                assetType = t.BUILDING,
                slotType = 'motras_building_platform40m_medium',
                position = {20, -10, 0},
                rotation = 0,
                spacing = c.BUILDING_PLATFORM40M_MEDIUM_SPACING
            })
            platform:addAssetSlot(expectedSlots, 18, {
                assetType = t.BUILDING,
                slotType = 'motras_building_platform40m_medium',
                position = {10, -10, 0},
                rotation = 0,
                spacing = c.BUILDING_PLATFORM40M_MEDIUM_SPACING
            })
            platform:addAssetSlot(expectedSlots, 19, {
                assetType = t.BUILDING,
                slotType = 'motras_building_platform40m_medium',
                position = {0, -10, 0},
                rotation = 0,
                spacing = c.BUILDING_PLATFORM40M_MEDIUM_SPACING
            })
            platform:addAssetSlot(expectedSlots, 20, {
                assetType = t.BUILDING,
                slotType = 'motras_building_platform40m_medium',
                position = {-10, -10, 0},
                rotation = 0,
                spacing = c.BUILDING_PLATFORM40M_MEDIUM_SPACING
            })

            platform:addAssetSlot(expectedSlots, 21, {
                assetType = t.BUILDING,
                slotType = 'motras_building_platform40m_large',
                position = {20, -10, 0},
                rotation = 0,
                spacing = c.BUILDING_PLATFORM40M_LARGE_SPACING
            })
            platform:addAssetSlot(expectedSlots, 22, {
                assetType = t.BUILDING,
                slotType = 'motras_building_platform40m_large',
                position = {10, -10, 0},
                rotation = 0,
                spacing = c.BUILDING_PLATFORM40M_LARGE_SPACING
            })
            platform:addAssetSlot(expectedSlots, 23, {
                assetType = t.BUILDING,
                slotType = 'motras_building_platform40m_large',
                position = {0, -10, 0},
                rotation = 0,
                spacing = c.BUILDING_PLATFORM40M_LARGE_SPACING
            })
            platform:addAssetSlot(expectedSlots, 24, {
                assetType = t.BUILDING,
                slotType = 'motras_building_platform40m_large',
                position = {-10, -10, 0},
                rotation = 0,
                spacing = c.BUILDING_PLATFORM40M_LARGE_SPACING
            })

            platform:addAssetSlot(expectedSlots, 36, {
                assetType = t.BUILDING,
                slotType = 'motras_building_platform40m_access',
                position = {0, -10, 0},
                rotation = 0,
                spacing = c.BUILDING_PLATFORM40M_SMALL_SPACING
            })

            -- platform:addAssetSlot(expectedSlots, 50, {
            --     assetType = t.BUILDING,
            --     slotType = 'motras_building_platform40m_underpass',
            --     position = {0, -10, 0},
            --     rotation = 0,
            --     spacing = c.BUILDING_PLATFORM40M_SMALL_SPACING
            -- })

            assert.are.same(expectedSlots, slots)
        end)
    end)

    describe('makePlatformSurfaceWithUnderpathHoles', function ()
        it ('creates platform surface model', function ()
            local station = Station:new()
            local platform = station:initializeAndRegister(Slot.makeId({type = t.PLATFORM, gridX = 0, gridY = 0}))
            local transformation = {
                1, 0, 0, 0,
                0, 1, 0, 0,
                0, 0, 1, 0,
                0, 0, 0, 1
            }

            local platformSurface = PlatformModuleUtils.makePlatformSurfaceWithUnderpathHoles(platform, transformation, 'main_models.mdl')

            assert.are.equal(platform, platformSurface.platform)
            assert.are.equal(transformation, platformSurface.transformation)
            assert.are.equal('main_models.mdl', platformSurface.mainPart)
            assert.are.equal(c.PLATFORM_40M_SMALL_UNDERPATH_SLOT_IDS, platformSurface.smallUnderpassAssetIds)
            assert.are.equal(c.PLATFORM_40M_LARGE_UNDERPATH_SLOT_IDS, platformSurface.largeUnderpassAssetIds)
        end)
    end)

    describe('makeUnderpassSlots', function ()
        it ('adds slots for small underpath when platform has no neighbor platform', function ()
            local expectedSlots = {}
            local slots = {}

            local station = Station:new()
            local platform = station:initializeAndRegister(Slot.makeId({type = t.PLATFORM, gridX = 0, gridY = 0}))

            platform:addAssetSlot(expectedSlots, 25, {
                assetType = t.BUILDING,
                slotType = 'motras_underpath_small',
                position = {-10, -10, 0},
                rotation = 0,
                shape = 3
                --spacing = c.UNDERPASS_SMALL_SPACING
            })
            platform:addAssetSlot(expectedSlots, 26, {
                assetType = t.BUILDING,
                slotType = 'motras_underpath_small',
                position = {-10, -10, 0},
                rotation = 0,
                shape = 3
                --spacing = c.UNDERPASS_SMALL_SPACING
            })
            platform:addAssetSlot(expectedSlots, 27, {
                assetType = t.BUILDING,
                slotType = 'motras_underpath_small',
                position = {-10, -10, 0},
                rotation = 0,
                shape = 3
                --spacing = c.UNDERPASS_SMALL_SPACING
            })
            platform:addAssetSlot(expectedSlots, 28, {
                assetType = t.BUILDING,
                slotType = 'motras_underpath_small',
                position = {-10, -10, 0},
                rotation = 0,
                shape = 3
                --spacing = c.UNDERPASS_SMALL_SPACING
            })            
        end)
    end)

    describe('addFenceSlots', function ()
        it ('add slots for fences', function ()
            local expectedSlots = {}
            local slots = {}

            local station = Station:new()
            local platform = station:initializeAndRegister(Slot.makeId({type = t.PLATFORM, gridX = 0, gridY = 0}))

            platform:addAssetSlot(expectedSlots, 47, {
                assetType = t.DECORATION,
                slotType = 'motras_fence',
                position = {0, 2.5, platform:getAbsolutePlatformHeight() + 1},
                rotation = 0,
            })
            platform:addAssetSlot(expectedSlots, 48, {
                assetType = t.DECORATION,
                slotType = 'motras_fence',
                position = {0, -2.5, platform:getAbsolutePlatformHeight() + 1},
                rotation = 180,
            })

            PlatformModuleUtils.addFenceSlots(platform, slots)

            assert.are.same(expectedSlots, slots)
        end)

        it ('has not bottom slot when platform has bottom neighbor', function ()
            local expectedSlots = {}
            local slots = {}

            local station = Station:new()
            local platform = station:initializeAndRegister(Slot.makeId({type = t.PLATFORM, gridX = 0, gridY = 0}))
            station:initializeAndRegister(Slot.makeId({type = t.PLATFORM, gridX = 0, gridY = -1}))

            platform:addAssetSlot(expectedSlots, 47, {
                assetType = t.DECORATION,
                slotType = 'motras_fence',
                position = {0, 2.5, platform:getAbsolutePlatformHeight() + 1},
                rotation = 0,
            })

            PlatformModuleUtils.addFenceSlots(platform, slots)

            assert.are.same(expectedSlots, slots)
        end)

    end)
end)