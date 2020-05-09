local Blueprint = require('motras_blueprint')
local Slot = require('motras_slot')

local c = require('motras_constants')
local t = require('motras_types')

describe('Blueprint', function ()
    describe('createStation', function ()
        
        it('creates station with small platforms (prefer side)', function ()
            local blueprint1 = Blueprint:new{}:createStation({
                platformCount = 1,
                platformSegmentCount = 1,
                preferIslandPlatforms = false,
                platformWidth = 1,
                trackModule = 'track.module',
                platformModule = 'platform.module'
            });

            assert.are.same({
                [Slot.makeId({type = t.TRACK, gridX = 0, gridY = 0})] = 'track.module',
                [Slot.makeId({type = t.PLATFORM, gridX = 0, gridY = 1})] = 'platform.module'
            }, blueprint1:toTpf2Template())

            local blueprint2 = Blueprint:new{}:createStation({
                platformCount = 2,
                platformSegmentCount = 3,
                preferIslandPlatforms = false,
                platformWidth = 1,
                trackModule = 'track.module',
                platformModule = 'platform.module'
            })

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
            local blueprint1 = Blueprint:new{}:createStation({
                platformCount = 1,
                platformSegmentCount = 1,
                preferIslandPlatforms = true,
                platformWidth = 1,
                trackModule = 'track.module',
                platformModule = 'platform.module'
            })

            assert.are.same({
                [Slot.makeId({type = t.TRACK, gridX = 0, gridY = 0})] = 'track.module',
                [Slot.makeId({type = t.PLATFORM, gridX = 0, gridY = 1})] = 'platform.module'
            }, blueprint1:toTpf2Template())

            local blueprint2 = Blueprint:new{}:createStation({
                platformCount = 2,
                platformSegmentCount = 3,
                preferIslandPlatforms = true,
                platformWidth = 1,
                trackModule = 'track.module',
                platformModule = 'platform.module'
            })

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
            local blueprint1 = Blueprint:new{}:createStation({
                platformCount = 1,
                platformSegmentCount = 1,
                preferIslandPlatforms = false,
                platformWidth = 2,
                trackModule = 'track.module',
                platformModule = 'platform.module'
            })

            assert.are.same({
                [Slot.makeId({type = t.TRACK, gridX = 0, gridY = 0})] = 'track.module',
                [Slot.makeId({type = t.PLATFORM, gridX = 0, gridY = 1})] = 'platform.module'
            }, blueprint1:toTpf2Template())

            local blueprint2 = Blueprint:new{}:createStation({
                platformCount = 2,
                platformSegmentCount = 3,
                preferIslandPlatforms = false,
                platformWidth = 2,
                trackModule = 'track.module',
                platformModule = 'platform.module'
            })

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
            local blueprint1 = Blueprint:new{}:createStation({
                platformCount = 1,
                platformSegmentCount = 1,
                preferIslandPlatforms = true,
                platformWidth = 2,
                trackModule = 'track.module',
                platformModule = 'platform.module'
            })

            assert.are.same({
                [Slot.makeId({type = t.TRACK, gridX = 0, gridY = 0})] = 'track.module',
                [Slot.makeId({type = t.PLATFORM, gridX = 0, gridY = 1})] = 'platform.module'
            }, blueprint1:toTpf2Template())

            local blueprint2 = Blueprint:new{}:createStation({
                platformCount = 2,
                platformSegmentCount = 3,
                preferIslandPlatforms = true,
                platformWidth = 2,
                trackModule = 'track.module',
                platformModule = 'platform.module'
            })

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

    describe('addModuleToTemplate', function ()
        it('adds module to template', function ()
            local blueprint = Blueprint:new{}
            blueprint:addModuleToTemplate(Slot.makeId({type = t.TRACK, gridX = 1, gridY = 1}), 'track.module')
            
            assert.are.same({
                [Slot.makeId({type = t.TRACK, gridX = 1, gridY = 1})] = 'track.module'
            }, blueprint:toTpf2Template())
        end)
    end)

    describe('addRowOfModulesToTemplate', function ()
        it ('adds a row of modules (e.g. platform or tracks) to template (odd)', function ()
            local blueprint = Blueprint:new{}

            blueprint:addRowOfModulesToTemplate(t.TRACK, 'track.module', 3, -1)
            assert.are.same({
                [Slot.makeId({type = t.TRACK, gridX = -1, gridY = -1})] = 'track.module',
                [Slot.makeId({type = t.TRACK, gridX = 0, gridY = -1})] = 'track.module',
                [Slot.makeId({type = t.TRACK, gridX = 1, gridY = -1})] = 'track.module',
            }, blueprint:toTpf2Template())
        end)

        it ('adds a row of modules (e.g. platform or tracks) to template (even)', function ()
            local blueprint = Blueprint:new{}

            blueprint:addRowOfModulesToTemplate(t.TRACK, 'track.module', 4, 2)
            assert.are.same({
                [Slot.makeId({type = t.TRACK, gridX = -1, gridY = 2})] = 'track.module',
                [Slot.makeId({type = t.TRACK, gridX = 0, gridY = 2})] = 'track.module',
                [Slot.makeId({type = t.TRACK, gridX = 1, gridY = 2})] = 'track.module',
                [Slot.makeId({type = t.TRACK, gridX = 2, gridY = 2})] = 'track.module',
            }, blueprint:toTpf2Template())
        end)
    end)

    describe('decorateEachPlatform', function ()
        it ('decorates all platform modules', function ()
            local blueprint1 = Blueprint:new{}:decorateEachPlatform(function (platformBlueprint)
                platformBlueprint:addAssetToTemplate(t.DECORATION, 'bench.module', 7)
            end):createStation({
                platformCount = 1,
                platformSegmentCount = 1,
                preferIslandPlatforms = false,
                platformWidth = 1,
                trackModule = 'track.module',
                platformModule = 'platform.module'
            });

            assert.are.same({
                [Slot.makeId({type = t.TRACK, gridX = 0, gridY = 0})] = 'track.module',
                [Slot.makeId({type = t.PLATFORM, gridX = 0, gridY = 1})] = 'platform.module',
                [Slot.makeId({type = t.DECORATION, gridX = 0, gridY = 1, assetId = 7})] = 'bench.module'
            }, blueprint1:toTpf2Template())
        end)
    end)

    describe('decorateEachTrack', function ()
        it ('decorates all track modules', function ()
            local blueprint1 = Blueprint:new{}:decorateEachTrack(function (trackBlueprint)
                trackBlueprint:addAssetToTemplate(t.DECORATION, 'sign.module', 7)
            end):createStation({
                platformCount = 1,
                platformSegmentCount = 1,
                preferIslandPlatforms = false,
                platformWidth = 1,
                trackModule = 'track.module',
                platformModule = 'platform.module'
            });

            assert.are.same({
                [Slot.makeId({type = t.TRACK, gridX = 0, gridY = 0})] = 'track.module',
                [Slot.makeId({type = t.PLATFORM, gridX = 0, gridY = 1})] = 'platform.module',
                [Slot.makeId({type = t.DECORATION, gridX = 0, gridY = 0, assetId = 7})] = 'sign.module'
            }, blueprint1:toTpf2Template())
        end)
    end)
end)