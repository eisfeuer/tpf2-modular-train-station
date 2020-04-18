local Slot = require("motras_slot")
local Grid = require("motras_grid")
local t = require("motras_types")
local c = require("motras_constants")

local GridElement = require("motras_grid_element")

describe("GridElement", function()
    local slotId = Slot.makeId({
        type = t.PLATFORM,
        gridX = 1,
        gridY = 2
    })
    local grid = Grid:new{
        horizontalDistance = c.DEFAULT_HORIZONTAL_GRID_DISTANCE,
        verticalDistance = c.DEFAULT_VERTICAL_GRID_DISTANCE,
        baseHeight = c.DEFAULT_BASE_HEIGHT
    }
    local slot = Slot:new{id = slotId}
    local gridElement = GridElement:new{slot = slot, grid = grid, options = {platformHeight = 0.96}}

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

    describe("call", function ()
        it ("does not change anything when handle function is not definded", function ()
            local result = {
                models = {}
            }

            gridElement:call(result)

            assert.are.same({
                models = {}
            }, result)
        end)
    end)

    describe("getAbsoluteX", function ()
        it ('returns the local absulute x coord', function ()
            assert.are.equal(c.DEFAULT_HORIZONTAL_GRID_DISTANCE, gridElement:getAbsoluteX())
        end)
    end)

    describe("getAbsoluteY", function ()
        it ('returns the local absulute x coord', function ()
            assert.are.equal(2 * c.DEFAULT_VERTICAL_GRID_DISTANCE, gridElement:getAbsoluteY())
        end)
    end)

    describe("getAbsoluteZ", function ()
        it ('returns base grid height', function ()
            assert.are.equal(c.DEFAULT_BASE_HEIGHT, gridElement:getAbsoluteZ())
        end)
    end)

    describe("getOption", function ()
        it ('returns option', function ()
            assert.are.equal(0.96, gridElement:getOption('platformHeight', 0.55))
        end)

        it ('returns nil when option does not exists', function ()
            assert.are.equal(nil, gridElement:getOption('an_option'))
        end)

        it ('returns default when option does not exists', function ()
            assert.are.equal(42, gridElement:getOption('an_option', 42))
        end)
    end)
end)