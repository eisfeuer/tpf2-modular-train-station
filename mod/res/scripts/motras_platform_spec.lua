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
    local platform = Platform:new(gridElement)

    describe("getSlotId", function ()
        it("returns slot id", function ()
            assert.are.equal(slotId, platform:getSlotId())
        end)
    end)

    describe("getGridType", function ()
        it("returns grid type", function ()
            assert.are.equal(t.GRID_PLATFORM, platform:getGridType())
        end)
        
    end)

    describe("getType", function ()
        it("returns type", function ()
            assert.are.equal(t.PLATFORM, platform:getType())
        end)
    end)

    describe("getGridX", function ()
        it("returns grid x", function ()
            assert.are.equal(1, platform:getGridX())
        end)
    end)

    describe("getGridY", function ()
        it("returns grid y", function ()
            assert.are.equal(2, platform:getGridY())
        end)
    end)

    describe("isTrack", function ()
        it("is not a Track", function ()
            assert.is_false(platform:isTrack())
        end)
    end)

    describe("isPlatform", function ()
        it ("is a platform", function ()
            assert.is_true(platform:isPlatform())
        end)
    end)

    describe("isPlace", function ()
        it("returns always false", function ()
            assert.is_false(platform:isPlace())
        end)
    end)

    describe("isBlank", function ()
        it ("is not blank", function ()
            assert.is_false(gridElement:isBlank())
        end)
    end)

    describe("handle/call", function ()
        it("calls handler function", function ()
            platform:handle(function(result)
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

            platform:call(result)

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