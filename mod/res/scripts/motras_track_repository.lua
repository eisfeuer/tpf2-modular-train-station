local TrackRepository = {}

local function optional(tableOrNil)
    return tableOrNil or {}
end

function TrackRepository:new(o)
    o = o or {}

    o.tracksWithoutCatenary = {}
    o.tracksWithCatenary = {}

    setmetatable(o, self)
    self.__index = self
    return o
end

function TrackRepository:addTrack(trackModule, hasCatenary)
    local repositoryItem = {
        filename = trackModule.fileName,
        name = trackModule.description.name,
        yearFrom = trackModule.availability.yearFrom == 0 and 1850 or trackModule.availability.yearFrom,
        yearTo = trackModule.availability.yearTo,
    }

    if hasCatenary then
        table.insert(self.tracksWithCatenary, repositoryItem)
    else
        table.insert(self.tracksWithoutCatenary, repositoryItem)
    end
end

function TrackRepository:getSortedTrackList()
    local tracks = {}

    for i, item in ipairs(self.tracksWithoutCatenary) do
        local itemClone = {}

        for key, value in pairs(item) do
            itemClone[key] = value
        end

        itemClone.position = i

        table.insert(tracks, itemClone)
    end

    table.sort(tracks, function (a, b)
        if a.yearFrom == b.yearFrom then
            return a.filename < b.filename
        end

        return a.yearFrom < b.yearFrom
    end)
    
    return tracks
end

function TrackRepository:getConstructionParams()
    local params = {}

    local sortedTracks = self:getSortedTrackList()
    if #sortedTracks == 0 then
        return {}
    end

    for i, track in ipairs(sortedTracks) do
        local yearFrom = track.yearFrom
        local yearTo = optional(sortedTracks[i + 1]).yearFrom or 0

        if yearFrom ~= yearTo then
            local values = {}
            for _, value in pairs(sortedTracks) do
                if yearTo == 0 or value.yearFrom < yearTo then
                    table.insert(values, value.name)
                end
            end

            table.insert(params, {
                key = "trackType",
                name = _("trackType"),
                values = values,
                uiType = "COMBOBOX",
                defaultIndex = 0,
                yearFrom = yearFrom,
                yearTo = yearTo,
                tooltip =_("track_type_tooltip")
            })
        end
    end

    return params
end

function TrackRepository:getRepositoryTable()
    local sortedTracks = self:getSortedTrackList()
    local result = {
        [0] = {},
        [1] = {}
    }

    for _, track in pairs(sortedTracks) do
        table.insert(result[0], track.filename)
        table.insert(result[1], self.tracksWithCatenary[track.position].filename)
    end

    return result
end

return TrackRepository