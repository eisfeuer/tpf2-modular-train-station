local PlatformSurface = require('motras_platform_surface')
local c = require('motras_constants')
local t = require('motras_types')

local PlatformModuleUtils = {}

function PlatformModuleUtils.makePlatform(
    platform,
    models,
    platformRepModel,
    platformEdgeRepModel,
    platformBackRepModel,
    platformSideModel,
    platformEdgeSideLeftModel,
    platformEdgeSideRightModel,
    platformBackSideLeftModel,
    platformBackSideRightModel,
    options
)
    if type(platformRepModel) == 'table' then
        platformRepModel:addToModels(models)
    else
        table.insert(models, {
            id = platformRepModel,
            transf = {
                1, 0, 0, 0,
                0, 1, 0, 0,
                0, 0, 1, 0,
                platform:getAbsoluteX(), platform:getAbsoluteY(), platform:getAbsolutePlatformHeight(), 1
            }
        })
    end

    if not platformEdgeRepModel then
        return
    end

    local topNeightbor = platform.grid:get(platform:getGridX(), platform:getGridY() + 1)
    local btmNeightbor = platform.grid:get(platform:getGridX(), platform:getGridY() - 1)
    local yOffset = platform.grid:getVerticalDistance() / 2

    if topNeightbor:isTrack() then
        table.insert(models, {
            id = platformEdgeRepModel,
            transf = {
                1, 0, 0, 0,
                0, 1, 0, 0,
                0, 0, 1, 0,
                platform:getAbsoluteX(), platform:getAbsoluteY() + yOffset, platform:getAbsolutePlatformHeight(), 1
            }
        })
    end

    if btmNeightbor:isTrack() then
        table.insert(models, {
            id = platformEdgeRepModel,
            transf = {
                -1, 0, 0, 0,
                0, -1, 0, 0,
                0, 0, 1, 0,
                platform:getAbsoluteX(), platform:getAbsoluteY() - yOffset, platform:getAbsolutePlatformHeight(), 1
            }
        })
    end

    if not platformBackRepModel then
        return
    end

    if topNeightbor:isBlank() then
        table.insert(models, {
            id = platformBackRepModel,
            transf = {
                1, 0, 0, 0,
                0, 1, 0, 0,
                0, 0, 1, 0,
                platform:getAbsoluteX(), platform:getAbsoluteY() + yOffset, platform:getAbsolutePlatformHeight(), 1
            }
        })
    end

    if btmNeightbor:isBlank() then
        table.insert(models, {
            id = platformBackRepModel,
            transf = {
                -1, 0, 0, 0,
                0, -1, 0, 0,
                0, 0, 1, 0,
                platform:getAbsoluteX(), platform:getAbsoluteY() - yOffset, platform:getAbsolutePlatformHeight(), 1
            }
        })
    end

    if not platformSideModel then
        return
    end
    if not (platformEdgeSideLeftModel and platformEdgeSideRightModel) then
        error('makePlatform must have exact 1, 2, 3, 6, 8 or 9 parameters')
    end

    local leftNeighbor = platform.grid:get(platform:getGridX() - 1, platform:getGridY())
    local rightNeighbor = platform.grid:get(platform:getGridX() + 1, platform:getGridY())
    local xOffset = platform.grid:getHorizontalDistance() / 2
    

    if leftNeighbor:isBlank() or leftNeighbor:isTrack() then
        table.insert(models, {
            id = platformSideModel,
            transf = {
                1, 0, 0, 0,
                0, 1, 0, 0,
                0, 0, 1, 0,
                platform:getAbsoluteX() - xOffset, platform:getAbsoluteY(), platform:getAbsolutePlatformHeight(), 1
            }
        })
    end

    if rightNeighbor:isBlank() or rightNeighbor:isTrack() then
        table.insert(models, {
            id = platformSideModel,
            transf = {
                -1, 0, 0, 0,
                0, -1, 0, 0,
                0, 0, 1, 0,
                platform:getAbsoluteX() + xOffset, platform:getAbsoluteY(), platform:getAbsolutePlatformHeight(), 1
            }
        })
    end

    if topNeightbor:isTrack() then
        if not (leftNeighbor:isPlatform() and platform.grid:get(platform:getGridX() - 1, platform:getGridY() + 1):isTrack()) then
            table.insert(models, {
                id = platformEdgeSideLeftModel,
                transf = {
                    1, 0, 0, 0,
                    0, 1, 0, 0,
                    0, 0, 1, 0,
                    platform:getAbsoluteX() - xOffset, platform:getAbsoluteY() + yOffset, platform:getAbsolutePlatformHeight(), 1
                }
            })
        end

        if not (rightNeighbor:isPlatform() and platform.grid:get(platform:getGridX() + 1, platform:getGridY() + 1):isTrack()) then
            table.insert(models, {
                id = platformEdgeSideRightModel,
                transf = {
                    1, 0, 0, 0,
                    0, 1, 0, 0,
                    0, 0, 1, 0,
                    platform:getAbsoluteX() + xOffset, platform:getAbsoluteY() + yOffset, platform:getAbsolutePlatformHeight(), 1
                }
            })
        end 
    end

    if btmNeightbor:isTrack() then
        if not (rightNeighbor:isPlatform() and platform.grid:get(platform:getGridX() + 1, platform:getGridY() - 1):isTrack()) then
            table.insert(models, {
                id = platformEdgeSideLeftModel,
                transf = {
                    -1, 0, 0, 0,
                    0, -1, 0, 0,
                    0, 0, 1, 0,
                    platform:getAbsoluteX() + xOffset, platform:getAbsoluteY() - yOffset, platform:getAbsolutePlatformHeight(), 1
                }
            })
        end 

        if not (leftNeighbor:isPlatform() and platform.grid:get(platform:getGridX() - 1, platform:getGridY() - 1):isTrack()) then
            table.insert(models, {
                id = platformEdgeSideRightModel,
                transf = {
                    -1, 0, 0, 0,
                    0, -1, 0, 0,
                    0, 0, 1, 0,
                    platform:getAbsoluteX() - xOffset, platform:getAbsoluteY() - yOffset, platform:getAbsolutePlatformHeight(), 1
                }
            })
        end
    end

    if not platformBackSideLeftModel then
        return
    end
    if not platformBackSideRightModel then
        error('makePlatform must have exact 1, 2, 3, 6, 8 or 9 parameters')
    end

    local addBackEdgesOnConnect = options and options.addBackEdgesOnConnect == true

    if topNeightbor:isBlank() or topNeightbor:isPlatform() then
        if leftNeighbor:isBlank() or leftNeighbor:isTrack() then
            if not addBackEdgesOnConnect then
                table.insert(models, {
                    id = platformBackSideLeftModel,
                    transf = {
                        1, 0, 0, 0,
                        0, 1, 0, 0,
                        0, 0, 1, 0,
                        platform:getAbsoluteX() - xOffset, platform:getAbsoluteY() + yOffset, platform:getAbsolutePlatformHeight(), 1
                    }
                })
            end
        else
            if addBackEdgesOnConnect then
                table.insert(models, {
                    id = platformBackSideLeftModel,
                    transf = {
                        1, 0, 0, 0,
                        0, 1, 0, 0,
                        0, 0, 1, 0,
                        platform:getAbsoluteX() - xOffset, platform:getAbsoluteY() + yOffset, platform:getAbsolutePlatformHeight(), 1
                    }
                })
            end
        end

        if rightNeighbor:isBlank() or rightNeighbor:isTrack() then
            if not addBackEdgesOnConnect then
                table.insert(models, {
                    id = platformBackSideRightModel,
                    transf = {
                        1, 0, 0, 0,
                        0, 1, 0, 0,
                        0, 0, 1, 0,
                        platform:getAbsoluteX() + xOffset, platform:getAbsoluteY() + yOffset, platform:getAbsolutePlatformHeight(), 1
                    }
                })
            end
        else
            if addBackEdgesOnConnect then
                table.insert(models, {
                    id = platformBackSideRightModel,
                    transf = {
                        1, 0, 0, 0,
                        0, 1, 0, 0,
                        0, 0, 1, 0,
                        platform:getAbsoluteX() + xOffset, platform:getAbsoluteY() + yOffset, platform:getAbsolutePlatformHeight(), 1
                    }
                })
            end
        end
    end

    if btmNeightbor:isBlank() or btmNeightbor:isPlatform() then
        if rightNeighbor:isBlank() or rightNeighbor:isTrack() then
            if not addBackEdgesOnConnect then
                table.insert(models, {
                    id = platformBackSideLeftModel,
                    transf = {
                        -1, 0, 0, 0,
                        0, -1, 0, 0,
                        0, 0, 1, 0,
                        platform:getAbsoluteX() + xOffset, platform:getAbsoluteY() - yOffset, platform:getAbsolutePlatformHeight(), 1
                    }
                })
            end
        else
            if addBackEdgesOnConnect then
                table.insert(models, {
                    id = platformBackSideLeftModel,
                    transf = {
                        -1, 0, 0, 0,
                        0, -1, 0, 0,
                        0, 0, 1, 0,
                        platform:getAbsoluteX() + xOffset, platform:getAbsoluteY() - yOffset, platform:getAbsolutePlatformHeight(), 1
                    }
                })
            end
        end

        if leftNeighbor:isBlank() or leftNeighbor:isTrack() then
            if not addBackEdgesOnConnect then
                table.insert(models, {
                    id = platformBackSideRightModel,
                    transf = {
                        -1, 0, 0, 0,
                        0, -1, 0, 0,
                        0, 0, 1, 0,
                        platform:getAbsoluteX() - xOffset, platform:getAbsoluteY() - yOffset, platform:getAbsolutePlatformHeight(), 1
                    }
                })
            end
        else
            if addBackEdgesOnConnect then
                table.insert(models, {
                    id = platformBackSideRightModel,
                    transf = {
                        -1, 0, 0, 0,
                        0, -1, 0, 0,
                        0, 0, 1, 0,
                        platform:getAbsoluteX() - xOffset, platform:getAbsoluteY() - yOffset, platform:getAbsolutePlatformHeight(), 1
                    }
                })
            end
        end
    end
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
    end
