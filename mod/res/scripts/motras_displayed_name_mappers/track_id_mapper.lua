local TrackIdMapper = {}

function TrackIdMapper:new(o)
    o = o or {}
    setmetatable(o, self)
    self.__index = self
    return o
end

function TrackIdMapper:getDisplayedId(trackId, platformId)
    return (trackId or '') .. ''
end

function TrackIdMapper:getDisplayedDestination()
    return 'Hamburg-Altona'
end

return TrackIdMapper