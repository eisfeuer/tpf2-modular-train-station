local t = require('motras_types')

local TallPlatformStationPattern = require('motras_blueprint_patterns.tall_platform_station')

local function assertGridTypeAndModule(gridY, expectedGridType, expectedModule, passedInGridType, passedInModule, options)
    assert.are.same({}, options)
    assert.are.equal(expectedGridType, passedInGridType, 'failed at gridY ' .. gridY)
    assert.are.equal(expectedModule, passedInModule, 'failed at gridY ' .. gridY)
end

describe('TallPlatformStationPattern', function ()
    describe('getTypeAndModule', function ()
        it ('it returns grid types and modules (scenario 1)', function ()
            local pattern = TallPlatformStationPattern:new{trackModule = 'track.module', platformModule = 'platform.module', trackCount = 4, horizontalSize = 1}

            assertGridTypeAndModule(-3, t.PLATFORM, 'platform.module', pattern:getTypeAndModule(0, -3))
            assertGridTypeAndModule(-2, t.TRACK, 'track.module', pattern:getTypeAndModule(0, -2))
            assertGridTypeAndModule(-1, t.TRACK, 'track.module', pattern:getTypeAndModule(0, -1))
            assertGridTypeAndModule(0, t.PLATFORM, 'platform.module', pattern:getTypeAndModule(0, 0))
            assertGridTypeAndModule(1, t.TRACK, 'track.module', pattern:getTypeAndModule(0, 1))
            assertGridTypeAndModule(2, t.TRACK, 'track.module', pattern:getTypeAndModule(0, 2))
            assertGridTypeAndModule(3, t.PLATFORM, 'platform.module', pattern:getTypeAndModule(0, 3))
        end)

        it ('it returns grid types and modules (scenario 2)', function ()
            local pattern = TallPlatformStationPattern:new{trackModule = 'track.module', platformModule = 'platform.module', trackCount = 5, horizontalSize = 1}

            assertGridTypeAndModule(-4, t.TRACK, 'track.module', pattern:getTypeAndModule(0, -4))
            assertGridTypeAndModule(-3, t.PLATFORM, 'platform.module', pattern:getTypeAndModule(0, -3))
            assertGridTypeAndModule(-2, t.TRACK, 'track.module', pattern:getTypeAndModule(0, -2))
            assertGridTypeAndModule(-1, t.TRACK, 'track.module', pattern:getTypeAndModule(0, -1))
            assertGridTypeAndModule(0, t.PLATFORM, 'platform.module', pattern:getTypeAndModule(0, 0))
            assertGridTypeAndModule(1, t.TRACK, 'track.module', pattern:getTypeAndModule(0, 1))
            assertGridTypeAndModule(2, t.TRACK, 'track.module', pattern:getTypeAndModule(0, 2))
            assertGridTypeAndModule(3, t.PLATFORM, 'platform.module', pattern:getTypeAndModule(0, 3))
        end)
    end)

    describe('getVerticalRange', function ()
        it ('returns vertical range (scenario 1)', function ()
            local pattern = TallPlatformStationPattern:new{trackModule = 'track.module', platformModule = 'platform.module', trackCount = 4, horizontalSize = 1}
            local startY, endY = pattern:getVerticalRange()

            assert.are.equal(-3, startY)
            assert.are.equal(3, endY)
        end)

        it ('returns vertical range (scenario 2)', function ()
            local pattern = TallPlatformStationPattern:new{trackModule = 'track.module', platformModule = 'platform.module', trackCount = 5, horizontalSize = 1}
            local startY, endY = pattern:getVerticalRange()

            assert.are.equal(-4, startY)
            assert.are.equal(3, endY)
        end)
    end)

    describe('getHorizontalRange', function ()
        it('returns horizontal range (odd)', function ()
            local pattern = TallPlatformStationPattern:new{trackModule = 'track.module', platformModule = 'platform.module', trackCount = 4, horizontalSize = 3}
            local startX, endX = pattern:getHorizontalRange(0)

            assert.are.equal(-1, startX)
            assert.are.equal(1, endX)
        end)

        it('returns horizontal range (even)', function ()
            local pattern = TallPlatformStationPattern:new{trackModule = 'track.module', platformModule = 'platform.module', trackCount = 4, horizontalSize = 4}
            local startX, endX = pattern:getHorizontalRange(0)

            assert.are.equal(-2, startX)
            assert.are.equal(1, endX)
        end)
    end)
end)