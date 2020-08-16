local Slot = require("motras_slot")
local t = require("motras_types")
local Grid = require("motras_grid")
local EdgeListMap = require("motras_edge_list_map")
local c = require("motras_constants")

local GridElement = require("motras_grid_element")
local Track = require("motras_track")

describe("Track", function()
    local edgeLists = {{
        type = 'TRACK',
        params = {
            type = 'standard.lua',
            catenary = false
        },
        edges = {
            { {-10.0, 0.0, 0.0}, {20.0, 0.0, 0.0} },
            { { 10.0, 0.0, 0.0}, {20.0, 0.0, 0.0} }
        },
        snapNodes = {}
    }, {
        type = 'TRACK',
        params = {
            type = 'standard.lua',
            catenary = true
        },
        edges = {
            { {-10.0, 0.0, 0.0}, {20.0, 0.0, 0.0} },
            { { 10.0, 0.0, 0.0}, {20.0, 0.0, 0.0} }
        },
        snapNodes = {}
    }}

    local slotId = Slot.makeId({
        type = t.TRACK,
        gridX = 1,
        gridY = 2,
    })
    local slot = Slot:new{id = slotId}
    local gridElement = GridElement:new{slot = slot, grid = Grid:new{horizontalDistance = 40, verticalDistance = 5, baseHeight = 0}}
    local track = Track:new(gridElement)
    track:setEdgeListMap(EdgeListMap:new{edgeLists = edgeLists})

    describe('new', function ()
        it ('has standard.lua as default track type', function ()
            assert.are.equal('standard.lua', track:getTrackType())
        end)

        it('has no catenary as default', function ()
            assert.is_false(track:hasCatenary())
        end)

        it('has no edges by default', function ()
            assert.are.same({}, track:getEdges())
        end)

        it('has no smapNode by default', function ()
            assert.are.same({}, track:getSnapNodes())
        end)
    end)

    describe("getSlotId", function ()
        it("returns slot id", function ()
            assert.are.equal(slotId, track:getSlotId())
        end)
    end)

    describe("getGridType", function ()
        it("returns grid type", function ()
            assert.are.equal(t.GRID_TRACK, track:getGridType())
        end)
    end)

    describe("getType", function ()
        it("returns type", function ()
            assert.are.equal(t.TRACK, track:getType())
        end)
    end)

    describe("getGridX", function ()
        it("returns grid x", function ()
            assert.are.equal(1, track:getGridX())
        end)
       
    end)

    describe("getGridY", function ()
        it("returns grid y", function ()
            assert.are.equal(2, track:getGridY())
        end)
    end)

    describe("isTrack", function ()
        it("is a track", function ()
            assert.is_true(track:isTrack())
        end)
    end)

    describe("isPlatform", function ()
        it ("is not a platform", function ()
            assert.is_false(track:isPlatform())
        end)
    end)

    describe("isPlace", function ()
        it("returns always false", function ()
            assert.is_false(track:isPlace())
        end)
    end)

    describe("isBlank", function ()
        it ("is not blank", function ()
            assert.is_false(gridElement:isBlank())
        end)
    end)

    describe("handle/call", function ()
        it("calls handler function", function ()
            track:handle(function(result)
                table.insert(result.models, {
                    id = 'a_model.mdl',
                    transf = {
                        1, 0, 0, 0,
                        0, 1, 0, 0,
                        0, 1, 0, 0,
                        0, 0, 0, 1
                    }
                })
            end)

            local result = {
                models = {}
            }

            track:call(result)

            assert.are.same({
                models = {
                    {
                        id = 'a_model.mdl',
                        transf = {
                            1, 0, 0, 0,
                            0, 1, 0, 0,
                            0, 1, 0, 0,
                            0, 0, 0, 1
                        }
                    }
                }
            }, result)
        end)
    end)

    describe('setTrackType', function ()
        it('sets track type', function ()
            track:setTrackType('pneu_metro.lua')
            assert.are.equal('pneu_metro.lua', track:getTrackType())
        end)
    end)

    describe('setCatenary', function ()
        it('sets catenary', function ()
            track:setCatenary(true)
            assert.is_true(track:hasCatenary())
        end)
    end)

    describe('setEdges', function ()
        it('sets edges and snap nodes', function ()
            track:setEdges({
                {{1.0, 0.0, 0.0}, {-2.0, 0.0, 0.0}},
                {{-1.0, 0.0, 0.0}, {-2.0, 0.0, 0.0}},
            }, {0})

            assert.are.same({
                {{1.0, 0.0, 0.0}, {-2.0, 0.0, 0.0}},
                {{-1.0, 0.0, 0.0}, {-2.0, 0.0, 0.0}},
            }, track:getEdges())
            assert.are.same({0}, track:getSnapNodes())
        end)
    end)

    describe('setFirstNode', function ()
        it('sets first node', function ()
            track:setFirstNode(42)
            assert.are.same(42, track:getFirstNode())
        end)
    end)

    describe('setStopNodes', function ()
        it ('sets stop nodes', function ()
            track:setStopNodes({1, 2 ,3 ,4 })
            assert.are.same({1, 2 ,3 ,4 }, track:getStopNodes())
        end)
    end)

    describe('getAbsoluteOddTopStopNode', function ()
        it ('returns top stop node when track count is odd', function ()
            track:setFirstNode(42)
            track:setStopNodes({1, 2 ,3 ,4 })
            track:setCatenary(true)
            track:setTrackType('standard.lua')
            assert.are.equal(45, track:getAbsoluteOddTopStopNode())
        end)
    end)

    describe('getAbsoluteEvenTopStopNode', function ()
        it ('returns top stop node when track count is even', function ()
            track:setFirstNode(42)
            track:setStopNodes({1, 2 ,3 ,4 })
            track:setCatenary(true)
            track:setTrackType('standard.lua')
            assert.are.equal(46, track:getAbsoluteEvenTopStopNode())
        end)
    end)

    describe('getAbsoluteOddBottomStopNode', function ()
        it ('returns bottom stop node when track count is odd', function ()
            track:setFirstNode(42)
            track:setStopNodes({1, 2 ,3 ,4 })
            track:setCatenary(true)
            track:setTrackType('standard.lua')
            assert.are.equal(47, track:getAbsoluteOddBottomStopNode())
        end)
    end)

    describe('getAbsoluteEvenBottomStopNode', function ()
        it ('returns bottom stop node when track count is even', function ()
            track:setFirstNode(42)
            track:setStopNodes({1, 2 ,3 ,4 })
            track:setCatenary(true)
            track:setTrackType('standard.lua')
            assert.are.equal(48, track:getAbsoluteEvenBottomStopNode())
        end)
    end)
    
    describe('getTagNodes', function ()
        it('returns tag nodes', function ()
            assert.are.same({0, 1}, track:getTagNodes())
        end)
    end)

    describe('getAbsoluteTagNodes', function ()
        assert.are.same({42, 43}, track:getAbsoluteTagNodes())
    end)

    describe('getTagNodesKey', function ()
        it('returns key for the tag nodes', function ()
            assert.are.equal('__module_' .. slotId, track:getTagNodesKey())
        end)
    end)

    describe('getTrackId', function ()
        it('returns track id', function ()
            assert.is_nil(track:getTrackId())
            track:setOption('trackId', 34)
            assert.are.equal(34, track:getTrackId())
        end)
    end)

    describe('getPlatformId', function ()
        it('returns track id', function ()
            assert.is_nil(track:getPlatformId())
            track:setOption('platformId', 34)
            assert.are.equal(34, track:getPlatformId())
        end)
    end)

    describe('getDisplayedId', function ()
        it('returns track id', function ()
            assert.is_nil(track:getDisplayedId())
            track:setOption('displayedId', 34)
            assert.are.equal(34, track:getDisplayedId())
        end)
    end)

    describe('getDisplayedDestination', function ()
        it('returns track id', function ()
            assert.is_nil(track:getDisplayedDestination())
            track:setOption('displayedDestination', 34)
            assert.are.equal(34, track:getDisplayedDestination())
        end)
    end)

    describe("handleTerminals / callTerminalHandling", function ()
        it ('handles default terminal handling', function ()
            local stuff = {}

            local addTerminalFunc = function (model, transformation, terminalId)
                stuff.model = model
                stuff.transformation = transformation
                stuff.terminalId = terminalId
            end

            track:callTerminalHandling(addTerminalFunc, -1)

            assert.are.same({
                model = c.DEFAULT_PASSENGER_TERMINAL_MODEL,
                transformation = {
                    1, 0, 0, 0,
                    0, 1, 0, 0,
                    0, 0, 1, 0,
                    track:getAbsoluteX(), track:getAbsoluteY(), -10, 1,
                },
                terminalId = 0
            }, stuff)
        end)
        it ('handles terminals', function ()
            local stuff = {}

            local addTerminalFunc = function (model, transformation, terminalId)
                stuff.model = model
                stuff.transformation = transformation
                stuff.terminalId = terminalId
            end

            track:handleTerminals(function (addTerminalFunc)
                addTerminalFunc(
                    'a_terminal_model', 
                    {
                        1, 0, 0, 0,
                        0, 1, 0, 0,
                        0, 0, 1, 0,
                        track:getAbsoluteX(), track:getAbsoluteY(), -8, 1,
                    },
                    1
                )
            end)
            track:callTerminalHandling(addTerminalFunc, 1)
            
            assert.are.same({
                model = 'a_terminal_model',
                transformation = {
                    1, 0, 0, 0,
                    0, 1, 0, 0,
                    0, 0, 1, 0,
                    track:getAbsoluteX(), track:getAbsoluteY(), -8, 1,
                },
                terminalId = 1
            }, stuff)
        end)
    end)
end)