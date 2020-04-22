local Blueprint = require('motras_blueprint')
local Slot = require('motras_slot')

local c = require('motras_constants')
local t = require('motras_types')

describe('Blueprint', function ()
    describe('toTpf2Template', function ()
        
        it('creates station with small platforms (prefer side)', function ()
            local blueprint1 = Blueprint:new{
                platformCount = 1,
                platformSegmentCount = 1,
                preferIslandPlatforms = false,
                platformWidth = 1,
                trackModule = 'track.module',
                platformModule = 'platform.module'
            }

            assert.are.same({
                [Slot.makeId({type = t.TRACK, gridX = 0, gridY = 0})] = 'track.module',
                [Slot.makeId({type = t.PLATFORM, gridX = 0, gridY = 1})] = 'platform.module'
            }, blueprint1:toTpf2Template())

            local blueprint2 = Blueprint:new{
                platformCount = 2,
                platformSegmentCount = 3,
                preferIslandPlatforms = false,
                platformWidth = 1,
                trackModule = 'track.module',
                platformModule = 'platform.module'
            }

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

        it('creates station with small platforms (prefer island)', function ()
            local blueprint1 = Blueprint:new{
                platformCount = 1,
                platformSegmentCount = 1,
                preferIslandPlatforms = true,
                platformWidth = 1,
                trackModule = 'track.module',
                platformModule = 'platform.module'
            }

            assert.are.same({
                [Slot.makeId({type = t.TRACK, gridX = 0, gridY = 0})] = 'track.module',
                [Slot.makeId({type = t.PLATFORM, gridX = 0, gridY = 1})] = 'platform.module'
            }, blueprint1:toTpf2Template())

            local blueprint2 = Blueprint:new{
                platformCount = 2,
                platformSegmentCount = 3,
                preferIslandPlatforms = true,
                platformWidth = 1,
                trackModule = 'track.module',
                platformModule = 'platform.module'
            }

            assert.are.same({
                [Slot.makeId({type = t.TRACK, gridX = -1, gridY = -1})] = 'track.module',
                [Slot.makeId({type = t.TRACK, gridX = 0, gridY = -1})] = 'track.module',
                [Slot.makeId({type = t.TRACK, gridX = 1, gridY = -1})] = 'track.module',
                [Slot.makeId({type = t.PLATFORM, gridX = -1, gridY = 0})] = 'platform.module',
                [Slot.makeId({type = t.PLATFORM, gridX = 0, gridY = 0})] = 'platform.module',
                [Slot.makeId({type = t.PLATFORM, gridX = 1, gridY = 0})] = 'platform.module',
                [Slot.makeId({type = t.TRACK, gridX = -1, gridY = 1})] = 'track.module',
                [Slot.makeId({type = t.TRACK, gridX = 0, gridY = 1})] = 'track.module',
                [Slot.makeId({type = t.TRACK, gridX = 1, gridY = 1})] = 'track.module',
            }, blueprint2:toTpf2Template())
        end)

        it('creates station with large platforms (prefer side)', function ()
            local blueprint1 = Blueprint:new{
                platformCount = 1,
                platformSegmentCount = 1,
                preferIslandPlatforms = false,
                platformWidth = 2,
                trackModule = 'track.module',
                platformModule = 'platform.module'
            }

            assert.are.same({
                [Slot.makeId({type = t.TRACK, gridX = 0, gridY = 0})] = 'track.module',
                [Slot.makeId({type = t.PLATFORM, gridX = 0, gridY = 1})] = 'platform.module'
            }, blueprint1:toTpf2Template())

            local blueprint2 = Blueprint:new{
                platformCount = 2,
                platformSegmentCount = 3,
                preferIslandPlatforms = false,
                platformWidth = 2,
                trackModule = 'track.module',
                platformModule = 'platform.module'
            }

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

        it('creates station with big platforms (prefer island)', function ()
            local blueprint1 = Blueprint:new{
                platformCount = 1,
                platformSegmentCount = 1,
                preferIslandPlatforms = true,
                platformWidth = 2,
                trackModule = 'track.module',
                platformModule = 'platform.module'
            }

            assert.are.same({
                [Slot.makeId({type = t.TRACK, gridX = 0, gridY = 0})] = 'track.module',
                [Slot.makeId({type = t.PLATFORM, gridX = 0, gridY = 1})] = 'platform.module'
            }, blueprint1:toTpf2Template())

            local blueprint2 = Blueprint:new{
                platformCount = 2,
                platformSegmentCount = 3,
                preferIslandPlatforms = true,
                platformWidth = 2,
                trackModule = 'track.module',
                platformModule = 'platform.module'
            }

            -- local station = require('motras_station'):new{}
            -- station:initializeAndRegisterAll(blueprint2:toTpf2Template())
            -- station.grid:debug()

            assert.are.same({
                [Slot.makeId({type = t.TRACK, gridX = -1, gridY = -2})] = 'track.module',
                [Slot.makeId({type = t.TRACK, gridX = 0, gridY = -2})] = 'track.module',
                [Slot.makeId({type = t.TRACK, gridX = 1, gridY = -2})] = 'track.module',
                [Slot.makeId({type = t.PLATFORM, gridX = -1, gridY = -1})] = 'platform.module',
                [Slot.makeId({type = t.PLATFORM, gridX = 0, gridY = -1})] = 'platform.module',
                [Slot.makeId({type = t.PLATFORM, gridX = 1, gridY = -1})] = 'platform.module',
                [Slot.makeId({type = t.PLATFORM, gridX = -1, gridY = 0})] = 'platform.module',
                [Slot.makeId({type = t.PLATFORM, gridX = 0, gridY = 0})] = 'platform.module',
                [Slot.makeId({type = t.PLATFORM, gridX = 1, gridY = 0})] = 'platform.module',
                [Slot.makeId({type = t.TRACK, gridX = -1, gridY = 1})] = 'track.module',
                [Slot.makeId({type = t.TRACK, gridX = 0, gridY = 1})] = 'track.module',
                [Slot.makeId({type = t.TRACK, gridX = 1, gridY = 1})] = 'track.module',
            }, blueprint2:toTpf2Template())
        end)

    end)
end)