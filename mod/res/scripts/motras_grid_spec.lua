local GridElement = require("motras_grid_element")
local t = require("motras_types")
local Slot = require("motras_slot")
local Grid = require("motras_grid")

local Grid = require("motras_grid")

describe("Grid", function ()
    
    describe("new", function ()
        it("initializes empty grid", function ()
            local grid = Grid:new()
            assert.is_true(grid:isEmpty())
        end)
    end)

    describe("isEmpty", function ()
        it ("checks wheter grid has no element stored", function ()
            local grid = Grid:new()
            assert.is_true(grid:isEmpty())

            local gridElement = GridElement:new{slot = Slot:new{id = Slot.makeId({
                type = t.TRACK,
                gridX = 1,
                gridY = 2
            })}, grid = grid:new{}}

            grid:set(gridElement)
            assert.is_false(grid:isEmpty())
        end)
    end)

    describe("get/set", function ()
        it ("gets empty grid element", function ()
            local grid = Grid:new()
            local voidGridElement = grid:get(1,2)
            assert.is_true(voidGridElement:isBlank())
            assert.are.equal(1, voidGridElement:getGridX())
            assert.are.equal(2, voidGridElement:getGridY())
        end)

        it ("sets and get grid element", function ()
            local grid = Grid:new()
            local gridElement = GridElement:new{slot = Slot:new{id = Slot.makeId({
                type = t.TRACK,
                gridX = 1,
                gridY = 2
            })}, grid = grid}
            
            
            grid:set(gridElement)

            assert.are.equal(gridElement, grid:get(1,2))
        end)
    end)

end)