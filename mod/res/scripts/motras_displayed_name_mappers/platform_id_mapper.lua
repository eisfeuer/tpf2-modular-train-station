local PlatformIdMapper = {}

function PlatformIdMapper:new(o)
    o = o or {}
    setmetatable(o, self)
    self.__index = self
    return o
end

function PlatformIdMapper:getDisplayedId(trackId, platformId)
    return (platformId or '') .. ''
end

function PlatformIdMapper:getDisplayedDestination()
    return 'Hamburg-Altona'
end

return PlatformIdMapper