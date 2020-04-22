local Station = require('motras_station')
local Slot = require('motras_slot')
local t = require('motras_types')

local Asset = require('motras_asset')

describe('Asset', function ()
    
    local station = Station:new{}
    local platform = station:initializeAndRegister(Slot.makeId({type = t.PLATFORM, gridX = 2, gridY = 4}))
    local assetSlot = Slot:new{id = Slot.makeId({type = t.ROOF, gridX = 2, gridY = 4, assetId = 1})}
    local asset = Asset:new{slot = assetSlot, parent = platform, options = {height = 23}}

    describe('getParentGridElement', function ()
        it('returns parent grid element', function ()
            assert.are.equal(platform, asset:getParentGridElement())
        end)
    end)

    describe('getSlotId', function ()
        it('returns slot id', function ()
            assert.are.equal(assetSlot.id, asset:getSlotId())
        end)
    end)

    describe('getType', function ()
        it ('returns type', function ()
            assert.are.equal(t.ROOF, asset:getType())
        end)
    end)

    describe('getGrid', function ()
        it('returns grid', function ()
            assert.are.equal(station.grid, asset:getGrid())
        end)
    end)

    describe('getGridX', function ()
        it('returns grid x', function ()
            assert.are.equal(2, asset:getGridX())
        end)
    end)

    describe('getGridY', function ()
        it('returns grid y', function ()
            assert.are.equal(4, asset:getGridY())
        end)
    end)

    describe('handle / call', function ()
        it ("does not change anything when handle function is not definded", function ()
            local result = {
                models = {}
            }

            asset:call(result)

            assert.are.same({
                models = {}
            }, result)
        end)

        it('calls handler function', function ()
            asset:handle(function(result)
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

            asset:call(result)

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

    describe("getOption", function ()
        it ('returns option', function ()
            assert.are.equal(23, asset:getOption('height', 34))
        end)

        it ('returns nil when option does not exists', function ()
            assert.are.equal(nil, asset:getOption('an_option'))
        end)

        it ('returns default when option does not exists', function ()
            assert.are.equal(42, asset:getOption('an_option', 42))
        end)
    end)

end)