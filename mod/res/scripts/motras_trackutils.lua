local TrackUtils = {}

local function rowHasTrackAndPlatform(grid, gridY, bounds)
    if gridY < bounds.bottom then
        return false, false
    end

    local hasTrack = false
    local hasPlatform = false

    for i = bounds.left, bounds.right do
        local gridElement = grid:get(i, gridY)

        hasTrack = hasTrack or gridElement:isTrack()
        hasPlatform = hasPlatform or gridElement:isPlatform()

        if hasTrack and hasPlatform then
            return true, true
        end
    end

    return hasPlatform, hasTrack
end

local function addIdsToAllRowTracks(grid, gridY, bounds, trackId, platformId, displayedId, displayedDestination)
    for i = bounds.left, bounds.right do
        local gridElement = grid:get(i, gridY)
        if gridElement:isTrack() then
            gridElement:setOption('trackId', trackId)
            gridElement:setOption('platformId', platformId)
            gridElement:setOption('displayedId', displayedId)
            gridElement:setOption('displayedDestination', displayedDestination)
        end
    end
end

function TrackUtils.addEdgesToEdgeList(edgeList, edges, snapNodes, tagNodeKey, tagNodes)
    local currentEdgeListCnt = #edgeList.edges

    for index, edge in ipairs(edges) do
        table.insert(edgeList.edges, edge)
    end

    for index, snapNode in ipairs(snapNodes) do
        table.insert(edgeList.snapNodes, snapNode + currentEdgeListCnt)
    end

    if tagNodeKey then
        edgeList.tag2nodes[tagNodeKey] = {}
        for index, node in ipairs(tagNodes) do
            table.insert(edgeList.tag2nodes[tagNodeKey], node + currentEdgeListCnt)
        end
    end
end

local function addTrackIdsToAllTracksOnGridRecursive(grid, displayedNameMapper, gridY, lastRowHasPlatform, currentRowHasTrack, currentRowHasPlatform, trackId, platformId, bounds)
    if gridY < bounds.bottom then
        return
    end

    local nextRowHasPlatform, nextRowHasTrack = rowHasTrackAndPlatform(grid, gridY - 1, bounds)

    if currentRowHasTrack then
        trackId = trackId + 1

        local trackPlatformId = nil
        if lastRowHasPlatform or nextRowHasPlatform then
            platformId = platformId + 1
            trackPlatformId = platformId
        end
        addIdsToAllRowTracks(grid, gridY, bounds, trackId, trackPlatformId, displayedNameMapper:getDisplayedId(trackId, trackPlatformId), displayedNameMapper:getDisplayedDestination(trackId, trackPlatformId))
    end

    addTrackIdsToAllTracksOnGridRecursive(grid, displayedNameMapper, gridY - 1, currentRowHasPlatform, nextRowHasTrack, nextRowHasPlatform, trackId, platformId, bounds)
end

function TrackUtils.addTrackIdsToAllTracksOnGrid(grid, displayedNameMapper)
    local gridBounds = grid:getActiveGridBounds()
    local nextRowHasPlatform, nextRowHasTrack = rowHasTrackAndPlatform(grid, gridBounds.top, gridBounds)

    addTrackIdsToAllTracksOnGridRecursive(grid, displayedNameMapper, gridBounds.top, false, nextRowHasTrack, nextRowHasPlatform, 0, 0, gridBounds)
end

return TrackUtils