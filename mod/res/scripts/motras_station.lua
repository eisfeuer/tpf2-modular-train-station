local Grid = require("motras_grid")
local Slot = require("motras_slot")
local GridElement = require("motras_grid_element")
local Track = require("motras_track")
local Platform = require("motras_platform")
local Place = require("motras_place")
local TrackSlotPlacement = require("motras_track_slot_placement")

local c = require("motras_constants")
local t = require("motras_types")

local Station = {}

function Station:new(o)
    o = o or {}

    o.result = o.result or {0}

    o.grid = Grid:new{
        horizontalDistance = o.horizontalGridDistance or c.DEFAULT_HORIZONTAL_GRID_DISTANCE,
        verticalDistance = o.verticalGridDistance or c.DEFAULT_VERTICAL_GRID_DISTANCE,
        baseHeight = o.baseHeight or c.DEFAULT_BASE_HEIGHT,
        modulePrefix = o.modulePrefix or c.DEFAULT_MODULE_PREFIX
    }

    setmetatable(o, self)
    self.__index = self

    return o
end

function Station:processResult(result)
    table.remove(result.models, 1)

    self.grid:handleModules(result)

    if #result.models == 0 then
        table.insert(result.models, {
            id = 'asset/icon/marker_question.mdl',
            transf = { 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1 }
        })
    end
end

function Station:getData()
    local result = self.result

    result.motras = self

    result.models = {{
        id = 'asset/icon/marker_question.mdl',
        transf = { 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1 }
    }}
    result.slots = {}
    result.edgeLists = {}
    result.terminalGroups = {}
    result.terrainAlignmentLists = {}
    result.groundFaces = {}

    result.terminateConstructionHook = function ()
        self:processResult(result)
    end
    
    --self.grid:debug()
    Slot.addGridSlotsToCollection(result.slots, self.grid, TrackSlotPlacement)

    return result;
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

function Station:register(slotId)
    local gridElement = GridElement:new{
        slot = Slot:new{id = slotId},
        grid = self.grid
    }

    return self.grid:get(gridElement:getGridX(), gridElement:getGridY())
end

function Station:initializeAndRegisterAll(slots)
    for slotId, module in pairs(slots) do
        --print(slotId)
        self:initializeAndRegister(slotId)
    end
end

function Station:registerGridElement(gridElement)
    self.grid:set(gridElement)
    return gridElement
end

function Station:getCustomTrack1()
    return self.customTrack1 or c.DEFAULT_CUSTOM_TRACK_TYPE
end

function Station:getCustomTrack2()
    return self.customTrack2 or c.DEFAULT_CUSTOM_TRACK_TYPE
end

return Station