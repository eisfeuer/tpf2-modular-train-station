local Slot = require("motras_slot")
local Grid = require("motras_grid")
local t = require("motras_types")

local GridElement = require("motras_grid_element")

describe("GridElement", function()
    local slotId = Slot.makeId({
        type = t.PLATFORM,
        gridX = 1,
        gridY = 2
    })
    local grid = Grid:new{}
    local slot = Slot:new{id = slotId}
    local gridElement = GridElement:new{slot = slot, grid = grid}

    describe("getSlotId", function ()
        it ("returns slot id", function ()
            assert.are.equal(slotId, gridElement:getSlotId())
        end)
    end)

    describe("getGridType", function ()
        it ("returns grid type", function ()
            assert.are.equal(t.GRID_PLATFORM, gridElement:getGridType())
        end)
    end)

    describe("getType", function ()
        it ("returns type", function ()
            assert.are.equal(t.PLATFORM, gridElement:getType())
        end)
    end)

    describe("getGridX", function ()
        it ("returns grid x", function ()
            assert.are.equal(1, gridElement:getGridX())
        end)
    end)

    describe("getGridY", function ()
        it ("returns grid y", function ()
            assert.are.equal(2, gridElement:getGridY())
        end)
    end)

    describe("isTrack", function ()
        it ("is not a track", function ()
            assert.is_false(gridElement:isTrack())
        end)
    end)

    describe("isPlatform", function ()
        it ("is not a platform", function ()
            assert.is_false(gridElement:isPlatform())
        end)
    end)

    describe("isPlace", function ()
        it("returns always false", function ()
            assert.is_false(gridElement:isPlace())
        end)
    end)

    describe("isBlank", function ()
        it ("is not blank", function ()
            assert.is_false(gridElement:isBlank())
        end)
    end)

    describe("getGrid", function ()
        it ("returns the grid", function ()
            assert.are.equal(grid, gridElement:getGrid())
        end)
    end)
end)