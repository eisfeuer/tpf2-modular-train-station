local PlaceClass = {}

function PlaceClass:new(gridElement)
    Place = gridElement

    function Place:isPlace()
        return true
    end

    return Place
end

return PlaceClass