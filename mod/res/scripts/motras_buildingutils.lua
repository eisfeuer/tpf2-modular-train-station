local BuildingUtils = {}
local Box = require('motras_box')
local ModuleUtils = require('modulesutil')
local Transf = require('transf')
local Vec3 = require('vec3')

function BuildingUtils.isSmallBuilding(buildingModule)
    local assetId = buildingModule:getId()
    if assetId > 12 then
        assetId = assetId - 12
    end

    return assetId < 5
end

function BuildingUtils.isMediumBuilding(buildingModule)
    local assetId = buildingModule:getId()
    if assetId > 12 then
        assetId = assetId - 12
    end

    return assetId > 4 and assetId < 9
end

function BuildingUtils.isLargeBuilding(buildingModule)
    local assetId = buildingModule:getId()
    if assetId > 12 then
        assetId = assetId - 12
    end

    return assetId > 8
end

function BuildingUtils.getLeftNeighborBuildingWithAssetId(buildingModule, assetId)
    local gridNeighbor = buildingModule:getParentGridElement():getNeighborLeft()
    return gridNeighbor:isPlatform() and gridNeighbor:getAsset(assetId) or nil
end

function BuildingUtils.getRightNeighborBuildingWithAssetId(buildingModule, assetId)
    local gridNeighbor = buildingModule:getParentGridElement():getNeighborRight()
    return gridNeighbor:isPlatform() and gridNeighbor:getAsset(assetId) or nil
end

function BuildingUtils.getSmallLeftNeighborBuildingOn40m(buildingModule)
    local assetId = buildingModule:getId()

    if BuildingUtils.isSmallBuilding(buildingModule) then
        if assetId == 1 then
            return BuildingUtils.getLeftNeighborBuildingWithAssetId(buildingModule, 4)
        end

        if assetId == 13 then
            return BuildingUtils.getRightNeighborBuildingWithAssetId(buildingModule, 16)
        end

        return buildingModule:getParentGridElement():getAsset(assetId - 1)
    end

    if BuildingUtils.isLargeBuilding(buildingModule) then
        if assetId == 12 then
            return buildingModule:getParentGridElement():getAsset(1)
        end

        if assetId == 24 then
            return buildingModule:getParentGridElement():getAsset(13)
        end

        if assetId < 13 then
            return BuildingUtils.getLeftNeighborBuildingWithAssetId(buildingModule, assetId - 7)
        end

        return BuildingUtils.getRightNeighborBuildingWithAssetId(buildingModule, assetId - 7)
    end

    if assetId < 13 then
        if assetId < 7 then
            return BuildingUtils.getLeftNeighborBuildingWithAssetId(buildingModule, assetId - 2)
        end
        return buildingModule:getParentGridElement():getAsset(assetId - 6)
    end

    if assetId < 19 then
        return BuildingUtils.getRightNeighborBuildingWithAssetId(buildingModule, assetId - 2)
    end
    return buildingModule:getParentGridElement():getAsset(assetId - 6)
end

function BuildingUtils.getMediumLeftNeighborBuildingOn40m(buildingModule)
    local assetId = buildingModule:getId()

    if BuildingUtils.isSmallBuilding(buildingModule) then
        if assetId == 1 then
            return BuildingUtils.getLeftNeighborBuildingWithAssetId(buildingModule, 8)
        end

        if assetId == 13 then
            return BuildingUtils.getRightNeighborBuildingWithAssetId(buildingModule, 20)
        end

        return buildingModule:getParentGridElement():getAsset(assetId + 3)
    end

    if BuildingUtils.isMediumBuilding(buildingModule) then
        if assetId == 5 or assetId == 6 then
            return BuildingUtils.getLeftNeighborBuildingWithAssetId(buildingModule, assetId + 2)
        end

        if assetId == 17 or assetId == 18 then
            return BuildingUtils.getRightNeighborBuildingWithAssetId(buildingModule, assetId + 2)
        end

        return buildingModule:getParentGridElement():getAsset(assetId - 2)
    end

    if BuildingUtils.isLargeBuilding(buildingModule) then
        if assetId == 12 then
            return buildingModule:getParentGridElement():getAsset(5)
        end

        if assetId == 24 then
            return buildingModule:getParentGridElement():getAsset(17)
        end

        if assetId < 13 then
            return BuildingUtils.getLeftNeighborBuildingWithAssetId(buildingModule, assetId - 3)
        end

        return BuildingUtils.getRightNeighborBuildingWithAssetId(buildingModule, assetId - 3)
    end
end

