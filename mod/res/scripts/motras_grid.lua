local c = require("motras_constants")
local Void = require("motras_void") 

local Grid = {}

function Grid:new(o)
    o = o or {}
    o.grid = o.grid or {}
    o.activeBounds = o.activeBounds or {
        left = 0,
        right = 0,
        top = 0,
        bottom = 0
    }
    setmetatable(o, self)
    self.__index = self
    return o
end

function Grid:isEmpty()
    for iX = -c.GRID_MAX_XY_POSITION, c.GRID_MAX_XY_POSITION do
        if self.grid[iX] ~= nil then
            return false
        end
    end

    return true
end

function Grid:updateActiveBounds(gridX, gridY)
    self.activeBounds.left = math.min(self.activeBounds.left, gridX)
    self.activeBounds.right = math.max(self.activeBounds.right, gridX)
    self.activeBounds.top = math.max(self.activeBounds.top, gridY)
    self.activeBounds.bottom = math.min(self.activeBounds.bottom, gridY)
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

    self:updateActiveBounds(gridElement:getGridX(), gridElement:getGridY())
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

function Grid:getBaseTrackHeight()
    return self.baseTrackHeight
end

function Grid:each(callable)
    for iY, row in pairs(self.grid) do
        for iX, gridElement in pairs(row) do
            callable(gridElement, iX, iY)
        end
    end
end

function Grid:eachPosition(callable)
    for iY = -c.GRID_MAX_XY_POSITION, c.GRID_MAX_XY_POSITION do
        for iX = -c.GRID_MAX_XY_POSITION, c.GRID_MAX_XY_POSITION do
           callable(self, iX, iY)
        end
    end
end

function Grid:eachActivePosition(callable)
    for iY = self.activeBounds.bottom, self.activeBounds.top do
        for iX = self.activeBounds.left, self.activeBounds.right do
            callable(self:get(iX, iY), iX, iY)
        end
    end
end

function Grid:eachActiveSlotPosition(callable)
    local bounds = self:getActiveGridSlotBounds()
    for iY = bounds.bottom, bounds.top do
        for iX = bounds.left, bounds.right do
            callable(self, iX, iY)
        end
    end
end

function Grid:handleModules(result)
    self:each(function (gridElement)
        gridElement:call(result)
    end)
end

function Grid:getActiveGridBounds()
    return self.activeBounds
end

function Grid:getActiveGridSlotBounds()
    return {
        left = self.activeBounds.left - 1,
        right = self.activeBounds.right + 1,
        top = self.activeBounds.top + 1,
        bottom = self.activeBounds.bottom - 1
    }
end

function Grid.isInBounds(gridX, gridY)
    return math.abs(gridX) <= c.GRID_MAX_XY_POSITION and math.abs(gridY) <= c.GRID_MAX_XY_POSITION
end

function Grid:debug(completeGrid)
    local startX = completeGrid and -c.GRID_MAX_XY_POSITION or self.activeBounds.left
    local endX = completeGrid and c.GRID_MAX_XY_POSITION or self.activeBounds.right
    local startY = completeGrid and -c.GRID_MAX_XY_POSITION or self.activeBounds.bottom
    local endY = completeGrid and c.GRID_MAX_XY_POSITION or self.activeBounds.top

    for iY = startY, endY do
        local infoString = ''
        for iX = startX, endX do
            local gridElement = self:get(iX, iY)
            if gridElement:isTrack() then
                infoString = infoString .. '='
            elseif gridElement:isPlatform() then
                infoString = infoString .. 'E'
            elseif gridElement:isPlace() then
                infoString = infoString .. 'X'
            elseif gridElement:isBlank() then
                infoString = infoString .. '-'
            else
                infoString = infoString .. '?'
            end
        end
        print(infoString)
    end
end

return Grid