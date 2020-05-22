local Box = require('motras_box')
local ModuleUtils = require('modulesutil')
local Transf = require('transf')

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
    }, snapNodes):setStopNodes({2, 0, 8, 10})
end

function TrackModuleUtils.makeLot(result, track, options)
    options = options or {}
    local halfVerticalDistance = track:getGrid():getVerticalDistance() / 2
    local halfHorizontalDistance = track:getGrid():getHorizontalDistance() / 2
    local boundingBox = Box:new(
        {track:getAbsoluteX() - halfHorizontalDistance, track:getAbsoluteY() - halfVerticalDistance, track:getGrid():getBaseHeight()},
        {track:getAbsoluteX() + halfHorizontalDistance, track:getAbsoluteY() + halfVerticalDistance, track:getGrid():getBaseTrackHeight()}
    )

    local terrainAlignmentLists = {
        { type = "EQUAL", faces = { boundingBox:getGroundFace() } },
    }
    
    local mainGroundFace = boundingBox:getGroundFace()
    
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

    table.insert(result.colliders, { 
        type = "BOX",
        transf = Transf.transl(boundingBox:getCenterPointAsVec3()),
        params = {
            halfExtents = boundingBox:getHalfExtends(),
        }
    })
end

return TrackModuleUtils