function BuildingUtils.getLargeLeftNeighborBuildingOn40m(buildingModule)
    local assetId = buildingModule:getId()

    if BuildingUtils.isSmallBuilding(buildingModule) then
        if assetId == 1 or assetId == 2 then
            return BuildingUtils.getLeftNeighborBuildingWithAssetId(buildingModule, assetId + 10)
        end

        if assetId == 13 or assetId == 14 then
            return BuildingUtils.getRightNeighborBuildingWithAssetId(buildingModule, assetId + 10)
        end

        return buildingModule:getParentGridElement():getAsset(assetId + 6)
    end

    if BuildingUtils.isMediumBuilding(buildingModule) then
        if assetId == 8 or assetId == 20 then
            return buildingModule:getParentGridElement():getAsset(assetId + 1)
        end

        if assetId < 13 then
            return BuildingUtils.getLeftNeighborBuildingWithAssetId(buildingModule, assetId + 5)
        end

        return BuildingUtils.getRightNeighborBuildingWithAssetId(buildingModule, assetId + 5)
    end

    if assetId < 13 then
        return BuildingUtils.getLeftNeighborBuildingWithAssetId(buildingModule, assetId)
    end

    return BuildingUtils.getRightNeighborBuildingWithAssetId(buildingModule, assetId)
end

function BuildingUtils.getSmallRightNeighborBuildingOn40m(buildingModule)
    local assetId = buildingModule:getId()

    if BuildingUtils.isSmallBuilding(buildingModule) then
        if assetId == 4 then
            return BuildingUtils.getRightNeighborBuildingWithAssetId(buildingModule, 1)
        end

        if assetId == 16 then
            return BuildingUtils.getLeftNeighborBuildingWithAssetId(buildingModule, 13)
        end

        return buildingModule:getParentGridElement():getAsset(assetId + 1)
    end

    if BuildingUtils.isLargeBuilding(buildingModule) then
        if assetId == 9 then
            return buildingModule:getParentGridElement():getAsset(4)
        end

        if assetId == 21 then
            return buildingModule:getParentGridElement():getAsset(16)
        end

        if assetId < 13 then
            return BuildingUtils.getRightNeighborBuildingWithAssetId(buildingModule, assetId - 10)
        end

        return BuildingUtils.getLeftNeighborBuildingWithAssetId(buildingModule, assetId - 10)
    end

    if assetId == 8 then
        return BuildingUtils.getRightNeighborBuildingWithAssetId(buildingModule, 1)
    end

    if assetId == 20 then
        return BuildingUtils.getLeftNeighborBuildingWithAssetId(buildingModule, 13)
    end

    return buildingModule:getParentGridElement():getAsset(assetId - 3)
end

function BuildingUtils.getMediumRightNeighborBuildingOn40m(buildingModule)
    local assetId = buildingModule:getId()

    if BuildingUtils.isSmallBuilding(buildingModule) then
        if assetId == 3 or assetId == 4 then
            return BuildingUtils.getRightNeighborBuildingWithAssetId(buildingModule, assetId + 2)
        end

        if assetId == 15 or assetId == 16 then
            return BuildingUtils.getLeftNeighborBuildingWithAssetId(buildingModule, assetId + 2)
        end

        return buildingModule:getParentGridElement():getAsset(assetId + 6)
    end

    if BuildingUtils.isMediumBuilding(buildingModule) then
        if assetId == 7 or assetId == 8 then
            return BuildingUtils.getRightNeighborBuildingWithAssetId(buildingModule, assetId - 2)
        end

        if assetId == 19 or assetId == 20 then
            return BuildingUtils.getLeftNeighborBuildingWithAssetId(buildingModule, assetId - 2)
        end

        return buildingModule:getParentGridElement():getAsset(assetId + 2)
    end

    if BuildingUtils.isLargeBuilding(buildingModule) then
        if assetId == 9 then
            return buildingModule:getParentGridElement():getAsset(8)
        end

        if assetId == 21 then
            return buildingModule:getParentGridElement():getAsset(20)
        end

        if assetId < 13 then
            return BuildingUtils.getRightNeighborBuildingWithAssetId(buildingModule, assetId - 5)
        end

        return BuildingUtils.getLeftNeighborBuildingWithAssetId(buildingModule, assetId - 5)
    end
end

function BuildingUtils.getLargeRightNeighborBuildingOn40m(buildingModule)
    local assetId = buildingModule:getId()

    if BuildingUtils.isSmallBuilding(buildingModule) then
        if assetId == 1 or assetId == 13 then
            return buildingModule:getParentGridElement():getAsset(assetId + 11)
        end

        if assetId < 13 then
            return BuildingUtils.getRightNeighborBuildingWithAssetId(buildingModule, assetId + 7)
        end

        return BuildingUtils.getLeftNeighborBuildingWithAssetId(buildingModule, assetId + 7)
    end

    if BuildingUtils.isMediumBuilding(buildingModule) then
        if assetId == 5 or assetId == 17 then
            return buildingModule:getParentGridElement():getAsset(assetId + 7)
        end

        if assetId < 13 then
            return BuildingUtils.getRightNeighborBuildingWithAssetId(buildingModule, assetId + 3)
        end

        return BuildingUtils.getLeftNeighborBuildingWithAssetId(buildingModule, assetId + 3)
    end

    if assetId < 13 then
        return BuildingUtils.getRightNeighborBuildingWithAssetId(buildingModule, assetId)
    end

    return BuildingUtils.getLeftNeighborBuildingWithAssetId(buildingModule, assetId)
