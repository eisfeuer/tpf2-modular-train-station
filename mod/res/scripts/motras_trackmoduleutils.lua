local TrackModuleUtils = {}

function TrackModuleUtils.makeTrack(track, trackType, hasCatenary, snapLeft, snapRight)
    local posX = track:getAbsoluteX()
    local posY = track:getAbsoluteY()
    local posZ = track:getGrid():getBaseHeight()

    local trackLength = track:getGrid():getHorizontalDistance() / 2
    local snapNodes = {}

    if snapLeft then
        table.insert(snapNodes, 1)
    end
    if snapRight then
        table.insert(snapNodes, 11)
    end

    track:setTrackType(trackType):setCatenary(hasCatenary):setEdges({
        { { posX - trackLength * 0.9, posY, posZ }, {-trackLength * 0.1, .0, .0 } },
        { { posX - trackLength, posY, posZ }, {-trackLength * 0.1, .0, .0 } },

        { { posX - trackLength * 0.1, posY, posZ }, {-trackLength * 0.8, .0, .0 } },
        { { posX - trackLength * 0.9, posY, posZ }, {-trackLength * 0.8, .0, .0 } },

        { { posX, posY, posZ }, {-2.0, .0, .0 } },
        { { posX - trackLength * 0.1, posY, posZ }, {-trackLength * 0.1, .0, .0 } },

        { { posX, posY, posZ }, {2.0, .0, .0 } },
        { { posX + trackLength * 0.1, posY, posZ }, {trackLength * 0.1, .0, .0 } },

        { { posX + trackLength * 0.1, posY, posZ }, {trackLength * 0.8, .0, .0 } },
        { { posX + trackLength * 0.9, posY, posZ }, {trackLength * 0.8, .0, .0 } },

        { { posX + trackLength * 0.9, posY, posZ }, {trackLength * 0.1, .0, .0 } },
        { { posX + trackLength, posY, posZ }, {trackLength * 0.1, .0, .0 } }
    }, snapNodes)
end

return TrackModuleUtils