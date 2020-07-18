local PlatformSurface = require('motras_platform_surface')
local Box = require('motras_box')
local ModuleUtils = require('modulesutil')
local Transf = require('transf')
local ModuleUtils = require('motras_modelutils')
local PlatformBuilder = require('motras_platform_builder')
local PlatformEdge = require('motras_platform_edge')
local PlatformSide = require('motras_platform_side')

local c = require('motras_constants')
local t = require('motras_types')

local PlatformModuleUtils = {}

local function hasNoLargeUnderpassAtSlot(slotId, platform, oppositeNeighbor)
    if not oppositeNeighbor:isPlatform() then
        return true 
    end
    
    return not (platform:hasAsset(slotId) or oppositeNeighbor:hasAsset(slotId))
end

function PlatformModuleUtils.addBuildingSlotsFor40mPlatform(platform, slots)
    if not (platform:isPlatform() or platform:isPlace()) then
        error('Building slots can only placed on platforms or places')
    end

    if not platform:hasNeighborTop() then
        platform:addAssetSlot(slots, 1, {
            assetType = t.BUILDING,
            slotType = 'motras_building_platform40m_small',
            position = {-15, 10, 0},
            rotation = 180,
            spacing = c.BUILDING_PLATFORM40M_SMALL_SPACING
        })
        platform:addAssetSlot(slots, 2, {
            assetType = t.BUILDING,
            slotType = 'motras_building_platform40m_small',
            position = {-5, 10, 0},
            rotation = 180,
            spacing = c.BUILDING_PLATFORM40M_SMALL_SPACING
        })
        platform:addAssetSlot(slots, 3, {
            assetType = t.BUILDING,
            slotType = 'motras_building_platform40m_small',
            position = {5, 10, 0},
            rotation = 180,
            spacing = c.BUILDING_PLATFORM40M_SMALL_SPACING
        })
        platform:addAssetSlot(slots, 4, {
            assetType = t.BUILDING,
            slotType = 'motras_building_platform40m_small',
            position = {15, 10, 0},
            rotation = 180,
            spacing = c.BUILDING_PLATFORM40M_SMALL_SPACING
        })

        platform:addAssetSlot(slots, 5, {
            assetType = t.BUILDING,
            slotType = 'motras_building_platform40m_medium',
            position = {-20, 10, 0},
            rotation = 180,
            spacing = c.BUILDING_PLATFORM40M_MEDIUM_SPACING
        })
        platform:addAssetSlot(slots, 6, {
            assetType = t.BUILDING,
            slotType = 'motras_building_platform40m_medium',
            position = {-10, 10, 0},
            rotation = 180,
            spacing = c.BUILDING_PLATFORM40M_MEDIUM_SPACING
        })
        platform:addAssetSlot(slots, 7, {
            assetType = t.BUILDING,
            slotType = 'motras_building_platform40m_medium',
            position = {0, 10, 0},
            rotation = 180,
            spacing = c.BUILDING_PLATFORM40M_MEDIUM_SPACING
        })
        platform:addAssetSlot(slots, 8, {
            assetType = t.BUILDING,
            slotType = 'motras_building_platform40m_medium',
            position = {10, 10, 0},
            rotation = 180,
            spacing = c.BUILDING_PLATFORM40M_MEDIUM_SPACING
        })

        platform:addAssetSlot(slots, 9, {
            assetType = t.BUILDING,
            slotType = 'motras_building_platform40m_large',
            position = {-20, 10, 0},
            rotation = 180,
            spacing = c.BUILDING_PLATFORM40M_LARGE_SPACING
        })
        platform:addAssetSlot(slots, 10, {
            assetType = t.BUILDING,
            slotType = 'motras_building_platform40m_large',
            position = {-10, 10, 0},
            rotation = 180,
            spacing = c.BUILDING_PLATFORM40M_LARGE_SPACING
        })
        platform:addAssetSlot(slots, 11, {
            assetType = t.BUILDING,
            slotType = 'motras_building_platform40m_large',
            position = {0, 10, 0},
            rotation = 180,
            spacing = c.BUILDING_PLATFORM40M_LARGE_SPACING
        })
        platform:addAssetSlot(slots, 12, {
            assetType = t.BUILDING,
            slotType = 'motras_building_platform40m_large',
            position = {10, 10, 0},
            rotation = 180,
            spacing = c.BUILDING_PLATFORM40M_LARGE_SPACING
        })

        platform:addAssetSlot(slots, 35, {
            assetType = t.BUILDING,
            slotType = 'motras_building_platform40m_access',
            position = {0, 10, 0},
            rotation = 180,
            spacing = c.BUILDING_PLATFORM40M_SMALL_SPACING
        })

        if platform:hasNeighborRight() then
            platform:addAssetSlot(slots, 49, {
                assetType = t.BUILDING,
                slotType = 'motras_building_platform40m_access',
                position = {20, 10, 0},
                rotation = 180,
                spacing = c.BUILDING_PLATFORM40M_SMALL_SPACING
            })
        end
    end

    if not platform:hasNeighborBottom() then
        platform:addAssetSlot(slots, 13, {
            assetType = t.BUILDING,
            slotType = 'motras_building_platform40m_small',
            position = {15, -10, 0},
            rotation = 0,
            spacing = c.BUILDING_PLATFORM40M_SMALL_SPACING
        })
        platform:addAssetSlot(slots, 14, {
            assetType = t.BUILDING,
            slotType = 'motras_building_platform40m_small',
            position = {5, -10, 0},
            rotation = 0,
            spacing = c.BUILDING_PLATFORM40M_SMALL_SPACING
        })
        platform:addAssetSlot(slots, 15, {
            assetType = t.BUILDING,
            slotType = 'motras_building_platform40m_small',
            position = {-5, -10, 0},
            rotation = 0,
            spacing = c.BUILDING_PLATFORM40M_SMALL_SPACING
        })
        platform:addAssetSlot(slots, 16, {
            assetType = t.BUILDING,
            slotType = 'motras_building_platform40m_small',
            position = {-15, -10, 0},
            rotation = 0,
            spacing = c.BUILDING_PLATFORM40M_SMALL_SPACING
        })

        platform:addAssetSlot(slots, 17, {
            assetType = t.BUILDING,
            slotType = 'motras_building_platform40m_medium',
            position = {20, -10, 0},
            rotation = 0,
            spacing = c.BUILDING_PLATFORM40M_MEDIUM_SPACING
        })
        platform:addAssetSlot(slots, 18, {
            assetType = t.BUILDING,
            slotType = 'motras_building_platform40m_medium',
            position = {10, -10, 0},
            rotation = 0,
            spacing = c.BUILDING_PLATFORM40M_MEDIUM_SPACING
        })
        platform:addAssetSlot(slots, 19, {
            assetType = t.BUILDING,
            slotType = 'motras_building_platform40m_medium',
            position = {0, -10, 0},
            rotation = 0,
            spacing = c.BUILDING_PLATFORM40M_MEDIUM_SPACING
        })
        platform:addAssetSlot(slots, 20, {
            assetType = t.BUILDING,
            slotType = 'motras_building_platform40m_medium',
            position = {-10, -10, 0},
            rotation = 0,
            spacing = c.BUILDING_PLATFORM40M_MEDIUM_SPACING
        })

        platform:addAssetSlot(slots, 21, {
            assetType = t.BUILDING,
            slotType = 'motras_building_platform40m_large',
            position = {20, -10, 0},
            rotation = 0,
            spacing = c.BUILDING_PLATFORM40M_LARGE_SPACING
        })
        platform:addAssetSlot(slots, 22, {
            assetType = t.BUILDING,
            slotType = 'motras_building_platform40m_large',
            position = {10, -10, 0},
            rotation = 0,
            spacing = c.BUILDING_PLATFORM40M_LARGE_SPACING
        })
        platform:addAssetSlot(slots, 23, {
            assetType = t.BUILDING,
            slotType = 'motras_building_platform40m_large',
            position = {0, -10, 0},
            rotation = 0,
            spacing = c.BUILDING_PLATFORM40M_LARGE_SPACING
        })
        platform:addAssetSlot(slots, 24, {
            assetType = t.BUILDING,
            slotType = 'motras_building_platform40m_large',
            position = {-10, -10, 0},
            rotation = 0,
            spacing = c.BUILDING_PLATFORM40M_LARGE_SPACING
        })

        platform:addAssetSlot(slots, 36, {
            assetType = t.BUILDING,
            slotType = 'motras_building_platform40m_access',
            position = {0, -10, 0},
            rotation = 0,
            spacing = c.BUILDING_PLATFORM40M_SMALL_SPACING
        })

        if platform:hasNeighborLeft() then
            platform:addAssetSlot(slots, 50, {
                assetType = t.BUILDING,
                slotType = 'motras_building_platform40m_access',
                position = {-20, -10, 0},
                rotation = 0,
                spacing = c.BUILDING_PLATFORM40M_SMALL_SPACING
            })
        end
    end
