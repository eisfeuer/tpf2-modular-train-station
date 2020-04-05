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
        self.grid[gridElement:getGridX()][gridElement:getGridY()] = gridElement
    else
        self.grid[gridElement:getGridX()] = {
            [gridElement:getGridY()] = gridElement
        }
    end
end

function Grid:get(gridX, gridY)
    if self:has(gridX, gridY) then
        return self.grid[gridX][gridY]
    end

    return Void:new({
        gridX = gridX,
        gridY = gridY
    }, self)
end

function Grid:has(gridX, gridY)
    return self.grid[gridX] ~= nil and self.grid[gridX][gridY] ~= nil
end

function Grid:getHorizontalDistance()
    return self.horizontalDistance
end

function Grid:getVerticalDistance()
    return self.verticalDistance
end

function Grid:getModulePrefix()
    return self.modulePrefix
end

function Grid:getBaseHeight()
    return self.baseHeight
end

function Grid:each(callable)
    self:eachPosition(function (grid, iX, iY)
        if grid:has(iX, iY) then
            callable(grid:get(iX, iY))
        end
    end)
end

function Grid:eachPosition(callable)
    for iY = -c.GRID_MAX_XY_POSITION, c.GRID_MAX_XY_POSITION do
        for iX = -c.GRID_MAX_XY_POSITION, c.GRID_MAX_XY_POSITION do
           callable(self, iX, iY)
        end
    end
end

function Grid:handleModules(result)
    self:each(function (gridElement)
        gridElement:call(result)
    end)
end

function Grid.isInBounds(gridX, gridY)
    return math.abs(gridX) <= c.GRID_MAX_XY_POSITION and math.abs(gridY) <= c.GRID_MAX_XY_POSITION
end

return Grid