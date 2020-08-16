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

function TerminalUtils.addTerminal(terminalGroups, models, tracksAndPlatforms)
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

    local addTerminalFunc = function (terminalModel, transformation, terminalId)
        terminalId = terminalId or 0

        table.insert(terminalGroup.terminals, {#models, terminalId})
        table.insert(models, {
            id = terminalModel,
            transf = transformation
        })
    end

    for i, trackAndPlatform in pairs(tracksAndPlatforms) do
        local platform = trackAndPlatform[PLATFORM]
        platform:callTerminalHandling(addTerminalFunc, platformIsOverTrack and -1 or 1, platformIsOverTrack)
    end

    if #terminalGroup.terminals > 0 then
        table.insert(terminalGroups, terminalGroup)
    end
end

function TerminalUtils.addTerminalsFromGrid(terminalGroups, models, grid)
    local tracksAndPlatformsTop = {}
    local tracksAndPlatformsBottom = {}
    local zigZags = {}

    grid:eachActivePositionReversed(function (gridElement, iX, iY) 
        if gridElement:isTrack() then
            local topNeighborGridElement = grid:get(iX, iY + 1)
            if topNeighborGridElement:isPlatform() then
                table.insert(tracksAndPlatformsTop, {gridElement, topNeighborGridElement})
            else
                TerminalUtils.addTerminal(terminalGroups, models, tracksAndPlatformsTop)
                tracksAndPlatformsTop = {}
            end

            local bottomNeighborGridElement = grid:get(iX, iY - 1)
            if bottomNeighborGridElement:isPlatform() then
                table.insert(tracksAndPlatformsBottom, {gridElement, bottomNeighborGridElement})
            else
                TerminalUtils.addTerminal(terminalGroups, models, tracksAndPlatformsBottom)
                tracksAndPlatformsBottom = {}
            end

            if gridElement:getOption('zigZag', false) then
                table.insert(zigZags, {gridElement, gridElement})
            else
                TerminalUtils.addTerminal(terminalGroups, models, zigZags)
                zigZags = {}
            end
        else
            TerminalUtils.addTerminal(terminalGroups, models, tracksAndPlatformsTop)
            tracksAndPlatformsTop = {}
            TerminalUtils.addTerminal(terminalGroups, models, tracksAndPlatformsBottom)
            tracksAndPlatformsBottom = {}
            TerminalUtils.addTerminal(terminalGroups, models, zigZags)
            zigZags = {}
        end

        if iX == grid.activeBounds.right then
            TerminalUtils.addTerminal(terminalGroups, models, tracksAndPlatformsTop)
            tracksAndPlatformsTop = {}
            TerminalUtils.addTerminal(terminalGroups, models, tracksAndPlatformsBottom)
            tracksAndPlatformsBottom = {}
            TerminalUtils.addTerminal(terminalGroups, models, zigZags)
            zigZags = {}
        end

    end)
end

return TerminalUtils