end

function PlatformModuleUtils.makePlatformSurfaceWithUnderpathHoles(platform, transformation, mainModel, tag)
    return PlatformSurface:new{
        platform = platform,
        transformation = transformation,
        mainPart = mainModel,
        smallUnderpassAssetIds = c.PLATFORM_40M_SMALL_UNDERPATH_SLOT_IDS,
        largeUnderpassAssetIds = c.PLATFORM_40M_LARGE_UNDERPATH_SLOT_IDS,
        tag = tag
    }
end

function PlatformModuleUtils.makeLot(result, platform, options)
    options = options or {}
    local halfVerticalDistance = platform:getGrid():getVerticalDistance() / 2
    local halfHorizontalDistance = platform:getGrid():getHorizontalDistance() / 2
    local boundingBox = Box:new(
        {platform:getAbsoluteX() - halfHorizontalDistance, platform:getAbsoluteY() - halfVerticalDistance, platform:getGrid():getBaseHeight()},
        {platform:getAbsoluteX() + halfHorizontalDistance, platform:getAbsoluteY() + halfVerticalDistance, platform:getAbsolutePlatformHeight() + 0.2}
    )
    
    local mainGroundFace = boundingBox:getGroundFace()
    local forecourtGroundFace = Box:new(
        {boundingBox.pointNeg[1] - 1, boundingBox.pointNeg[2] - 1, boundingBox.pointNeg[3]},
        {boundingBox.pointPos[1] + 1, boundingBox.pointPos[2] + 1, boundingBox.pointPos[3]}
    ):getGroundFace()

    local terrainAlignmentLists = {
        { type = "EQUAL", faces = { forecourtGroundFace } },
    }
    
    for i = 1, #terrainAlignmentLists do
        local t = terrainAlignmentLists[i]
        table.insert(result.terrainAlignmentLists, t)
    end

    table.insert(result.groundFaces, {  
        face = mainGroundFace,
        modes = {
            {
                type = "FILL",
                key = options.mainFill or "shared/asphalt_01.gtex.lua"
            },
            {
                type = "STROKE_OUTER",
                key = options.mainStroke or "street_border.lua"
            },
        },
    })
    table.insert(result.groundFaces, {  
        face = forecourtGroundFace,
        modes = {
            {
                type = "FILL",
                key = options.forecourtFill or "shared/gravel_03.gtex.lua"
            },
            {
                type = "STROKE_OUTER",
                key = options.forecourtStroke or "street_border.lua"
            },
        },
    })

    table.insert(result.colliders, { 
        type = "BOX",
        transf = Transf.transl(boundingBox:getCenterPointAsVec3()),
        params = {
            halfExtents = boundingBox:getHalfExtends(),
        }
    })
