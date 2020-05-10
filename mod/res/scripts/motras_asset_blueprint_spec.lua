local TestUtils = require('motras_testutils')
TestUtils.loadTpf2Libs()

local Blueprint = require('motras_blueprint')
local t = require('motras_types')
local Slot = require('motras_slot')

local AssetBlueprint = require('motras_asset_blueprint')

describe('AssetBlueprint', function ()
    describe('addAsset', function ()
        it ('adds asset to template', function ()
            local blueprint = Blueprint:new{}

            local assetBlueprint = AssetBlueprint:new{
                blueprint = blueprint,
                gridX = 2,
                gridY = -1
            }

            assetBlueprint:addAsset(t.DECORATION, 'asset.module', 4)

            assert.are.same({
                [Slot.makeId({type = t.DECORATION, gridX = 2, gridY = -1, assetId = 4})] = 'asset.module'
            }, blueprint:toTpf2Template())
        end)

        it ('adds asset with decoration to template', function ()
            local blueprint = Blueprint:new{}

            local assetBlueprint = AssetBlueprint:new{
                blueprint = blueprint,
                gridX = 2,
                gridY = -1
            }

            assetBlueprint:addAsset(t.DECORATION, 'asset.module', 4, function (decorationBlueprint)
                decorationBlueprint:decorate(t.ASSET_DECORATION, 'clock.module', 2)
            end)

            assert.are.same({
                [Slot.makeId({type = t.DECORATION, gridX = 2, gridY = -1, assetId = 4})] = 'asset.module',
                [Slot.makeId({type = t.ASSET_DECORATION, gridX = 2, gridY = -1, assetId = 4, assetDecorationId = 2})] = 'clock.module'
            }, blueprint:toTpf2Template())
        end)
    end)

    describe('getGridX', function ()
        it ('returns grid x', function ()
            local blueprint = Blueprint:new{}

            local assetBlueprint = AssetBlueprint:new{
                blueprint = blueprint,
                gridX = 2,
                gridY = -1
            }

            assert.are.equal(2, assetBlueprint:getGridX())
        end)
    end)

    describe('getGridY', function ()
        it ('returns grid y', function ()
            local blueprint = Blueprint:new{}

            local assetBlueprint = AssetBlueprint:new{
                blueprint = blueprint,
                gridX = 2,
                gridY = -1
            }

            assert.are.equal(-1, assetBlueprint:getGridY())
        end)
    end)

    describe('isSidePlatformTop', function ()
        it ('checks weather platform is the side platform on top of the station', function ()
            local blueprint = Blueprint:new{}

            local assetBlueprint = AssetBlueprint:new{
                blueprint = blueprint,
                gridX = 2,
                gridY = -1,
                sidePlatformTop = true
            }

            assert.is_true(assetBlueprint:isSidePlatformTop())
            assert.is_true(assetBlueprint:isSidePlatform())
            assert.is_false(assetBlueprint:isIslandPlatform())
        end)
    end)

    describe('isSidePlatformBottom', function ()
        it ('checks weather platform is the side platform on top of the station', function ()
            local blueprint = Blueprint:new{}

            local assetBlueprint = AssetBlueprint:new{
                blueprint = blueprint,
                gridX = 2,
                gridY = -1,
                sidePlatformBottom = true
            }

            assert.is_true(assetBlueprint:isSidePlatformBottom())
            assert.is_true(assetBlueprint:isSidePlatform())
            assert.is_false(assetBlueprint:isIslandPlatform())
        end)
    end)

    describe('hasDoublePlatformSlots', function ()
        it ('checks weather platform has island platform slots', function ()
            local blueprint = Blueprint:new{}

            local assetBlueprint = AssetBlueprint:new{
                blueprint = blueprint,
                gridX = 2,
                gridY = -1,
                islandPlatformSlots = true
            }

            assert.is_true(assetBlueprint:hasIslandPlatformSlots())
            assert.is_true(assetBlueprint:isIslandPlatform())
        end)
    end)
end)