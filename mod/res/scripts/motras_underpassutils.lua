local c = require('motras_constants')
local PathUtils = require('motras_pathutils')

local UnderpassUtils = {}

local function findMatchingUnderpassAndGetLength(underpassModule, needsLeftNeighbor, needsRightNeighbor, matchFunction)
    local grid = underpassModule:getGrid()
    local maxYPos = grid:getActiveGridBounds().top
    local gridX = underpassModule:getParentGridElement():getGridX()

    for gridY = underpassModule:getParentGridElement():getGridY() + 1, maxYPos do
        local matching = matchFunction(
            grid:get(gridX, gridY),
            needsLeftNeighbor and grid:get(gridX - 1, gridY),
            needsRightNeighbor and grid:get(gridX + 1, gridY)
        )

        if matching then
            return matching
        end
    end

    return nil
end

local function isInSegment(segmentId, underpassId, smallUnderpassIds, largeUnderpassIds)
    return underpassId == smallUnderpassIds[segmentId] or underpassId == largeUnderpassIds[segmentId]
end

local function getUnderpass(gridElement, segmentId, neighbor, neighborSegmentId, smallUnderpassIds, largeUnderpassIds)
    if gridElement:isPlatform() then
        local underpass = gridElement:getAsset(largeUnderpassIds[segmentId]) or gridElement:getAsset(smallUnderpassIds[segmentId])
        if underpass then
            return underpass
        end
    end

    if not neighbor:isPlatform() then
        return nil
    end

    return neighbor:getAsset(largeUnderpassIds[neighborSegmentId]) or neighbor:getAsset(smallUnderpassIds[neighborSegmentId])
end

local function isLargeUnderpass(underpassId, largeUnderpassIds)
    for i, id in ipairs(largeUnderpassIds) do
        if underpassId == id then
            return true
        end
    end

    return false
end

local function getXOffset(underpassModule, smallUnderpassIds, largeUnderpassIds)
    local underpassId = underpassModule:getId()

    if isInSegment(2, underpassId, smallUnderpassIds, largeUnderpassIds) then
        return -underpassModule:getGrid():getHorizontalDistance() / 2
    end

    if isInSegment(3, underpassId, smallUnderpassIds, largeUnderpassIds) then
        return underpassModule:getGrid():getHorizontalDistance() / 2
    end

    return 0
end

local function getYOffset(underpassId, largeUnderpassIds, verticalDistance)
    return isLargeUnderpass(underpassId, largeUnderpassIds) and (verticalDistance / 2) or 0
end

function UnderpassUtils.addUnderpassLaneToModels(underpassModule, models, smallUnderpassIds, largeUnderpassIds)
    smallUnderpassIds = smallUnderpassIds or c.PLATFORM_40M_SMALL_UNDERPATH_SLOT_IDS
    largeUnderpassIds = largeUnderpassIds or c.PLATFORM_40M_LARGE_UNDERPATH_SLOT_IDS
    local verticalDistance = underpassModule:getGrid():getVerticalDistance()
    local underpassId = underpassModule:getId()
    local targetUnderpassModule = nil

    if isInSegment(1, underpassId, smallUnderpassIds, largeUnderpassIds) or isInSegment(4, underpassId, smallUnderpassIds, largeUnderpassIds) then
        targetUnderpassModule = findMatchingUnderpassAndGetLength(underpassModule, false, false, function (gridElement)
            if not gridElement:isPlatform() then
                return nil
            end

            return gridElement:getAsset(largeUnderpassIds[1]) or gridElement:getAsset(largeUnderpassIds[4]) or gridElement:getAsset(smallUnderpassIds[1]) or gridElement:getAsset(smallUnderpassIds[4]) 
        end)
    elseif isInSegment(2, underpassId, smallUnderpassIds, largeUnderpassIds) then
        targetUnderpassModule = findMatchingUnderpassAndGetLength(underpassModule, true, false, function (gridElement, leftNeighbor)
            return getUnderpass(gridElement, 2, leftNeighbor, 3, smallUnderpassIds, largeUnderpassIds)
        end)
    elseif isInSegment(3, underpassId, smallUnderpassIds, largeUnderpassIds) then
        targetUnderpassModule = findMatchingUnderpassAndGetLength(underpassModule, false, true, function (gridElement, leftNeighbor, rightNeighbor)
            return getUnderpass(gridElement, 3, rightNeighbor, 2, smallUnderpassIds, largeUnderpassIds)
        end)
    end

    if targetUnderpassModule then
        local xPos = underpassModule:getParentGridElement():getAbsoluteX() + getXOffset(underpassModule, smallUnderpassIds, largeUnderpassIds)

        table.insert(models, PathUtils.makePassengerPathModel({
            x = xPos,
            y = underpassModule:getParentGridElement():getAbsoluteY() - getYOffset(underpassId, largeUnderpassIds, verticalDistance),
            z = underpassModule:getOption('underpassFloorHeight', 0) + underpassModule:getParentGridElement():getAbsolutePlatformHeight()
        }, {
            x = xPos,
            y = targetUnderpassModule:getParentGridElement():getAbsoluteY() - getYOffset(targetUnderpassModule:getId(), largeUnderpassIds, verticalDistance),
            z = targetUnderpassModule:getOption('underpassFloorHeight', 0) + targetUnderpassModule:getParentGridElement():getAbsolutePlatformHeight()
        }))
    end
end

return UnderpassUtils