end

function PlatformModuleUtils.addUnderpassSlots(platform, slots)
    if (not platform:hasAsset(37) or platform:hasAsset(41)) then
        platform:addAssetSlot(slots, 25, {
            assetType = t.UNDERPASS,
            slotType = 'motras_underpass_small',
            position = {-17, 0, platform:getAbsolutePlatformHeight() + 1},
            rotation = 180,
            shape = 1,
            spacing = {7, 3, 1.5, 1.5}
        })
    end
    if not (platform:hasAsset(38) or platform:hasAsset(42)) then
        platform:addAssetSlot(slots, 26, {
            assetType = t.UNDERPASS,
            slotType = 'motras_underpass_small',
            position = {-3, 0, platform:getAbsolutePlatformHeight() + 1},
            rotation = 0,
            shape = 1,
            spacing = {7, 3, 1.5, 1.5}
        })
    end
    if not (platform:hasAsset(39) or platform:hasAsset(43)) then
        platform:addAssetSlot(slots, 27, {
            assetType = t.UNDERPASS,
            slotType = 'motras_underpass_small',
            position = {3, 0, platform:getAbsolutePlatformHeight() + 1},
            rotation = 180,
            shape = 1,
            spacing = {7, 3, 1.5, 1.5}
        })
    end
    if not (platform:hasAsset(40) or platform:hasAsset(44)) then
        platform:addAssetSlot(slots, 28, {
            assetType = t.UNDERPASS,
            slotType = 'motras_underpass_small',
            position = {17, 0, platform:getAbsolutePlatformHeight() + 1},
            rotation = 0,
            shape = 1,
            spacing = {7, 3, 1.5, 1.5}
        })
    end

    if platform:getNeighborBottom():isPlatform() then
        local verticalDistance = platform:getGrid():getVerticalDistance()

        if not platform:hasAsset(41) then
            platform:addAssetSlot(slots, 29, {
                assetType = t.UNDERPASS,
                slotType = 'motras_underpass_large',
                position = {-17, -verticalDistance / 2, platform:getAbsolutePlatformHeight() + 1},
                rotation = 180,
                shape = 1,
                spacing = c.UNDERPASS_SMALL_SPACING
            })
        end
        if not platform:hasAsset(42) then
            platform:addAssetSlot(slots, 30, {
                assetType = t.UNDERPASS,
                slotType = 'motras_underpass_large',
                position = {-3, -verticalDistance / 2, platform:getAbsolutePlatformHeight() + 1},
                rotation = 0,
                shape = 1,
                spacing = c.UNDERPASS_SMALL_SPACING
            })
        end
        if not platform:hasAsset(43) then
            platform:addAssetSlot(slots, 31, {
                assetType = t.UNDERPASS,
                slotType = 'motras_underpass_large',
                position = {3, -verticalDistance / 2, platform:getAbsolutePlatformHeight() + 1},
                rotation = 180,
                shape = 1,
                spacing = c.UNDERPASS_SMALL_SPACING
            })
        end
        if not platform:hasAsset(44) then
            platform:addAssetSlot(slots, 32, {
                assetType = t.UNDERPASS,
                slotType = 'motras_underpass_large',
                position = {17, -verticalDistance / 2, platform:getAbsolutePlatformHeight() + 1},
                rotation = 0,
                shape = 1,
                spacing = c.UNDERPASS_SMALL_SPACING
            })
        end
    end
