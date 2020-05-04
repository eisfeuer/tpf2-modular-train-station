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

    function Platform:getGlobalTransformationBasedOnPlatformTop(position, rotationFactor)
        rotationFactor = rotationFactor or 1
        local posX = position.x or 0
        local posY = position.y or 0
        local posZ = position.z or 0

        return {
            rotationFactor, 0, 0, 0,
            0, rotationFactor, 0, 0,
            0, 0, 1, 0,
            self:getAbsoluteX() + posX, self:getAbsoluteY() + posY, self:getAbsolutePlatformHeight() + posZ, 1
        }
    end

    function Platform:callTerminalHandling(addTerminalFunc, directionFactor, platformIsOverTrack)
        local handleFunc = self.terminalHandlingFunc or function (addTerminalFuncParam, directionFactorParam)
            local transformation = self:getGlobalTransformationBasedOnPlatformTop({y =  c.DEFAULT_PLATFORM_WAITING_EDGE_OFFSET * directionFactorParam})
            addTerminalFuncParam(c.DEFAULT_PASSENGER_TERMINAL_MODEL,transformation, 0)
        end

        handleFunc(addTerminalFunc, directionFactor, platformIsOverTrack)
    end

    function Platform:handleTerminals(terminalHandlingFunc)
        self.terminalHandlingFunc = terminalHandlingFunc
    end

    return Platform
end

return PlatformClass