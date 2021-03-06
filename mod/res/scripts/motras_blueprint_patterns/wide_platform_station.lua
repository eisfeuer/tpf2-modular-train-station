local t = require('motras_types')

local WidePlatformStationPattern = {}

function WidePlatformStationPattern:new(o)
    o = o or {}
    setmetatable(o, self)
    self.__index = self
    return o
end

function WidePlatformStationPattern:getVerticalRange()
    return -self.trackCount, self.trackCount - 1
end

function WidePlatformStationPattern:getHorizontalRange()
    if self.horizontalSize % 2 == 0 then
        return -self.horizontalSize / 2,  self.horizontalSize / 2 - 1
    end
    return -math.floor(self.horizontalSize / 2), math.floor(self.horizontalSize / 2)
end


function WidePlatformStationPattern:getTypeAndModule(gridX, gridY)
    local positionInSection = (self.trackCount - 1 - gridY) % 4
    local primaryPlatformIndex = self.preferIslandPlatforms and 1 or 3
    local secondaryPlatformIndex = self.preferIslandPlatforms and 2 or 0


    if positionInSection == primaryPlatformIndex then
        local options = {}
        if gridY > -self.trackCount then
            options.hasIslandPlatformSlots = true
        end
        return t.PLATFORM, self.platformModule, options
    end

    if positionInSection == secondaryPlatformIndex then
        return t.PLATFORM, self.platformModule, {}
    end

    return t.TRACK, self.trackModule, {}
end

return WidePlatformStationPattern