end

function PlatformModuleUtils.addDecorationSlots(platform, slots)
    if not platform:hasAsset(25) then
        platform:addAssetSlot(slots, 37, {
            assetType = t.DECORATION,
            slotType = 'motras_decoration_asset',
            position = {-15, 0, platform:getAbsolutePlatformHeight() + 1},
            rotation = 0,
            spacing = {4, 4, 2, 2}
        })
    end
    if not platform:hasAsset(26) then
        platform:addAssetSlot(slots, 38, {
            assetType = t.DECORATION,
            slotType = 'motras_decoration_asset',
            position = {-5, 0, platform:getAbsolutePlatformHeight() + 1},
            rotation = 0,
            spacing = {4, 4, 2, 2}
        })
    end
    if not platform:hasAsset(27) then
        platform:addAssetSlot(slots, 39, {
            assetType = t.DECORATION,
            slotType = 'motras_decoration_asset',
            position = {5, 0, platform:getAbsolutePlatformHeight() + 1},
            rotation = 0,
            spacing = {4, 4, 2, 2}
        })
    end
    if not platform:hasAsset(28) then
        platform:addAssetSlot(slots, 40, {
            assetType = t.DECORATION,
            slotType = 'motras_decoration_asset',
            position = {15, 0, platform:getAbsolutePlatformHeight() + 1},
            rotation = 0,
            spacing = {4, 4, 2, 2}
        })
    end

    if platform:getNeighborBottom():isPlatform() then
        local verticalHalfDistance = -platform:getGrid():getVerticalDistance() / 2

        if not (platform:hasAsset(25) or platform:hasAsset(29))then
            platform:addAssetSlot(slots, 41, {
                assetType = t.DECORATION,
                slotType = 'motras_decoration_asset',
                position = {-15, verticalHalfDistance, platform:getAbsolutePlatformHeight() + 1},
                rotation = 0,
                spacing = {4, 4, 2, 2}
            })
        end
        if not (platform:hasAsset(26) or platform:hasAsset(30)) then
            platform:addAssetSlot(slots, 42, {
                assetType = t.DECORATION,
                slotType = 'motras_decoration_asset',
                position = {-5, verticalHalfDistance, platform:getAbsolutePlatformHeight() + 1},
                rotation = 0,
                spacing = {4, 4, 2, 2}
            })
        end
        if not (platform:hasAsset(27) or platform:hasAsset(31)) then
            platform:addAssetSlot(slots, 43, {
                assetType = t.DECORATION,
                slotType = 'motras_decoration_asset',
                position = {5, verticalHalfDistance, platform:getAbsolutePlatformHeight() + 1},
                rotation = 0,
                spacing = {4, 4, 2, 2}
            })
        end
        if not (platform:hasAsset(28) or platform:hasAsset(32)) then
            platform:addAssetSlot(slots, 44, {
                assetType = t.DECORATION,
                slotType = 'motras_decoration_asset',
                position = {15, verticalHalfDistance, platform:getAbsolutePlatformHeight() + 1},
                rotation = 0,
                spacing = {4, 4, 2, 2}
            })
        end
    end

    if not platform:hasAsset(33) then
        platform:addAssetSlot(slots, 45, {
            assetType = t.DECORATION,
            slotType = 'motras_decoration_lamps',
            position = {0, 0, platform:getAbsolutePlatformHeight() + 5},
            rotation = 0,
            spacing = {20, 20, 2.5, 2.5}
        })

        if platform:getNeighborBottom():isPlatform() and not platform:hasAsset(34) then
            platform:addAssetSlot(slots, 46, {
                assetType = t.DECORATION,
                slotType = 'motras_decoration_lamps',
                position = {0, -platform:getGrid():getVerticalDistance() / 2, platform:getAbsolutePlatformHeight() + 5},
                rotation = 0,
                spacing = {20, 20, 2.5, 2.5}
            })
        end
    end
