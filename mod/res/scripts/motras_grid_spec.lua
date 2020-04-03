local GridElement = require("motras_grid_element")
local Slot = require("motras_slot")
local t = require("motras_types")
local c = require("motras_constants")
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
    
    describe("has", function ()
        it("checks wheter an element exists on given position", function ()
            local grid = Grid:new()
            local gridElement = GridElement:new{slot = Slot:new{id = Slot.makeId({
                type = t.TRACK,
                gridX = 1,
                gridY = 2
            })}, grid = grid}

            grid:set(gridElement)

            assert.is_false(grid:has(1,3))
            assert.is_true(grid:has(1,2))
        end)
    end)

    describe("getVerticalDistance", function ()
        it("returns custom vertical distance", function ()
            local grid = Grid:new{verticalDistance = 25}
            assert.are.equal(25, grid:getVerticalDistance())
        end)
    end)

    describe("getHorizontalDistance", function ()
        local grid = Grid:new{horizontalDistance = 15}
        assert.are.equal(15, grid:getHorizontalDistance())
    end)

    describe("isInBounds", function ()
        it("checks wheter position is in allowed bounds", function ()
            assert.is_true(Grid.isInBounds(1,2))
            assert.is_true(Grid.isInBounds(c.GRID_MAX_XY_POSITION, c.GRID_MAX_XY_POSITION))
            assert.is_true(Grid.isInBounds(-c.GRID_MAX_XY_POSITION, -c.GRID_MAX_XY_POSITION))

            assert.is_false(Grid.isInBounds(c.GRID_MAX_XY_POSITION + 1, c.GRID_MAX_XY_POSITION))
            assert.is_false(Grid.isInBounds(-c.GRID_MAX_XY_POSITION - 1, -c.GRID_MAX_XY_POSITION))
            assert.is_false(Grid.isInBounds(c.GRID_MAX_XY_POSITION, c.GRID_MAX_XY_POSITION + 1))
            assert.is_false(Grid.isInBounds(-c.GRID_MAX_XY_POSITION, -c.GRID_MAX_XY_POSITION - 1))
        end)
    end)

end)