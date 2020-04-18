local c = require('motras_constants')

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
    table.insert(models, {
        id = platformRepModel,
        transf = {
            1, 0, 0, 0,
            0, 1, 0, 0,
            0, 0, 1, 0,
            platform:getAbsoluteX(), platform:getAbsoluteY(), platform:getAbsolutePlatformHeight(), 1
        }
    })

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

        if rightNeighbor:isBlank() or rightNeighbor:isTrack() then
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

return PlatformModuleUtils