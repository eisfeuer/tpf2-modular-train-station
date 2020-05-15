local t = require('motras_types')

local TallPlatformStationPattern = {}

function TallPlatformStationPattern:new(o)
    o = o or {}
    setmetatable(o, self)
    self.__index = self
    return o
end

function TallPlatformStationPattern:getVerticalRange()
    local platformCount = math.floor((self.trackCount + 2) / 2)
    local gridRowCount = platformCount + self.trackCount

    local bottomGridY = math.floor(gridRowCount / 2) * -1
    return bottomGridY, bottomGridY + gridRowCount - 1
end

function TallPlatformStationPattern:getHorizontalRange()
    if self.horizontalSize % 2 == 0 then
        return -self.horizontalSize / 2,  self.horizontalSize / 2 - 1
    end
    return -math.floor(self.horizontalSize / 2), math.floor(self.horizontalSize / 2)
end

function TallPlatformStationPattern:getTypeAndModule(gridX, gridY)
    local bottomGridY, topGridY = self:getVerticalRange()
    
    local isPlatform = (topGridY - gridY) % 3 == 0
    local gridType = isPlatform and t.PLATFORM or t.TRACK
    local moduleName = isPlatform and self.platformModule or self.trackModule

    return gridType, moduleName, {}
end

return TallPlatformStationPattern