local Grid = require("motras_grid")
local Slot = require("motras_slot")
local GridElement = require("motras_grid_element")
local Track = require("motras_track")
local Platform = require("motras_platform")
local Place = require("motras_place")

local t = require("motras_types")

local Station = {}

function Station:new(o)
    o = o or {}

    o.grid = Grid:new{}

    setmetatable(o, self)
    self.__index = self
    return o
end

function Station:initializeAndRegister(slotId)
    local gridElement = GridElement:new{
        slot = Slot:new{id = slotId},
        grid = self.grid
    }

    if gridElement:getGridType() == t.GRID_TRACK then
        return self:registerGridElement(Track:new(gridElement))
    elseif gridElement:getGridType() == t.GRID_PLATFORM then
        return self:registerGridElement(Platform:new(gridElement))
    elseif gridElement:getGridType() == t.GRID_PLACE then
        return self:registerGridElement(Place:new(gridElement))
    end
    
end

function Station:registerGridElement(gridElement)
    self.grid:set(gridElement)
    return gridElement
end

return Station