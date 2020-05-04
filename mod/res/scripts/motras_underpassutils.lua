local PathUtils = require('motras_pathutils')
local UnderpassEntry = require('motras_underpass_entry')

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

local function getUnderpass(gridElement, segmentId, neighbor, neighborSegmentId, underpassEntry)
    if gridElement:isPlatform() then
        local underpass = gridElement:getAsset(underpassEntry:getLargeUnderpassIdInSection(segmentId))
            or gridElement:getAsset(underpassEntry:getSmallUnderpassIdInSection(segmentId))
        if underpass then
            return underpass
        end
    end

    if not neighbor:isPlatform() then
        return nil
    end

    return neighbor:getAsset(underpassEntry:getLargeUnderpassIdInSection(neighborSegmentId))
        or neighbor:getAsset(underpassEntry:getSmallUnderpassIdInSection(neighborSegmentId))
end

function UnderpassUtils.addUnderpassLaneToModels(underpassModule, models, smallUnderpassIds, largeUnderpassIds)
    local underpassEntry = UnderpassEntry:new{
        underpassModule = underpassModule,
        smallUnderpassIds = smallUnderpassIds,
        largeUnderpassIds = largeUnderpassIds
    }

    if underpassEntry:isMainEntry() then
        underpassEntry:addEntryConnectionLaneToModelsIfNecessary(models)
    
        local targetUnderpassModule = nil
        local size, section = underpassEntry:getSizeAndSection()

        if section == 1 or section == 4 then
            targetUnderpassModule = findMatchingUnderpassAndGetLength(underpassModule, false, false, function (gridElement)
                if not gridElement:isPlatform() then
                    return nil
                end

                return gridElement:getAsset(underpassEntry:getLargeUnderpassIdInSection(1))
                    or gridElement:getAsset(underpassEntry:getLargeUnderpassIdInSection(4))
                    or gridElement:getAsset(underpassEntry:getSmallUnderpassIdInSection(1))
                    or gridElement:getAsset(underpassEntry:getSmallUnderpassIdInSection(4)) 
            end)
        elseif section == 2 then
            targetUnderpassModule = findMatchingUnderpassAndGetLength(underpassModule, true, false, function (gridElement, leftNeighbor)
                return getUnderpass(gridElement, 2, leftNeighbor, 3, underpassEntry)
            end)
        elseif section == 3 then
            targetUnderpassModule = findMatchingUnderpassAndGetLength(underpassModule, false, true, function (gridElement, leftNeighbor, rightNeighbor)
                return getUnderpass(gridElement, 3, rightNeighbor, 2, underpassEntry)
            end)
        end

        if targetUnderpassModule then
            local targetUnderpassEntry = UnderpassEntry:new{underpassModule = targetUnderpassModule}

            table.insert(models, PathUtils.makePassengerPathModel(underpassEntry:getLaneStartPoint(), targetUnderpassEntry:getLaneEndPoint()))
        end
    end
end

return UnderpassUtils