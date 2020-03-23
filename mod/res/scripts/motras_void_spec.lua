local Slot = require("motras_slot")
local t = require("motras_types")
local Grid = require("motras_grid")

local GridElement = require("motras_grid_element")
local Void = require("motras_void")

describe("Void", function()
    local slotId = Slot.makeId({
        gridX = 1,
        gridY = 2
    })
    local slot = Slot:new{id = slotId}
    local gridElement = GridElement:new{slot = slot, grid = Grid:new{}}
    local void = Void:new(gridElement)

    describe("new", function ()
        it("makes void from params", function ()
            local void = Void:new({
                    gridX = 1,
                    gridY = 2
                },
                Grid:new{}
            )

            assert.are.equal(1, void:getGridX())
            assert.are.equal(2, void:getGridY())
        end)
    end)

    describe("getSlotId", function ()
        it("returns nil", function ()
            assert.are.equal(nil, void:getSlotId())
        end)
    end)

    describe("getGridType", function ()
        it("returns grid type", function ()
            assert.are.equal(t.VOID, void:getGridType())
        end)
        
    end)

    describe("getType", function ()
        it("returns type", function ()
            assert.are.equal(t.VOID, void:getType())
        end)
    end)

    describe("getGridX", function ()
        it("returns grid x", function ()
            assert.are.equal(1, void:getGridX())
        end)
       
    end)

    describe("getGridY", function ()
        it("returns grid y", function ()
            assert.are.equal(2, void:getGridY())
        end)
    end)

    describe("isTrack", function ()
        it("is not a track", function ()
            assert.is_false(void:isTrack())
        end)
    end)

    describe("isPlatform", function ()
        it ("is not a platform", function ()
            assert.is_false(void:isPlatform())
        end)
    end)

    describe("isPlace", function ()
        it("returns always false", function ()
            assert.is_false(void:isPlace())
        end)
    end)

    describe("isBlank", function ()
        it ("is not blank", function ()
            assert.is_true(gridElement:isBlank())
        end)
    end)
end)