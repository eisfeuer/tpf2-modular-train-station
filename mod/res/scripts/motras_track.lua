local c = require('motras_constants')

local TrackClass = {}

function TrackClass:new(gridElement)
    Track = gridElement

    function Track:isTrack()
        return true
    end

    function Track:getTrackType()
        return self.trackType or c.DEFAULT_MODULE_TRACK_TYPE
    end

    function Track:hasCatenary()
        return self.catenary == true
    end

    function Track:getEdges()
        return self.edges or {}
    end

    function Track:getSnapNodes()
        return self.snapNodes or {}
    end

    function Track:setTrackType(trackType)
        self.trackType = trackType
        return self
    end

    function Track:setCatenary(hasCatenary)
        self.catenary = hasCatenary
        return self
    end

    function Track:setEdges(edges, snapNodes)
        self.edges = edges
        self.snapNodes = snapNodes or {}
        return self
    end

    return Track
end

return TrackClass