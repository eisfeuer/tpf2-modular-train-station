local Slot = require("motras_slot")
local t = require("motras_types")
local Grid = require("motras_grid")

local GridElement = require("motras_grid_element")
local Track = require("motras_track")

describe("Track", function()
    local slotId = Slot.makeId({
        type = t.TRACK,
        gridX = 1,
        gridY = 2
    })
    local slot = Slot:new{id = slotId}
    local gridElement = GridElement:new{slot = slot, grid = Grid:new{}}
    local track = Track:new(gridElement)

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
end)