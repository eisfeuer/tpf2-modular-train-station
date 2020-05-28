local t = require("motras_types")
local GridElement = require("motras_grid_element")
local Slot = require("motras_slot")

local voidClass = {}

local function makeGridElement(gridX, gridY, grid)
    local slot = Slot:new{id = 0}
    slot.gridX = gridX
    slot.gridY = gridY

    return GridElement:new{slot = slot, grid = grid}
end

function voidClass:new(gridElement, grid)
    if grid then
        gridElement = makeGridElement(gridElement.gridX, gridElement.gridY, grid)
    end

    local Void = gridElement

    function Void:getSlotId()
        return nil
    end

    function Void:getGridType()
        return t.VOID
    end

    function Void:getType()
        return t.VOID
    end

    function Void:isBlank()
        return true
    end

    return Void
end

return voidClass