end

function PlatformModuleUtils.addRoofSlots(platform, slots)
    if not platform:hasAsset(45) then
        platform:addAssetSlot(slots, 33, {
            assetType = t.ROOF,
            slotType = 'motras_roof_small',
            position = {0, 0, platform:getAbsolutePlatformHeight() + 5},
            rotation = 0,
            spacing = {20, 20, 2.5, 2.5}
        })
    -- platform:addAssetSlot(slots, 34, {
    --     assetType = t.ROOF,
    --     slotType = 'motras_roof_small',
    --     position = {0, 0, 1},
    --     rotation = 0,
    --     spacing = {10, 10, 2.5, 2.5}
    -- })
    end
end

function PlatformModuleUtils.addFenceSlots(platform, slots)
    if not platform:hasNeighborTop() then
        platform:addAssetSlot(slots, 47, {
            assetType = t.DECORATION,
            slotType = 'motras_fence',
            position = {0, 2.5, platform:getAbsolutePlatformHeight() + 1},
            rotation = 0,
        })
    end
    if not platform:hasNeighborBottom() then
        platform:addAssetSlot(slots, 48, {
            assetType = t.DECORATION,
            slotType = 'motras_fence',
            position = {0, -2.5, platform:getAbsolutePlatformHeight() + 1},
            rotation = 180,
        })
    end
end

