local PlatformClass = {}

function PlatformClass:new(gridElement)
    Platform = gridElement

    function Platform:isPlatform()
        return true
    end

    return Platform
end

return PlatformClass