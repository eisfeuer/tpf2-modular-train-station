local Slot = require("motras_slot")
local t = require("motras_types")

local GridElement = require("motras_grid_element")
local Place = require("motras_place")

describe("Place", function()
    local slotId = Slot.makeId({
        type = t.PLACE,
        gridX = 1,
        gridY = 2
    })
    local slot = Slot:new{id = slotId}
    local gridElement = GridElement:new{slot = slot}
    local place = Place:new(gridElement)

    describe("getSlotId", function ()
        it("returns slot id", function ()
            assert.are.equal(slotId, place:getSlotId())
        end)
    end)

    describe("getGridType", function ()
        it("returns grid type", function ()
            assert.are.equal(t.GRID_PLACE, place:getGridType())
        end)
        
    end)

    describe("getType", function ()
        it("returns type", function ()
            assert.are.equal(t.PLACE, place:getType())
        end)
    end)

    describe("getGridX", function ()
        it("returns grid x", function ()
            assert.are.equal(1, place:getGridX())
        end)
    end)

    describe("getGridY", function ()
        it("returns grid y", function ()
            assert.are.equal(2, place:getGridY())
        end)
    end)

    describe("isTrack", function ()
        it("is not a Track", function ()
            assert.is_false(place:isTrack())
        end)
    end)

    describe("isPlatform", function ()
        it ("is a platform", function ()
            assert.is_false(place:isPlatform())
        end)
    end)

    describe("isPlace", function ()
        it("returns always false", function ()
            assert.is_true(place:isPlace())
        end)
    end)
end)