function PlatformModuleUtils.makeFence(asset, transform, zOffset, rotation, addModelFn)
    local platform = asset:getParentGridElement()

    local leftNeighbor = platform:getNeighborLeft()
    local rightNeighbor = platform:getNeighborRight()

    local hasNoOccupiedSlot = function (slotList)
        for i, slotItem in ipairs(slotList) do
            if slotItem[1]:hasAsset(slotItem[2]) and not slotItem[1]:getAsset(slotItem[2]):getOption('keepFence', false) then
                return false
            end
        end

        return true
    end

    if asset:getId() == 47 then
        local outerLeft = {{platform, 1}, {platform, 5}, {platform, 6}, {leftNeighbor, 12}, {platform, 9}, {platform, 10}, {platform, 11}, {leftNeighbor, 49}}
        local innerLeft = {{platform, 2}, {platform, 35}, {platform, 6}, {platform, 7}, {platform, 9}, {platform, 10}, {platform, 11}, {platform, 12}}
        local innerRight = {{platform, 3}, {platform, 35}, {platform, 7}, {platform, 8}, {platform, 10}, {platform, 11}, {platform, 12}, {rightNeighbor, 9}}
        local outerRight = {{platform, 4}, {platform, 8}, {rightNeighbor, 5}, {platform, 11}, {platform, 12}, {rightNeighbor, 9}, {rightNeighbor, 10}, {platform, 49}}

        if hasNoOccupiedSlot(outerLeft) then
            addModelFn(Transf.mul(transform, Transf.rotZTransl(rotation, {x = -15, y = 0.0, z = zOffset})))
        end
        if hasNoOccupiedSlot(innerLeft) then
            addModelFn(Transf.mul(transform, Transf.rotZTransl(rotation, {x = -5, y = 0.0, z = zOffset})))
        end
        if hasNoOccupiedSlot(innerRight) then
            addModelFn(Transf.mul(transform, Transf.rotZTransl(rotation, {x = 5, y = 0.0, z = zOffset})))
        end
        if hasNoOccupiedSlot(outerRight) then
            addModelFn(Transf.mul(transform, Transf.rotZTransl(rotation, {x = 15, y = 0.0, z = zOffset})))
        end
    end

    if asset:getId() == 48 then
        local outerLeft = {{platform, 13}, {platform, 17}, {platform, 18}, {rightNeighbor, 24}, {platform, 21}, {platform, 12}, {platform, 23}, {platform, 50}}
        local innerLeft = {{platform, 14}, {platform, 36}, {platform, 18}, {platform, 19}, {platform, 21}, {platform, 22}, {platform, 23}, {platform, 24}}
        local innerRight = {{platform, 15}, {platform, 36}, {platform, 19}, {platform, 20}, {platform, 22}, {platform, 23}, {platform, 24}, {leftNeighbor, 21}}
        local outerRight = {{platform, 16}, {platform, 20}, {leftNeighbor, 17}, {platform, 23}, {platform, 24}, {leftNeighbor, 21}, {leftNeighbor, 22}, {rightNeighbor, 50}}

        if hasNoOccupiedSlot(outerLeft) then
            addModelFn(Transf.mul(transform, Transf.rotZTransl(rotation, {x = 15, y = 0.0, z = zOffset})))
        end
        if hasNoOccupiedSlot(innerLeft) then
            addModelFn(Transf.mul(transform, Transf.rotZTransl(rotation, {x = 5, y = 0.0, z = zOffset})))
        end
        if hasNoOccupiedSlot(innerRight) then
            addModelFn(Transf.mul(transform, Transf.rotZTransl(rotation, {x = -5, y = 0.0, z = zOffset})))
        end
        if hasNoOccupiedSlot(outerRight) then
            addModelFn(Transf.mul(transform, Transf.rotZTransl(rotation, {x = -15, y = 0.0, z = zOffset})))
        end
    end
end

