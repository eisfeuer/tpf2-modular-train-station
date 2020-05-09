local Grid = require("motras_grid")
local Slot = require("motras_slot")
local GridElement = require("motras_grid_element")
local Track = require("motras_track")
local Platform = require("motras_platform")
local Place = require("motras_place")
local TrackSlotPlacement = require("motras_track_slot_placement")
local PlatformSlotPlacement = require("motras_platform_slot_placement")
local TrackUtils = require("motras_trackutils")
local EdgeListMap = require("motras_edge_list_map")
local TerminalUtils = require("motras_terminalutils")
local AssetSlotCache = require("motras_asset_slot_cache")
local UnderpassUtils = require("motras_underpassutils")
local AssetDecorationSlotCache = require('motras_asset_decoration_slot_cache')

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
        baseTrackHeight = o.baseTrackHeight or c.DEFAULT_BASE_TRACK_HEIGHT,
        modulePrefix = o.modulePrefix or c.DEFAULT_MODULE_PREFIX,
        underpassZ = o.underpassZ or c.DEFAULT_UNDERPASS_Z,
        underpassRepeatModel = c.underpassRepeatModel or c.DEFAULT_UNDERPASS_GRID_REPEAT_MODEL,
        underpassStartModel = c.underpassStartModel or c.DEFAULT_UNDERPASS_GRID_START_MODEL
    }

    o.assetSlotCache = AssetSlotCache:new{}
    o.assetDecorationSlotCache = AssetDecorationSlotCache:new{}

    setmetatable(o, self)
    self.__index = self

    return o
end

function Station:processResult(result)
    table.remove(result.models, 1)

    self.grid:handleModules(result)

    local edgeListMap = EdgeListMap:new{edgeLists = result.edgeLists}
    self.grid:each(function (gridElement)
        if gridElement:isTrack() then
            local edgeList = edgeListMap:getOrCreateEdgeList(gridElement:getTrackType(), gridElement:hasCatenary())
            gridElement:setEdgeListMap(edgeListMap)
            gridElement:setFirstNode(#edgeList.edges)
            TrackUtils.addEdgesToEdgeList(edgeList, gridElement:getEdges(), gridElement:getSnapNodes(), gridElement:getTagNodesKey(), gridElement:getTagNodes())
        end
    end)

    TerminalUtils.addTerminalsFromGrid(result.terminalGroups, result.models, self.grid)

    if #result.models == 0 then
        table.insert(result.models, {
            id = 'asset/icon/marker_question.mdl',
            transf = { 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1 }
        })
    else
        UnderpassUtils.addUnderpassLaneGridToModels(self.grid, result.models)
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
    result.colliders = {}

    result.terminateConstructionHook = function ()
        self:processResult(result)
    end
    
    --self.grid:debug()
    Slot.addGridSlotsToCollection(result.slots, self.grid, TrackSlotPlacement)
    Slot.addGridSlotsToCollection(result.slots, self.grid, PlatformSlotPlacement)

    return result;
end

function Station:initializeAndRegister(slotId)
    local slot = Slot:new{id = slotId}
    --slot:debug()

    if slot.gridType == t.GRID_ASSET_DECORATION and slot.assetDecorationId > 0 then
        if self.grid:has(slot.gridX, slot.gridY) then
            local gridElement = self.grid:get(slot.gridX, slot.gridY)
            if gridElement:hasAsset(slot.assetId) then
                return gridElement:getAsset(slot.assetId):registerDecoration(slot.assetDecorationId, slot)
            end
            return self.assetDecorationSlotCache:addAssetDecorationSlotToCache(slot)
        end
        return self.assetDecorationSlotCache:addAssetDecorationSlotToCache(slot)
    end

    if slot.gridType == t.GRID_ASSET and  slot.assetId > 0 then
        if self.grid:has(slot.gridX, slot.gridY) then
            local asset = self.grid:get(slot.gridX, slot.gridY):registerAsset(slot.assetId, slot)
            self.assetDecorationSlotCache:bindAssetDecorationSlotsToAsset(asset)
            return asset
        end
        return self.assetSlotCache:addAssetSlot(slot)
    end

    local gridElement = GridElement:new{
        slot = slot,
        grid = self.grid
    }
    self.assetSlotCache:bindAssetSlotsToGridElement(gridElement, self.assetDecorationSlotCache)

    if gridElement:getGridType() == t.GRID_TRACK then
        return self:registerGridElement(Track:new(gridElement))
    elseif gridElement:getGridType() == t.GRID_PLATFORM then
        return self:registerGridElement(Platform:new(gridElement))
    elseif gridElement:getGridType() == t.GRID_PLACE then
        return self:registerGridElement(Place:new(gridElement))
    end
end

function Station:register(slotId, options)
    local slot = Slot:new{id = slotId}

    if slot.gridType == t.GRID_ASSET_DECORATION and  slot.assetId > 0 then
        local gridElement = self.grid:get(slot.gridX, slot.gridY)
        if not gridElement:isBlank() then
            local asset = gridElement:getAsset(slot.assetId)
            if asset then
                local assetDecoration = asset:getDecoration(slot.assetDecorationId)
                if options then
                    assetDecoration:setOptions(options)
                end
                return assetDecoration
            end
        end
        return nil
    end

    if slot.gridType == t.GRID_ASSET and  slot.assetId > 0 then
        local gridElement = self.grid:get(slot.gridX, slot.gridY)
        if gridElement then
            local asset = gridElement:getAsset(slot.assetId)
            if options then
                asset:setOptions(options)
            end
            return asset
        end
        return nil
    end

    local gridElement = self.grid:get(slot.gridX, slot.gridY)
    if gridElement then
        gridElement:setOptions(options or {})
    end
    return gridElement
end

function Station:initializeAndRegisterAll(slots)
    for slotId, module in pairs(slots) do
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