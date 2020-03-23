local TrackClass = {}

function TrackClass:new(gridElement)
    Track = gridElement

    function Track:isTrack()
        return true
    end

    return Track
end

return TrackClass