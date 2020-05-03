local Station = require("motras_station")
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
        baseHeight = c.DEFAULT_BASE_HEIGHT,
        modulePrefix = 'motras'
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

    describe("registerAsset", function ()
        it("registers asset", function ()
            local assetSlotId = Slot.makeId({type = t.DECORATION, gridX = 1, gridY = 2})
            local assetSlot = Slot:new{id = assetSlotId}
            local asset = gridElement:registerAsset(12, assetSlot, {height = 320})

            assert.are.equal(assetSlotId, asset:getSlotId())
            assert.are.equal(1, asset:getGridX())
            assert.are.equal(2, asset:getGridY())
        end)
    end)

    describe("hasAsset", function ()
        it ("checks whether grid element has asset", function ()
            assert.is_true(gridElement:hasAsset(12))
            assert.is_true(gridElement:hasAsset(12, t.DECORATION))
            assert.is_false(gridElement:hasAsset(14))
            assert.is_false(gridElement:hasAsset(14, t.ROOF))
        end)
    end)

    describe("getAsset", function ()
        it ("returns asset", function ()
            local assetSlotId = Slot.makeId({type = t.DECORATION, gridX = 1, gridY = 2})
            local asset = gridElement:getAsset(12)

            assert.are.equal(assetSlotId, asset:getSlotId())
            assert.are.equal(1, asset:getGridX())
            assert.are.equal(2, asset:getGridY())

            assert.are.equal(nil, gridElement:getAsset(14))
        end)
    end)

    describe("addAssetSlot", function ()
        it("adds asset slot to collection (1m above the base slot)", function ()
            local slots = {}

            gridElement:addAssetSlot(slots, 3)

            assert.are.same({{
                id = Slot.makeId({type = t.ASSET, gridX = 1, gridY = 2, assetId = 3}),
                transf = {
                    1, 0, 0, 0,
                    0, 1, 0, 0,
                    0, 0, 1, 0,
                    gridElement:getAbsoluteX(), gridElement:getAbsoluteY(), 1, 1
                },
                type = 'motras_asset',
                spacing = c.DEFAULT_ASSET_SLOT_SPACING,
                shape = 0
            }}, slots)
        end)

        it("adds custom asset slot", function ()
            local slots = {}

            gridElement:addAssetSlot(slots, 3, {
                assetType = t.DECORATION,
                slotType = 'decoration',
                position = {1, 2, 4},
                global = false,
                spacing = {1,1,1,1},
                shape = 2
            })

            assert.are.same({{
                id = Slot.makeId({type = t.DECORATION, gridX = 1, gridY = 2, assetId = 3}),
                transf = {
                    1, 0, 0, 0,
                    0, 1, 0, 0,
                    0, 0, 1, 0,
                    gridElement:getAbsoluteX() + 1, gridElement:getAbsoluteY() + 2, 4, 1
                },
                type = 'decoration',
                spacing = {1, 1, 1, 1},
                shape = 2
            }}, slots)
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

        it("calls asset handler functions", function ()
            local result = {
                models = {}
            }

            local asset = gridElement:getAsset(12)
            asset:handle(function (moduleResult)
                table.insert(moduleResult.models, {
                    id = 'asset_model.mdl',
                    transf = {1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1}
                })
            end)

            gridElement:call(result)

            assert.are.same({
                models = {{
                    id = 'asset_model.mdl',
                    transf = {1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1}
                }}
            }, result)
        end)
    end)

    describe('hasNeighborLeft', function ()
        it('checks weather grid element has left neighbor', function ()
            local station = Station:new{}
            local testGridElement = station:initializeAndRegister(Slot.makeId({type = t.PLATFORM, gridX = 0, gridY = 0}))
            local leftNeighbor = station:initializeAndRegister(Slot.makeId({type = t.PLATFORM, gridX = -1, gridY = 0}))

            assert.is_true(testGridElement:hasNeighborLeft())
            assert.is_false(leftNeighbor:hasNeighborLeft())
        end)
    end)

    describe('getNeighborLeft', function ()
        it('returns left neighbor', function ()
            local station = Station:new{}
            local testGridElement = station:initializeAndRegister(Slot.makeId({type = t.PLATFORM, gridX = 0, gridY = 0}))
            local leftNeighbor = station:initializeAndRegister(Slot.makeId({type = t.PLATFORM, gridX = -1, gridY = 0}))

            assert.are.equal(leftNeighbor, testGridElement:getNeighborLeft())
        end)
    end)

    describe('hasNeighborRight', function ()
        it('checks weather grid element has right neighbor', function ()
            local station = Station:new{}
            local testGridElement = station:initializeAndRegister(Slot.makeId({type = t.PLATFORM, gridX = 0, gridY = 0}))
            local rightNeighbor = station:initializeAndRegister(Slot.makeId({type = t.PLATFORM, gridX = 1, gridY = 0}))

            assert.is_true(testGridElement:hasNeighborRight())
            assert.is_false(rightNeighbor:hasNeighborRight())
        end)
    end)

    describe('getNeighborRight', function ()
        it('returns right neighbor', function ()
            local station = Station:new{}
            local testGridElement = station:initializeAndRegister(Slot.makeId({type = t.PLATFORM, gridX = 0, gridY = 0}))
            local rightNeighbor = station:initializeAndRegister(Slot.makeId({type = t.PLATFORM, gridX = 1, gridY = 0}))

            assert.are.equal(rightNeighbor, testGridElement:getNeighborRight())
        end)
    end)

    describe('hasNeighborTop', function ()
        it('checks weather grid element has top neighbor', function ()
            local station = Station:new{}
            local testGridElement = station:initializeAndRegister(Slot.makeId({type = t.PLATFORM, gridX = 0, gridY = 0}))
            local neightborTop = station:initializeAndRegister(Slot.makeId({type = t.PLATFORM, gridX = 0, gridY = 1}))

            assert.is_true(testGridElement:hasNeighborTop())
            assert.is_false(neightborTop:hasNeighborTop())
        end)
    end)

    describe('getNeighborTop', function ()
        it('returns top neighbor', function ()
            local station = Station:new{}
            local testGridElement = station:initializeAndRegister(Slot.makeId({type = t.PLATFORM, gridX = 0, gridY = 0}))
            local neighborTop = station:initializeAndRegister(Slot.makeId({type = t.PLATFORM, gridX = 0, gridY = 1}))

            assert.are.equal(neighborTop, testGridElement:getNeighborTop())
        end)
    end)

    describe('hasNeighborBottom', function ()
        it('checks weather grid element has bottom neighbor', function ()
            local station = Station:new{}
            local testGridElement = station:initializeAndRegister(Slot.makeId({type = t.PLATFORM, gridX = 0, gridY = 0}))
            local neightborBottom = station:initializeAndRegister(Slot.makeId({type = t.PLATFORM, gridX = 0, gridY = -1}))

            assert.is_true(testGridElement:hasNeighborBottom())
            assert.is_false(neightborBottom:hasNeighborBottom())
        end)
    end)

    describe('getNeighborBottom', function ()
        it('returns bottom neighbor', function ()
            local station = Station:new{}
            local testGridElement = station:initializeAndRegister(Slot.makeId({type = t.PLATFORM, gridX = 0, gridY = 0}))
            local neighborBottom = station:initializeAndRegister(Slot.makeId({type = t.PLATFORM, gridX = 0, gridY = -1}))

            assert.are.equal(neighborBottom, testGridElement:getNeighborBottom())
        end)
    end)
end)