end

function BuildingUtils.buildingIsInGroup(buildingModule, groups)
    if not buildingModule then
        return false
    end

    local buildingGroups = buildingModule:getOption('groups', {})

    for i, group in ipairs(groups) do
        for j, buildingGroup in ipairs(buildingGroups) do
            if group == buildingGroup then
                return true
            end
        end
    end

    return false
end

function BuildingUtils.makeConnectableBuilding(buildingModule, result, models, pivot)
    local buildingGroups = buildingModule:getOption('groups', {})
    local connectedLeft = false
    local connectedRight = false

    table.insert(result.models, {
        id = models.mainBuilding,
        transf = pivot
    })

    if #buildingGroups == 0 then
        table.insert(result.models, {
            id = models.endingLeft,
            transf = pivot
        })
    elseif BuildingUtils.buildingIsInGroup(BuildingUtils.getSmallLeftNeighborBuildingOn40m(buildingModule), buildingGroups) then
        table.insert(result.models, {
            id = models.connectionToLeftSmallBuilding or models.endingLeft,
            transf = pivot
        })
        connectedLeft = true
    elseif BuildingUtils.buildingIsInGroup(BuildingUtils.getMediumLeftNeighborBuildingOn40m(buildingModule), buildingGroups) then
        table.insert(result.models, {
            id = models.connectionToLeftMediumBuilding or models.endingLeft,
            transf = pivot
        })
        connectedLeft = true
    elseif BuildingUtils.buildingIsInGroup(BuildingUtils.getLargeLeftNeighborBuildingOn40m(buildingModule), buildingGroups) then
        table.insert(result.models, {
            id = models.connectionToLeftLargeBuilding or models.endingLeft,
            transf = pivot
        })
        connectedLeft = true
    else
        table.insert(result.models, {
            id = models.endingLeft,
            transf = pivot
        })
    end

    if #buildingGroups == 0 then
        table.insert(result.models, {
            id = models.endingRight,
            transf = pivot
        })
    elseif BuildingUtils.buildingIsInGroup(BuildingUtils.getSmallRightNeighborBuildingOn40m(buildingModule), buildingGroups) then
        table.insert(result.models, {
            id = models.connectionToRightSmallBuilding or models.endingRight,
            transf = pivot
        })
        connectedRight = true
    elseif BuildingUtils.buildingIsInGroup(BuildingUtils.getMediumRightNeighborBuildingOn40m(buildingModule), buildingGroups) then
        table.insert(result.models, {
            id = models.connectionToRightMediumBuilding or models.endingRight,
            transf = pivot
        })
        connectedRight = true
    elseif BuildingUtils.buildingIsInGroup(BuildingUtils.getLargeRightNeighborBuildingOn40m(buildingModule), buildingGroups) then
        table.insert(result.models, {
            id = models.connectionToRightLargeBuilding or models.endingRight,
            transf = pivot
        })
        connectedRight = true
    else
        table.insert(result.models, {
            id = models.endingRight,
            transf = pivot
        })
    end

    return connectedLeft, connectedRight
end

function BuildingUtils.makeLot(result, boundingBox, pivot, options)
    options = options or {}

    local terrainAlignmentLists = {
        { type = "EQUAL", faces = { boundingBox:getGroundFace() } },
    }
    
    local mainGroundFace = boundingBox:getGroundFace()
    local forecourtGroundFace = Box:new({boundingBox.pointNeg[1], boundingBox.pointPos[2], 0}, {boundingBox.pointPos[1], boundingBox.pointPos[2] + 2, 0}):getGroundFace()
    
    ModuleUtils.TransformAlignmentFaces(pivot, terrainAlignmentLists)
    for i = 1, #terrainAlignmentLists do
        local t = terrainAlignmentLists[i]
        table.insert(result.terrainAlignmentLists, t)
    end
    
    ModuleUtils.TransformFaces(pivot, mainGroundFace)
    ModuleUtils.TransformFaces(pivot, forecourtGroundFace)

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
        transf = Transf.mul(pivot, Transf.transl(boundingBox:getCenterPointAsVec3())),
        params = {
            halfExtents = boundingBox:getHalfExtends(),
        }
    })
end

return BuildingUtils