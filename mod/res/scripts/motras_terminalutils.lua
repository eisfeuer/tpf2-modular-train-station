local TerminalUtils = {}

local function getIndexOfTrackWithStopNode(length, isEven, platformIsOverTrack)
    if not isEven then
        return math.ceil(length / 2)
    end

    if platformIsOverTrack then
        return length / 2 + 1
    end

    return length / 2
end

local function getVehicleNodeOverride(track, isEven, platformIsOverTrack)
    if isEven then
        if platformIsOverTrack then
            return track:getAbsoluteEvenTopStopNode()
        end
        return track:getAbsoluteEvenBottomStopNode()
    end

    if platformIsOverTrack then
        return track:getAbsoluteOddTopStopNode()
    end
    return track:getAbsoluteOddBottomStopNode()
end

function TerminalUtils.addTerminal(terminalGroups, models, terminalModel, tracksAndPlatforms)
    local TRACK = 1
    local PLATFORM = 2

    if #tracksAndPlatforms == 0 then
        return
    end

    local isEven = #tracksAndPlatforms % 2 == 0

    local platformIsOverTrack = tracksAndPlatforms[1][TRACK]:getGridY() < tracksAndPlatforms[1][PLATFORM]:getGridY()

    local indexOfTrackWithStopNode = getIndexOfTrackWithStopNode(#tracksAndPlatforms, isEven, platformIsOverTrack)
    local trackWithStopNode = tracksAndPlatforms[indexOfTrackWithStopNode][TRACK]

    local terminalGroup = {
        terminals = {},
        vehicleNodeOverride = getVehicleNodeOverride(trackWithStopNode, isEven, platformIsOverTrack)
    }

    for i, trackAndPlatform in pairs(tracksAndPlatforms) do
        local platform = trackAndPlatform[PLATFORM]
        table.insert(terminalGroup.terminals, {#models, 0})
        table.insert(models, {
            id = terminalModel,
            transf = platformIsOverTrack and platform:getTerminalEdgeBottomTransformation() or platform:getTerminalEdgeTopTransformation()
        })
    end

    table.insert(terminalGroups, terminalGroup)
end

function TerminalUtils.addTerminalsFromGrid(terminalGroups, models, grid, terminalModel, matchFunc)
    local tracksAndPlatformsTop = {}
    local tracksAndPlatformsBottom = {}

    grid:eachActivePosition(function (gridElement, iX, iY) 
        if gridElement:isTrack() and matchFunc(gridElement) then
            local topNeighborGridElement = grid:get(iX, iY + 1)
            if topNeighborGridElement:isPlatform() then
                table.insert(tracksAndPlatformsTop, {gridElement, topNeighborGridElement})
            else
                TerminalUtils.addTerminal(terminalGroups, models, terminalModel, tracksAndPlatformsTop)
                tracksAndPlatformsTop = {}
            end

            local bottomNeighborGridElement = grid:get(iX, iY - 1)
            if bottomNeighborGridElement:isPlatform() then
                table.insert(tracksAndPlatformsBottom, {gridElement, bottomNeighborGridElement})
            else
                TerminalUtils.addTerminal(terminalGroups, models, terminalModel, tracksAndPlatformsBottom)
                tracksAndPlatformsBottom = {}
            end
        else
            TerminalUtils.addTerminal(terminalGroups, models, terminalModel, tracksAndPlatformsTop)
            tracksAndPlatformsTop = {}
            TerminalUtils.addTerminal(terminalGroups, models, terminalModel, tracksAndPlatformsBottom)
            tracksAndPlatformsBottom = {}
        end

        if iX == grid.activeBounds.right then
            TerminalUtils.addTerminal(terminalGroups, models, terminalModel, tracksAndPlatformsTop)
            tracksAndPlatformsTop = {}
            TerminalUtils.addTerminal(terminalGroups, models, terminalModel, tracksAndPlatformsBottom)
            tracksAndPlatformsBottom = {}
        end

    end)
end

return TerminalUtils