end

function PlatformModuleUtils.makePlatformSurfaceWithUnderpathHoles(platform, transformation, mainModel)
    return PlatformSurface:new{
        platform = platform,
        transformation = transformation,
        mainPart = mainModel,
        smallUnderpassAssetIds = c.PLATFORM_40M_SMALL_UNDERPATH_SLOT_IDS,
        largeUnderpassAssetIds = c.PLATFORM_40M_LARGE_UNDERPATH_SLOT_IDS
    }
end

function PlatformModuleUtils.addUnderpassSlots(platform, slots)
    platform:addAssetSlot(slots, 25, {
        assetType = t.UNDERPASS,
        slotType = 'motras_underpass_small',
        position = {-17, 0, platform:getAbsolutePlatformHeight() + 1},
        rotation = 180,
        shape = 1
        --spacing = c.UNDERPASS_SMALL_SPACING
    })
    platform:addAssetSlot(slots, 26, {
        assetType = t.UNDERPASS,
        slotType = 'motras_underpass_small',
        position = {-3, 0, platform:getAbsolutePlatformHeight() + 1},
        rotation = 0,
        shape = 1
        --spacing = c.UNDERPASS_SMALL_SPACING
    })
    platform:addAssetSlot(slots, 27, {
        assetType = t.UNDERPASS,
        slotType = 'motras_underpass_small',
        position = {3, 0, platform:getAbsolutePlatformHeight() + 1},
        rotation = 180,
        shape = 1
        --spacing = c.UNDERPASS_SMALL_SPACING
    })
    platform:addAssetSlot(slots, 28, {
        assetType = t.UNDERPASS,
        slotType = 'motras_underpass_small',
        position = {17, 0, platform:getAbsolutePlatformHeight() + 1},
        rotation = 0,
        shape = 1
        --spacing = c.UNDERPASS_SMALL_SPACING
    })

    if platform:getNeighborBottom():isPlatform() then
        local verticalDistance = platform:getGrid():getVerticalDistance()

        platform:addAssetSlot(slots, 29, {
            assetType = t.UNDERPASS,
            slotType = 'motras_underpass_large',
            position = {-17, -verticalDistance / 2, platform:getAbsolutePlatformHeight() + 1},
            rotation = 180,
            shape = 1
            --spacing = c.UNDERPASS_SMALL_SPACING
        })
        platform:addAssetSlot(slots, 30, {
            assetType = t.UNDERPASS,
            slotType = 'motras_underpass_large',
            position = {-3, -verticalDistance / 2, platform:getAbsolutePlatformHeight() + 1},
            rotation = 0,
            shape = 1
            --spacing = c.UNDERPASS_SMALL_SPACING
        })
        platform:addAssetSlot(slots, 31, {
            assetType = t.UNDERPASS,
            slotType = 'motras_underpass_large',
            position = {3, -verticalDistance / 2, platform:getAbsolutePlatformHeight() + 1},
            rotation = 180,
            shape = 1
            --spacing = c.UNDERPASS_SMALL_SPACING
        })
        platform:addAssetSlot(slots, 32, {
            assetType = t.UNDERPASS,
            slotType = 'motras_underpass_large',
            position = {17, -verticalDistance / 2, platform:getAbsolutePlatformHeight() + 1},
            rotation = 0,
            shape = 1
            --spacing = c.UNDERPASS_SMALL_SPACING
        })
    end
end

return PlatformModuleUtils