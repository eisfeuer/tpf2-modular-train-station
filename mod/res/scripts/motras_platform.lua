local c = require('motras_constants')

local PlatformClass = {}

function PlatformClass:new(gridElement)
    Platform = gridElement

    function Platform:isPlatform()
        return true
    end

    function Platform:getPlatformHeight()
        return self:getOption('platformHeight', c.DEFAULT_PLATFORM_HEIGHT)
    end

    function Platform:getAbsolutePlatformHeight()
        return self:getAbsoluteZ() + self.grid:getBaseTrackHeight() + self:getPlatformHeight()
    end

    return Platform
end

return PlatformClass