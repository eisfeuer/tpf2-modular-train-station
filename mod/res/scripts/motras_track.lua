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

    function Track:getStopNodes()
        return self.stopNodes or {}
    end

    function Track:getFirstNode()
        return self.firstNode or 0
    end

    function Track:getStopNode(position)
        local stopNodes = self:getStopNodes()
        return stopNodes[position] or 0
    end

    function Track:getAbsoluteStopNode(position)
        return self:getStopNode(position) + self:getFirstNode()
    end

    function Track:getAbsoluteOddTopStopNode()
        return self:getAbsoluteStopNode(1)
    end

    function Track:getAbsoluteEvenTopStopNode()
        return self:getAbsoluteStopNode(2)
    end

    function Track:getAbsoluteOddBottomStopNode()
        return self:getAbsoluteStopNode(3)
    end

    function Track:getAbsoluteEvenBottomStopNode()
        return self:getAbsoluteStopNode(4)
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

    function Track:setFirstNode(firstNode)
        self.firstNode = firstNode
    end

    function Track:setStopNodes(stopNodes)
        if #stopNodes ~= 4 then
            error('Stop Nodes must be a table with exact 4 items')
        end
        self.stopNodes = stopNodes
    end


    return Track
end

return TrackClass