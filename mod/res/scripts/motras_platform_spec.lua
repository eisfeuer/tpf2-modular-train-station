local Slot = require("motras_slot")
local t = require("motras_types")
local Grid = require("motras_grid")

local GridElement = require("motras_grid_element")
local Platform = require("motras_platform")

describe("Platform", function()
    local slotId = Slot.makeId({
        type = t.PLATFORM,
        gridX = 1,
        gridY = 2
    })
    local slot = Slot:new{id = slotId}
    local gridElement = GridElement:new{slot = slot, grid = Grid:new{}}
    local Platform = Platform:new(gridElement)

    describe("getSlotId", function ()
        it("returns slot id", function ()
            assert.are.equal(slotId, Platform:getSlotId())
        end)
    end)

    describe("getGridType", function ()
        it("returns grid type", function ()
            assert.are.equal(t.GRID_PLATFORM, Platform:getGridType())
        end)
        
    end)

    describe("getType", function ()
        it("returns type", function ()
            assert.are.equal(t.PLATFORM, Platform:getType())
        end)
    end)

    describe("getGridX", function ()
        it("returns grid x", function ()
            assert.are.equal(1, Platform:getGridX())
        end)
    end)

    describe("getGridY", function ()
        it("returns grid y", function ()
            assert.are.equal(2, Platform:getGridY())
        end)
    end)

    describe("isTrack", function ()
        it("is not a Track", function ()
            assert.is_false(Platform:isTrack())
        end)
    end)

    describe("isPlatform", function ()
        it ("is a platform", function ()
            assert.is_true(Platform:isPlatform())
        end)
    end)

    describe("isPlace", function ()
        it("returns always false", function ()
            assert.is_false(Platform:isPlace())
        end)
    end)

    describe("isBlank", function ()
        it ("is not blank", function ()
            assert.is_false(gridElement:isBlank())
        end)
    end)
end)