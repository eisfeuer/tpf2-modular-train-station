local c = require("motras_constants")
local Void = require("motras_void") 

local Grid = {}

function Grid:new(o)
    o = o or {}
    o.grid = o.grid or {}
    setmetatable(o, self)
    self.__index = self
    return o
end

function Grid:isEmpty()
    return #self.grid == 0
end

function Grid:set(gridElement)
    if gridElement:isBlank() then
        error("Void elements are not allowed to store in the grid")
    end

    if self.grid[gridElement:getGridX()] then
        self.grid[gridElement:getGridY()] = gridElement
    else
        self.grid[gridElement:getGridX()] = {
            [gridElement:getGridY()] = gridElement
        }
    end
end

function Grid:get(gridX, gridY)
    if self.grid[gridX] and self.grid[gridX][gridY] then
        return self.grid[gridX][gridY]
    end

    return Void:new({
        gridX = gridX,
        gridY = gridY
    }, self)
end

return Grid