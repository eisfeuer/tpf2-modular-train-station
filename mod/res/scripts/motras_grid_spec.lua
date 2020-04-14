local GridElement = require("motras_grid_element")
local Slot = require("motras_slot")
local t = require("motras_types")
local c = require("motras_constants")
local Grid = require("motras_grid")
local Station = require("motras_station")


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

        it ("checks wheter grid has no element stored 2", function ()
            local grid = Grid:new()
            assert.is_true(grid:isEmpty())

            local gridElement = GridElement:new{slot = Slot:new{id = Slot.makeId({
                type = t.TRACK,
                gridX = 0,
                gridY = 0
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
        it("returns vertical distance", function ()
            local grid = Grid:new{verticalDistance = 25}
            assert.are.equal(25, grid:getVerticalDistance())
        end)
    end)

    describe("getHorizontalDistance", function ()
        it("returns horizontal distance", function ()
            local grid = Grid:new{horizontalDistance = 15}
            assert.are.equal(15, grid:getHorizontalDistance())
        end)
    end)

    describe("getModulePrefix", function ()
        it("returns module prefix", function ()
            local grid = Grid:new{modulePrefix = 'my_station'}
            assert.are.equal('my_station', grid:getModulePrefix())
        end)
    end)

    describe("getBaseHeight", function ()
        it("returns base height", function ()
            local grid = Grid:new{baseHeight = 4}
            assert.are.equal(4, grid:getBaseHeight())
        end)
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

    describe("handleModules", function ()
        it ("handles all placed modules", function ()
            local station = Station:new{}
            local trackModule = station:initializeAndRegister(Slot.makeId({type = t.TRACK, gridX = 0, gridY = 0}))
            trackModule:handle(function(result)
                table.insert(result.models, {
                    id = 'a_track_model.mdl',
                    transf = {
                        1, 0, 0, 0,
                        0, 1, 0, 0,
                        0, 0, 1, 0,
                        0, 0, 0, 1
                    }
                })
            end)

            local platformModule = station:initializeAndRegister(Slot.makeId({type = t.TRACK, gridX = 0, gridY = 1}))
            platformModule:handle(function (result)
                table.insert(result.models, {
                    id = 'a_platform_model.mdl',
                    transf = {
                        1, 0, 0, 0,
                        0, 1, 0, 0,
                        0, 0, 1, 0,
                        0, 5, 0, 1
                    }
                })
            end)

            local result = {
                models = {}
            }
    
            station.grid:handleModules(result)

            assert.are.same({
                models = {
                    {
                        id = 'a_platform_model.mdl',
                        transf = {
                            1, 0, 0, 0,
                            0, 1, 0, 0,
                            0, 0, 1, 0,
                            0, 5, 0, 1
                        }
                    }, {
                        id = 'a_track_model.mdl',
                        transf = {
                            1, 0, 0, 0,
                            0, 1, 0, 0,
                            0, 0, 1, 0,
                            0, 0, 0, 1
                        },
                    }
                }
            }, result)
        end)
    end)

    describe('getActiveGridBounds', function ()
        it ('returns bounds of the square where all modules are placed', function ()
        
            local grid = Grid:new()

            assert.are.same({
                top = 0,
                bottom = 0,
                left = 0,
                right = 0,
            }, grid:getActiveGridBounds())

            local gridElement = GridElement:new{slot = Slot:new{id = Slot.makeId({
                type = t.TRACK,
                gridX = 1,
                gridY = 2
            })}, grid = grid}

            grid:set(gridElement)

            assert.are.same({
                top = 2,
                bottom = 0,
                left = 0,
                right = 1,
            }, grid:getActiveGridBounds())

            local gridElement = GridElement:new{slot = Slot:new{id = Slot.makeId({
                type = t.TRACK,
                gridX = 1,
                gridY = -3
            })}, grid = grid}

            grid:set(gridElement)

            assert.are.same({
                top = 2,
                bottom = -3,
                left = 0,
                right = 1,
            }, grid:getActiveGridBounds())

            local gridElement = GridElement:new{slot = Slot:new{id = Slot.makeId({
                type = t.TRACK,
                gridX = -1,
                gridY = -2
            })}, grid = grid}
            
            grid:set(gridElement)

            assert.are.same({
                top = 2,
                bottom = -3,
                left = -1,
                right = 1,
            }, grid:getActiveGridBounds())

        end)
    end)

    describe('getActiveSlotGridBounds', function ()
        it ('returns bounds of the square where all possible slots are in', function ()        
            local grid = Grid:new()

            assert.are.same({
                top = 1,
                bottom = -1,
                left = -1,
                right = 1,
            }, grid:getActiveGridSlotBounds())

            local gridElement = GridElement:new{slot = Slot:new{id = Slot.makeId({
                type = t.TRACK,
                gridX = 1,
                gridY = 2
            })}, grid = grid}

            grid:set(gridElement)

            assert.are.same({
                top = 3,
                bottom = -1,
                left = -1,
                right = 2,
            }, grid:getActiveGridSlotBounds())

            local gridElement = GridElement:new{slot = Slot:new{id = Slot.makeId({
                type = t.TRACK,
                gridX = 1,
                gridY = -3
            })}, grid = grid}

            grid:set(gridElement)

            assert.are.same({
                top = 3,
                bottom = -4,
                left = -1,
                right = 2,
            }, grid:getActiveGridSlotBounds())

            local gridElement = GridElement:new{slot = Slot:new{id = Slot.makeId({
                type = t.TRACK,
                gridX = -1,
                gridY = -2
            })}, grid = grid}
            
            grid:set(gridElement)

            assert.are.same({
                top = 3,
                bottom = -4,
                left = -2,
                right = 2,
            }, grid:getActiveGridSlotBounds())
        end)
    end)

end)