function PlatformModuleUtils.makePlatformModule(platform, result, transform, tag, slotId, addModelFn, params)
    PlatformModuleUtils.addBuildingSlotsFor40mPlatform(platform, result.slots)
    PlatformModuleUtils.addUnderpassSlots(platform, result.slots)

    PlatformModuleUtils.addDecorationSlots(platform, result.slots)
    PlatformModuleUtils.addRoofSlots(platform, result.slots)
    PlatformModuleUtils.addFenceSlots(platform, result.slots)

    platform:handle(function (moduleResult)
        local platformHeightTransform = platform:applyPlatformHeightOnTransformation(transform)
        PlatformModuleUtils.makeLot(result, platform)

        local boundingBox = Box:new(
            {platform:getAbsoluteX() - 20, platform:getAbsoluteY() - 2.5, 0},
            {platform:getAbsoluteX() + 20, platform:getAbsoluteY() + 2.5, platform:getAbsolutePlatformHeight()}
        )

        table.insert(result.terrainAlignmentLists, { type = "EQUAL", faces = { boundingBox:getGroundFace() } })

        local platformSurface = PlatformModuleUtils.makePlatformSurfaceWithUnderpathHoles(platform, {
            1, 0, 0, 0,
            0, 1, 0, 0,
            0, 0, 1, 0,
            platform:getAbsoluteX(), platform:getAbsoluteY(), platform:getAbsolutePlatformHeight(), 1
        }, 'station/rail/motras/platform_stairs_main.mdl', tag):addOuterLeftSegment(
            'station/rail/motras/platform_stairs_1_1.mdl', 'station/rail/motras/platform_stairs_1_2.mdl', 'station/rail/motras/platform_stairs_1_3.mdl', 'station/rail/motras/platform_stairs_1_4.mdl'
        ):addInnerLeftSegment(
            'station/rail/motras/platform_stairs_2_1.mdl', 'station/rail/motras/platform_stairs_2_2.mdl', 'station/rail/motras/platform_stairs_2_3.mdl', 'station/rail/motras/platform_stairs_2_4.mdl'
        ):addInnerRightSegment(
            'station/rail/motras/platform_stairs_3_1.mdl', 'station/rail/motras/platform_stairs_3_2.mdl', 'station/rail/motras/platform_stairs_3_3.mdl', 'station/rail/motras/platform_stairs_3_4.mdl'
        ):addOuterRightSegment(
            'station/rail/motras/platform_stairs_4_1.mdl', 'station/rail/motras/platform_stairs_4_2.mdl', 'station/rail/motras/platform_stairs_4_3.mdl', 'station/rail/motras/platform_stairs_4_4.mdl'
        )
        local platformEdgeOnTrack = PlatformEdge:new{
            platform = platform,
            repeatingModel = 'station/rail/motras/platform_edge_rep.mdl',
            leftEndModel = 'station/rail/motras/platform_edge_side_left.mdl',
            rightEndModel = 'station/rail/motras/platform_edge_side_right.mdl',
            transformation = platformHeightTransform,
            tag = tag
        }
        local platformEdgeBack = PlatformEdge:new{
            platform = platform,
            repeatingModel = 'station/rail/motras/platform_back_rep.mdl',
            leftConnectionModel = 'station/rail/motras/platform_back_side_left.mdl',
            rightConnectionModel = 'station/rail/motras/platform_back_side_right.mdl',
            transformation = platformHeightTransform,
            tag = tag
        }
        local platformSide = PlatformSide:new{
            platform = platform,
            repeatingModel = 'station/rail/motras/platform_side.mdl',
            transformation = platformHeightTransform,
            tag = tag
        }

        PlatformBuilder:new{
            platform = platform,
            surface = platformSurface,
            platformEdgeOnTrack = platformEdgeOnTrack,
            platformEdge = platformEdgeBack,
            platformSide = platformSide
        }:addToModels(result.models)
    end)
    
    platform:handleTerminals(function (addTerminal, directionFactor)
        local passengerTerminalModel = 'station/rail/motras/path/passenger_terminal_10m.mdl'
        local oppositeNeighbor = platform:getGrid():get(platform:getGridX(), platform:getGridY() - directionFactor)
        local hasNoTrackOnOppositeSide = not oppositeNeighbor:isTrack()

        if not platform:hasAsset(25) then
            addTerminal(passengerTerminalModel, platform:getGlobalTransformationBasedOnPlatformTop({x = -15, y =  1.5 * directionFactor}, directionFactor), 0)
            if hasNoTrackOnOppositeSide and hasNoLargeUnderpassAtSlot(29, platform, oppositeNeighbor) then
                addTerminal(passengerTerminalModel, platform:getGlobalTransformationBasedOnPlatformTop({x = -15, y =  -1.5 * directionFactor}, directionFactor), 0)
            end
        end
        if not platform:hasAsset(26) then
            addTerminal(passengerTerminalModel, platform:getGlobalTransformationBasedOnPlatformTop({x = -5, y =  1.5 * directionFactor}, directionFactor), 0)
            if hasNoTrackOnOppositeSide and hasNoLargeUnderpassAtSlot(30, platform, oppositeNeighbor) then
                addTerminal(passengerTerminalModel, platform:getGlobalTransformationBasedOnPlatformTop({x = -5, y =  -1.5 * directionFactor}, directionFactor), 0)
            end
        end
        if not platform:hasAsset(27) then
            addTerminal(passengerTerminalModel, platform:getGlobalTransformationBasedOnPlatformTop({x = 5, y =  1.5 * directionFactor}, directionFactor), 0)
            if hasNoTrackOnOppositeSide and hasNoLargeUnderpassAtSlot(31, platform, oppositeNeighbor) then
                addTerminal(passengerTerminalModel, platform:getGlobalTransformationBasedOnPlatformTop({x = 5, y =  -1.5 * directionFactor}, directionFactor), 0)
            end
        end
        if not platform:hasAsset(28) then
            addTerminal(passengerTerminalModel, platform:getGlobalTransformationBasedOnPlatformTop({x = 15, y =  1.5 * directionFactor}, directionFactor), 0)
            if hasNoTrackOnOppositeSide and hasNoLargeUnderpassAtSlot(32, platform, oppositeNeighbor) then
                addTerminal(passengerTerminalModel, platform:getGlobalTransformationBasedOnPlatformTop({x = 15, y =  -1.5 * directionFactor}, directionFactor), 0)
            end
        end
    end)
    
end

return PlatformModuleUtils