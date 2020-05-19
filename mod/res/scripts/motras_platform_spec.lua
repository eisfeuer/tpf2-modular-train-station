local Slot = require("motras_slot")
local t = require("motras_types")
local Grid = require("motras_grid")
local c = require("motras_constants")

local GridElement = require("motras_grid_element")
local Platform = require("motras_platform")

describe("Platform", function()
    local slotId = Slot.makeId({
        type = t.PLATFORM,
        gridX = 1,
        gridY = 2
    })
    local slot = Slot:new{id = slotId}
    local gridElement = GridElement:new{slot = slot, grid = Grid:new{
        baseTrackHeight = c.DEFAULT_BASE_TRACK_HEIGHT, baseHeight = 0, horizontalDistance = c.DEFAULT_HORIZONTAL_GRID_DISTANCE, verticalDistance = c.DEFAULT_VERTICAL_GRID_DISTANCE
    }, options = {platformHeight = 0.96}}
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

    describe("getPlatformHeight", function ()
        it("returns platform height", function ()
            assert.are.equal(0.96, platform:getPlatformHeight())
        end)

        it("returns default platform height", function ()
            local gridElement1 = GridElement:new{slot = slot, grid = Grid:new{baseTrackHeight = c.DEFAULT_BASE_TRACK_HEIGHT}}
            local platform1 = Platform:new(gridElement1)
            assert.are.equal(c.DEFAULT_PLATFORM_HEIGHT, platform1:getPlatformHeight())
        end)
    end)

    describe("getAbsoulutePlatformHeight", function ()
        it("returns absolute platform height", function ()
            assert.are.equal(0.96 + c.DEFAULT_BASE_TRACK_HEIGHT, platform:getAbsolutePlatformHeight())
        end)
    end)

    describe("getGlobalTransformationBasedOnPlatformTop", function ()
        it ("gets global position from a position local from the top mid of the platform module", function ()
            assert.are.same({
                1, 0, 0, 0,
                0, 1, 0, 0,
                0, 0, 1, 0,
                platform:getAbsoluteX() - 1, platform:getAbsoluteY() + 1, platform:getAbsolutePlatformHeight() + 2, 1
            }, platform:getGlobalTransformationBasedOnPlatformTop({x = -1, y = 1, z = 2}))
        end)
    end)

    describe("applyPlatformHeightOnTransformation", function ()
        it("applies platform height on any transformation matrix", function()
            local originTranformation = {
                1, 0, 0, 0,
                0, 1, 0, 0,
                0, 0, 1, 0,
                1, 2, 3, 1,
            }
            local expectedTranformation = {
                1, 0, 0, 0,
                0, 1, 0, 0,
                0, 0, 1, 0,
                1, 2, 3 + c.DEFAULT_BASE_TRACK_HEIGHT + 0.96, 1,
            }

            local transformation = platform:applyPlatformHeightOnTransformation(originTranformation)
            
            assert.are_not.equal(originTranformation, transformation)
            assert.are.same(expectedTranformation, transformation)
        end)
    end)

    describe("handleTerminals / callTerminalHandling", function ()
        it ('handles default terminal handling', function ()
            local stuff = {}

            local addTerminalFunc = function (model, transformation, terminalId)
                stuff.model = model
                stuff.transformation = transformation
                stuff.terminalId = terminalId
            end

            platform:callTerminalHandling(addTerminalFunc, -1, false)

            assert.are.same({
                model = c.DEFAULT_PASSENGER_TERMINAL_MODEL,
                transformation = platform:getGlobalTransformationBasedOnPlatformTop({
                    x = 0, y = -c.DEFAULT_PLATFORM_WAITING_EDGE_OFFSET, z = 0
                }),
                terminalId = 0
            }, stuff)
        end)
        it ('handles terminals', function ()
            local stuff = {}

            local addTerminalFunc = function (model, transformation, terminalId)
                stuff.model = model
                stuff.transformation = transformation
                stuff.terminalId = terminalId
            end

            platform:handleTerminals(function (addTerminalFunc)
                addTerminalFunc('a_terminal_model', platform:getGlobalTransformationBasedOnPlatformTop({x = 0, y = 2.5, z = 0}), 1)
            end)
            platform:callTerminalHandling(addTerminalFunc, 1, true)
            
            assert.are.same({
                model = 'a_terminal_model',
                transformation = platform:getGlobalTransformationBasedOnPlatformTop({x = 0, y = 2.5, z = 0}),
                terminalId = 1
            }, stuff)
        end)
    end)
end)