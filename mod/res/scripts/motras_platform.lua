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

    function Platform:getTerminalEdgeTopTransformation()
        return {
            self.grid:getHorizontalDistance(), 0, 0, 0,
            0, 1, 0, 0,
            0, 0, 1, 0,
            self:getAbsoluteX(), self:getAbsoluteY() + c.PLATFORM_WAITING_EDGE_OFFSET, self:getAbsolutePlatformHeight(), 1
        }
    end

    function Platform:getTerminalEdgeBottomTransformation()
        return {
            -self.grid:getHorizontalDistance(), 0, 0, 0,
            0, -1, 0, 0,
            0, 0, 1, 0,
            self:getAbsoluteX(), self:getAbsoluteY() - c.PLATFORM_WAITING_EDGE_OFFSET, self:getAbsolutePlatformHeight(), 1
        }
    end

    return Platform
end

return PlatformClass