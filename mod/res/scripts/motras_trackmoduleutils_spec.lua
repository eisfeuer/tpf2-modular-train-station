local Station = require('motras_station')
local Slot = require('motras_slot')
local c = require('motras_constants')
local t = require('motras_types')

local TrackModuleUtils = require('motras_trackmoduleutils')

describe('TrackModuleUtils', function ()
    describe('makeTrack', function ()
        it('creates track edges for track module', function ()
            local posX = 2 * c.DEFAULT_HORIZONTAL_GRID_DISTANCE
            local posY = 3 * c.DEFAULT_VERTICAL_GRID_DISTANCE

            local station = Station:new()

            local track = station:initializeAndRegister(Slot.makeId({type = t.TRACK, gridX = 2, gridY = 3}))
            
            TrackModuleUtils.makeTrack(track, 'high_speed.lua', true, true, true)

            assert.are.equal('high_speed.lua', track:getTrackType())

            assert.is_true(track:hasCatenary())

            assert.are.same({
                { { posX - 18, posY, .0 }, {-2.0, .0, .0 } },
                { { posX - 20, posY, .0 }, {-2.0, .0, .0 } },

                { { posX - 2, posY, .0 }, {-16.0, .0, .0 } },
                { { posX - 18, posY,  .0 }, {-16.0, .0, .0 } },

                { { posX + 0, posY,  .0 }, {-2.0, .0, .0 } },
                { { posX - 2, posY,  .0 }, {-2.0, .0, .0 } },

                { { posX + 0, posY,  .0 }, {2.0, .0, .0 } },
                { { posX + 2, posY,  .0 }, {2.0, .0, .0 } },

                { { posX + 2, posY,  .0 }, {16.0, .0, .0 } },
                { { posX + 18, posY, .0 }, {16.0, .0, .0 } },

                { { posX + 18, posY, .0 }, {2.0, .0, .0 } },
                { { posX + 20, posY, .0 }, {2.0, .0, .0 } }
            }, track:getEdges())

            assert.are.same({
                1, 11
            }, track:getSnapNodes())

            assert.are.same({
                2, 0, 8, 10
            }, track:getStopNodes())
        end)
    end)
end)