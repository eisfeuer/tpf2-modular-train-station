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

    describe('isOnTopBorder', function ()
        it ('checks weather asset is placed on a grid element on the top grid border', function ()
            local blueprint = Blueprint:new{}

            local assetBlueprint = AssetBlueprint:new{
                blueprint = blueprint,
                gridX = 2,
                gridY = 2,
                gridStartY = -2,
                gridEndY = 2
            }

            assert.is_true(assetBlueprint:isOnTopBorder())
            assert.is_true(assetBlueprint:isSidePlatformTop())
            assert.is_true(assetBlueprint:isSidePlatform())
            assert.is_false(assetBlueprint:isIslandPlatform())
        end)
    end)

    describe('isOnBottomBorder', function ()
        it ('checks weather platform is the side platform on top of the station', function ()
            local blueprint = Blueprint:new{}

            local assetBlueprint = AssetBlueprint:new{
                blueprint = blueprint,
                gridX = 2,
                gridY = -1,
                gridStartY = -1,
                gridEndY = 2
            }

            assert.is_true(assetBlueprint:isOnBottomBorder())
            assert.is_true(assetBlueprint:isSidePlatformBottom())
            assert.is_true(assetBlueprint:isSidePlatform())
            assert.is_false(assetBlueprint:isIslandPlatform())
        end)
    end)

    describe('hasIslandPlatformSlots', function ()
        it ('checks weather platform has island platform slots', function ()
            local blueprint = Blueprint:new{}

            local assetBlueprint = AssetBlueprint:new{
                blueprint = blueprint,
                gridX = 2,
                gridY = -1,
                gridStartY = -3,
                gridEndY = 3,
                options = {hasIslandPlatformSlots = true}
            }

            assert.is_true(assetBlueprint:hasIslandPlatformSlots())
            assert.is_true(assetBlueprint:isIslandPlatform())
        end)
    end)

    describe('isOnLeftBorder', function ()
        it ('checks weather asset is placed on a grid element on the left grid border', function ()
            local blueprint = Blueprint:new{}

            local assetBlueprint = AssetBlueprint:new{
                blueprint = blueprint,
                gridX = -3,
                gridY = -1,
                gridStartX = -3,
                gridEndX = 3,
            }

            assert.is_true(assetBlueprint:isOnLeftBorder())
            assert.is_false(assetBlueprint:isOnRightBorder())
        end)

        it ('checks weather asset is placed on a grid element on the right grid border', function ()
            local blueprint = Blueprint:new{}

            local assetBlueprint = AssetBlueprint:new{
                blueprint = blueprint,
                gridX = 3,
                gridY = -1,
                gridStartX = -3,
                gridEndX = 3,
            }

            assert.is_true(assetBlueprint:isOnRightBorder())
            assert.is_false(assetBlueprint:isOnLeftBorder())
        end)
    end)

    describe('getOption', function ()
        local blueprint = Blueprint:new{}
        
        local assetBlueprint = AssetBlueprint:new{
            options = {anOption = 'value'}
        }

        assert.are.equal('value', assetBlueprint:getOption('anOption'))
        assert.is_nil(assetBlueprint:getOption('otherValue'))
        assert.are.equal('default', assetBlueprint:getOption('otherValue', 'default'))
    end)

    describe('getHorizontalSize', function ()
        it ('returns horizontal size')
            local blueprint = Blueprint:new{}
            local assetBlueprint1 = AssetBlueprint:new{
                blueprint = blueprint,
                gridX = 3,
                gridY = -1,
                gridStartX = -3,
                gridEndX = 3,
            }

            local assetBlueprint2 = AssetBlueprint:new{
                blueprint = blueprint,
                gridX = 3,
                gridY = -1,
                gridStartX = 1,
                gridEndX = 3,
            }

            local assetBlueprint3 = AssetBlueprint:new{
                blueprint = blueprint,
                gridX = 3,
                gridY = -1,
                gridStartX = -1,
                gridEndX = 1,
            }

            assert.are.equal(7, assetBlueprint1:getHorizontalSize())
            assert.are.equal(3, assetBlueprint2:getHorizontalSize())
            assert.are.equal(3, assetBlueprint3:getHorizontalSize())
    end)

    describe('horizontalSizeIsEven', function ()
        local blueprint = Blueprint:new{}
        local assetBlueprint1 = AssetBlueprint:new{
            blueprint = blueprint,
            gridX = 3,
            gridY = -1,
            gridStartX = -3,
            gridEndX = 3,
        }

        local assetBlueprint2 = AssetBlueprint:new{
            blueprint = blueprint,
            gridX = 3,
            gridY = -1,
            gridStartX = -3,
            gridEndX = 2,
        }

        assert.is_false(assetBlueprint1:horizontalSizeIsEven())
        assert.is_true(assetBlueprint1:horizontalSizeIsOdd())
        assert.is_true(assetBlueprint2:horizontalSizeIsEven())
        assert.is_false(assetBlueprint2:horizontalSizeIsOdd())
    end)

    describe('getRelativeHorizontalDistanceToCenter', function ()
        local blueprint = Blueprint:new{}
        local assetBlueprint1 = AssetBlueprint:new{
            blueprint = blueprint,
            gridX = 3,
            gridY = -1,
            gridStartX = -3,
            gridEndX = 3,
        }

        local assetBlueprint2 = AssetBlueprint:new{
            blueprint = blueprint,
            gridX = 3,
            gridY = -1,
            gridStartX = -3,
            gridEndX = 4,
        }

        local assetBlueprint3 = AssetBlueprint:new{
            blueprint = blueprint,
            gridX = -1,
            gridY = -1,
            gridStartX = -1,
            gridEndX = 1,
        }

        local assetBlueprint4 = AssetBlueprint:new{
            blueprint = blueprint,
            gridX = 1,
            gridY = -1,
            gridStartX = -1,
            gridEndX = 1,
        }

        assert.are.equal(3, assetBlueprint1:getRelativeHorizontalDistanceToCenter())
        assert.are.equal(3.5, assetBlueprint2:getRelativeHorizontalDistanceToCenter())
        assert.are.equal(1, assetBlueprint3:getRelativeHorizontalDistanceToCenter())
        assert.are.equal(1, assetBlueprint4:getRelativeHorizontalDistanceToCenter())
    end)

    describe('isNthSegmentFromCenter', function ()
        local blueprint = Blueprint:new{}
        local assetBlueprint1 = AssetBlueprint:new{
            blueprint = blueprint,
            gridX = 3,
            gridY = -1,
            gridStartX = -3,
            gridEndX = 3,
        }

        local assetBlueprint2 = AssetBlueprint:new{
            blueprint = blueprint,
            gridX = 3,
            gridY = -1,
            gridStartX = -3,
            gridEndX = 4,
        }

        assert.is_true(assetBlueprint1:isNthSegmentFromCenter(3))
        assert.is_false(assetBlueprint1:isNthSegmentFromCenter(4))
        assert.is_false(assetBlueprint2:isNthSegmentFromCenter(3))
        assert.is_true(assetBlueprint2:isNthSegmentFromCenter(4))
    end)

    describe('isInEveryNthSegmentFromCenter', function ()
        local blueprint = Blueprint:new{}
        local assetBlueprint1 = AssetBlueprint:new{
            blueprint = blueprint,
            gridX = 6,
            gridY = -1,
            gridStartX = -3,
            gridEndX = 3,
        }

        local assetBlueprint2 = AssetBlueprint:new{
            blueprint = blueprint,
            gridX = 7,
            gridY = -1,
            gridStartX = -3,
            gridEndX = 4,
        }

        assert.is_true(assetBlueprint1:isInEveryNthSegmentFromCenter(3))
        assert.is_false(assetBlueprint1:isInEveryNthSegmentFromCenter(4))
        assert.is_false(assetBlueprint2:isInEveryNthSegmentFromCenter(3))
        assert.is_true(assetBlueprint2:isInEveryNthSegmentFromCenter(4))
    end)
end)