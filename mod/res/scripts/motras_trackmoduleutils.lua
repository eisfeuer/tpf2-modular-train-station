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
end

function TrackModuleUtils.assignTrackToModule(trackModule, track, filename, hasCatenary, sortIndex)
    local electrifiedFilename = 'motras_generic_track_' .. string.gsub(filename, '.lua', '_catenary.module')
    local notElectrifiedFilename = 'motras_generic_track_' .. string.gsub(filename, '.lua', '.module')

    trackModule.fileName = hasCatenary and electrifiedFilename or notElectrifiedFilename

    trackModule.availability.yearFrom = track.yearFrom
    trackModule.availability.yearTo = track.yearTo

    trackModule.cost.price = math.ceil(track.cost / 75 * 18000)

    trackModule.description.name = track.name .. (hasCatenary and (' ' .. _("with_catenary")) or "")
    trackModule.description.description = track.desc
    trackModule.description.icon = track.icon

    if trackModule.description.icon and trackModule.description.icon ~= "" then
        trackModule.description.icon = string.gsub(trackModule.description.icon, ".tga", "")
        trackModule.description.icon = trackModule.description.icon .. "_module" .. (hasCatenary and "_catenary" or "") .. ".tga"
    else
        trackModule.description.icon = 'ui/tracks/' .. string.gsub(filename, '.lua', '.tga')
    end

    trackModule.type = "motras_track"
    trackModule.order.value = 100000 + sortIndex * 10 + (hasCatenary and 1 or 0)

    trackModule.category.categories = { "tracks", }

    trackModule.updateScript.fileName = "construction/station/rail/generic_modules/motras_track.updateFn"
    trackModule.updateScript.params = {
        trackType = filename,
        catenary = hasCatenary
    }
    trackModule.getModelsScript.fileName = "construction/station/rail/generic_modules/motras_track.getModelsFn"
    trackModule.getModelsScript.params = {
        trackType = filename,
        catenary = hasCatenary
    }

    trackModule.metadata = {
        motras_electrified = hasCatenary,
        motras_toggleElectrificationTo = hasCatenary and notElectrifiedFilename or electrifiedFilename,
        motras_speedLimit = track.speedLimit
    }
end

return TrackModuleUtils