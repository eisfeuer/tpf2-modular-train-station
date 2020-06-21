local Station = require('motras_station')
local Slot = require('motras_slot')
local t = require('motras_types')

describe("AssetDecoration", function ()
    
    local station = Station:new{}
    local platform = station:initializeAndRegister(Slot.makeId({type = t.PLATFORM, gridX = 0, gridY = 0}))
    local asset = station:initializeAndRegister(Slot.makeId({type = t.ASSET, gridX = 0, gridY = 0, assetId = 4}))
    local deco = station:initializeAndRegister(Slot.makeId({type = t.ASSET_DECORATION, gridX = 0, gridY = 0, assetId = 4, assetDecorationId = 7}))

    describe('getId', function ()
        it('returns asset decoration id', function ()
            assert.are.equal(7, deco:getId())
        end)
    end)

    describe('getSlotId', function ()
        it('returns slot id', function ()
            assert.are.equal(Slot.makeId({type = t.ASSET_DECORATION, gridX = 0, gridY = 0, assetId = 4, assetDecorationId = 7}), deco:getSlotId())
        end)
    end)

    describe('getParentAsset', function ()
        it('returns parent asset', function ()
            assert.are.equal(asset, deco:getParentAsset())
        end)
    end)

    describe('getParentGridElement', function ()
        it('returns parent grid element', function ()
            assert.are.equal(platform, deco:getParentGridElement())
        end)
    end)

    describe('getGridX', function ()
        it('returns grid x', function ()
            assert.are.equal(platform:getGridX(), deco:getGridX())
        end)
    end)

    describe('getGridY', function ()
        it('returns grid y', function ()
            assert.are.equal(platform:getGridY(), deco:getGridY())
        end)
    end)

    describe('getAssetId', function ()
        it('returns asset id', function ()
            assert.are.equal(asset:getId(), deco:getAssetId())
        end)
    end)

    describe('getGrid', function ()
        it('returns grid', function ()
            assert.are.equal(asset:getGrid(), deco:getGrid())
        end)
    end)

    describe("getOption", function ()
        deco:setOptions({height = 23})

        it ('returns option', function ()
            assert.are.equal(23, deco:getOption('height', 34))
        end)

        it ('returns nil when option does not exists', function ()
            assert.are.equal(nil, deco:getOption('an_option'))
        end)

        it ('returns default when option does not exists', function ()
            assert.are.equal(42, deco:getOption('an_option', 42))
        end)
    end)

    describe('setOptions', function ()
        it('set options', function ()
            local testStation = Station:new{}
            testStation:initializeAndRegister(Slot.makeId({type = t.PLATFORM, gridX = 0, gridY = 0}))
            testStation:initializeAndRegister(Slot.makeId({type = t.ASSET, gridX = 0, gridY = 0, assetId = 2}))
            local testDeco = testStation:initializeAndRegister(Slot.makeId({type = t.ASSET_DECORATION, gridX = 0, gridY = 0, assetId = 2, assetDecorationId = 2}))

            testDeco:setOptions({opt1 = 'val1', opt2 = 'val2'})
            assert.are.equal('val1', testDeco:getOption('opt1'))
            assert.are.equal('val2', testDeco:getOption('opt2'))
        end)

        it('keeps old options', function ()
            local testStation = Station:new{}
            testStation:initializeAndRegister(Slot.makeId({type = t.PLATFORM, gridX = 0, gridY = 0}))
            testStation:initializeAndRegister(Slot.makeId({type = t.ASSET, gridX = 0, gridY = 0, assetId = 2}))
            local testDeco = testStation:initializeAndRegister(Slot.makeId({type = t.ASSET_DECORATION, gridX = 0, gridY = 0, assetId = 2, assetDecorationId = 2}))

            testDeco:setOption('opt1', 'val1')
            testDeco:setOptions({opt2 = 'val2'})
            assert.are.equal('val1', testDeco:getOption('opt1'))
            assert.are.equal('val2', testDeco:getOption('opt2'))
        end)
    end)

    describe('handle / call', function ()
        it ("does not change anything when handle function is not definded", function ()
            local result = {
                models = {}
            }

            deco:call(result)

            assert.are.same({
                models = {}
            }, result)
        end)

        it('calls handler function', function ()
            deco:handle(function(result)
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

            deco:call(result)

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