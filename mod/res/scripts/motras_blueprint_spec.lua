local Blueprint = require('motras_blueprint')
local Slot = require('motras_slot')

local TallPlatformStationPattern = require('motras_blueprint_patterns.tall_platform_station')
local WidePlatformStationPattern = require('motras_blueprint_patterns.wide_platform_station')

local c = require('motras_constants')
local t = require('motras_types')

describe('Blueprint', function ()
    describe('createStation', function ()
        
        it('creates station with small platforms (prefer side)', function ()
            local blueprint1 = Blueprint:new{}:createStation(
                TallPlatformStationPattern:new{platformModule = 'platform.module', trackModule = 'track.module', trackCount = 1, horizontalSize = 1}
            );

            assert.are.same({
                [Slot.makeId({type = t.TRACK, gridX = 0, gridY = -1})] = 'track.module',
                [Slot.makeId({type = t.PLATFORM, gridX = 0, gridY = 0})] = 'platform.module'
            }, blueprint1:toTpf2Template())

            local blueprint2 = Blueprint:new{}:createStation(
                TallPlatformStationPattern:new{platformModule = 'platform.module', trackModule = 'track.module', trackCount = 2, horizontalSize = 3}
            )

            assert.are.same({
                [Slot.makeId({type = t.PLATFORM, gridX = -1, gridY = -2})] = 'platform.module',
                [Slot.makeId({type = t.PLATFORM, gridX = 0, gridY = -2})] = 'platform.module',
                [Slot.makeId({type = t.PLATFORM, gridX = 1, gridY = -2})] = 'platform.module',
                [Slot.makeId({type = t.TRACK, gridX = -1, gridY = -1})] = 'track.module',
                [Slot.makeId({type = t.TRACK, gridX = 0, gridY = -1})] = 'track.module',
                [Slot.makeId({type = t.TRACK, gridX = 1, gridY = -1})] = 'track.module',
                [Slot.makeId({type = t.TRACK, gridX = -1, gridY = 0})] = 'track.module',
                [Slot.makeId({type = t.TRACK, gridX = 0, gridY = 0})] = 'track.module',
                [Slot.makeId({type = t.TRACK, gridX = 1, gridY = 0})] = 'track.module',
                [Slot.makeId({type = t.PLATFORM, gridX = -1, gridY = 1})] = 'platform.module',
                [Slot.makeId({type = t.PLATFORM, gridX = 0, gridY = 1})] = 'platform.module',
                [Slot.makeId({type = t.PLATFORM, gridX = 1, gridY = 1})] = 'platform.module',
            }, blueprint2:toTpf2Template())
        end)

        it('creates station with large platforms (prefer side)', function ()
            local blueprint1 = Blueprint:new{}:createStation(
                WidePlatformStationPattern:new{platformModule = 'platform.module', trackModule = 'track.module', trackCount = 1, horizontalSize = 1} 
            )

            assert.are.same({
                [Slot.makeId({type = t.TRACK, gridX = 0, gridY = -1})] = 'track.module',
                [Slot.makeId({type = t.PLATFORM, gridX = 0, gridY = 0})] = 'platform.module'
            }, blueprint1:toTpf2Template())

            local blueprint2 = Blueprint:new{}:createStation(
                WidePlatformStationPattern:new{platformModule = 'platform.module', trackModule = 'track.module', trackCount = 2, horizontalSize = 3}
            )

            assert.are.same({
                [Slot.makeId({type = t.PLATFORM, gridX = -1, gridY = -2})] = 'platform.module',
                [Slot.makeId({type = t.PLATFORM, gridX = 0, gridY = -2})] = 'platform.module',
                [Slot.makeId({type = t.PLATFORM, gridX = 1, gridY = -2})] = 'platform.module',
                [Slot.makeId({type = t.TRACK, gridX = -1, gridY = -1})] = 'track.module',
                [Slot.makeId({type = t.TRACK, gridX = 0, gridY = -1})] = 'track.module',
                [Slot.makeId({type = t.TRACK, gridX = 1, gridY = -1})] = 'track.module',
                [Slot.makeId({type = t.TRACK, gridX = -1, gridY = 0})] = 'track.module',
                [Slot.makeId({type = t.TRACK, gridX = 0, gridY = 0})] = 'track.module',
                [Slot.makeId({type = t.TRACK, gridX = 1, gridY = 0})] = 'track.module',
                [Slot.makeId({type = t.PLATFORM, gridX = -1, gridY = 1})] = 'platform.module',
                [Slot.makeId({type = t.PLATFORM, gridX = 0, gridY = 1})] = 'platform.module',
                [Slot.makeId({type = t.PLATFORM, gridX = 1, gridY = 1})] = 'platform.module',
            }, blueprint2:toTpf2Template())
        end)
    end)

    describe('addModuleToTemplate', function ()
        it('adds module to template', function ()
            local blueprint = Blueprint:new{}
            blueprint:addModuleToTemplate(Slot.makeId({type = t.TRACK, gridX = 1, gridY = 1}), 'track.module')
            
            assert.are.same({
                [Slot.makeId({type = t.TRACK, gridX = 1, gridY = 1})] = 'track.module'
            }, blueprint:toTpf2Template())
        end)
    end)

    describe('decorateEachPlatform', function ()
        it ('decorates all platform modules', function ()
            local blueprint1 = Blueprint:new{}:decorateEachPlatform(function (platformBlueprint)
                platformBlueprint:addAsset(t.DECORATION, 'bench.module', 7)
            end):createStation(
                TallPlatformStationPattern:new{platformModule = 'platform.module', trackModule = 'track.module', trackCount = 1, horizontalSize = 1}
            );

            assert.are.same({
                [Slot.makeId({type = t.TRACK, gridX = 0, gridY = -1})] = 'track.module',
                [Slot.makeId({type = t.PLATFORM, gridX = 0, gridY = 0})] = 'platform.module',
                [Slot.makeId({type = t.DECORATION, gridX = 0, gridY = 0, assetId = 7})] = 'bench.module'
            }, blueprint1:toTpf2Template())
        end)
    end)

    describe('decorateEachTrack', function ()
        it ('decorates all track modules', function ()
            local blueprint1 = Blueprint:new{}:decorateEachTrack(function (trackBlueprint)
                trackBlueprint:addAsset(t.DECORATION, 'sign.module', 7)
            end):createStation(
                TallPlatformStationPattern:new{platformModule = 'platform.module', trackModule = 'track.module', trackCount = 1, horizontalSize = 1}
            );

            assert.are.same({
                [Slot.makeId({type = t.TRACK, gridX = 0, gridY = -1})] = 'track.module',
                [Slot.makeId({type = t.PLATFORM, gridX = 0, gridY = 0})] = 'platform.module',
                [Slot.makeId({type = t.DECORATION, gridX = 0, gridY = -1, assetId = 7})] = 'sign.module'
            }, blueprint1:toTpf2Template())
        end)
    end)
end)