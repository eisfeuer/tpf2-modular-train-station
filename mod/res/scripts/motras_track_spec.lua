local Slot = require("motras_slot")
local t = require("motras_types")
local Grid = require("motras_grid")

local GridElement = require("motras_grid_element")
local Track = require("motras_track")

describe("Track", function()
    local slotId = Slot.makeId({
        type = t.TRACK,
        gridX = 1,
        gridY = 2,
    })
    local slot = Slot:new{id = slotId}
    local gridElement = GridElement:new{slot = slot, grid = Grid:new{}}
    local track = Track:new(gridElement)

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
            assert.are.equal(43, track:getAbsoluteOddTopStopNode())
        end)
    end)

    describe('getAbsoluteEvenTopStopNode', function ()
        it ('returns top stop node when track count is even', function ()
            track:setFirstNode(42)
            track:setStopNodes({1, 2 ,3 ,4 })
            assert.are.equal(44, track:getAbsoluteEvenTopStopNode())
        end)
    end)

    describe('getAbsoluteOddBottomStopNode', function ()
        it ('returns bottom stop node when track count is odd', function ()
            track:setFirstNode(42)
            track:setStopNodes({1, 2 ,3 ,4 })
            assert.are.equal(45, track:getAbsoluteOddBottomStopNode())
        end)
    end)

    describe('getAbsoluteEvenBottomStopNode', function ()
        it ('returns bottom stop node when track count is even', function ()
            track:setFirstNode(42)
            track:setStopNodes({1, 2 ,3 ,4 })
            assert.are.equal(46, track:getAbsoluteEvenBottomStopNode())
        end)
    end)
end)