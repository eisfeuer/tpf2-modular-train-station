local Station = require('motras_station')
local Slot = require('motras_slot')
local c = require('motras_constants')
local t = require('motras_types')
local TestUtils = require('motras_testutils')

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

    describe('assignTrackToModule', function ()
        it('generates track module', function ()
            TestUtils.mockTranslations()

            local track = {
                yearFrom = 1900,
                yearTo = 1988,
                cost = 150,
                name = 'Third Rails',
                desc = 'Side Contact',
                icon = 'third_rails_side_contact.tga',
                speedLimit = 120,
            }
            local trackModule = {
                availability = {},
                description = {},
                order = {},
                category = {},
                updateScript = {},
                getModelsScript = {},
                cost = {},
                metadata = {
                    
                }
            }

            TrackModuleUtils.assignTrackToModule(trackModule, track, 'third_rails_side_contact.lua', true, 2)

            assert.are.same({
                fileName = 'motras_generic_track_third_rails_side_contact_catenary.module',
                availability = {
                    yearFrom = 1900,
                    yearTo = 1988,
                },
                description = {
                    name = "Third Rails with_catenary",
                    description = "Side Contact",
                    icon = "third_rails_side_contact_module_catenary.tga"
                },
                type = "motras_track",
                order = {
                    value = 100021
                },
                category = {
                    categories = { "tracks", }
                },
                cost = {
                    price = 36000
                },
                updateScript = {
                    fileName = "construction/station/rail/generic_modules/motras_track.updateFn",
                    params = {
                        trackType = 'third_rails_side_contact.lua',
                        catenary = true
                    }
                },
                getModelsScript = {
                    fileName = "construction/station/rail/generic_modules/motras_track.getModelsFn",
                    params = {
						trackType = 'third_rails_side_contact.lua',
						catenary = true
					}
                },
                metadata = {
                    motras_electrified = true,
                    motras_toggleElectrificationTo = "motras_generic_track_third_rails_side_contact.module",
                    motras_speedLimit = 120
                }
            }, trackModule)
        end)
    end)
end)