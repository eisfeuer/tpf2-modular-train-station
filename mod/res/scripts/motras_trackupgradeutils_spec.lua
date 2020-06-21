local Slot = require('motras_slot')
local t = require('motras_types')

local TrackUpgradeUtils = require("motras_trackupgradeutils")

describe('TrackUpgradeUtils', function ()
    describe('upgradeFromParams', function ()
        it('electrifies track', function ()
            local params = {
                catenary = 0,
                catenaryToggle = 1,
                modules = {
                    [Slot.makeId({type = t.TRACK, gridX = 0, gridY = 0})] = {
                        metadata = {
                            motras_electrified = false,
                            motras_highspeed = false,
                            motras_toggleElectrificationTo = "station/rail/modules/motras_track_train_normal_catenary.module",
                            motras_toggleHighspeedTo = "station/rail/modules/motras_track_train_highspeed.module"
                        },
                        name = "station/rail/modules/motras_track_train_normal.module",
                        variant = 0
                    },
                    [Slot.makeId({type = t.TRACK, gridX = 1, gridY = 0})] = {
                        metadata = {
                            motras_electrified = false,
                            motras_highspeed = false,
                            motras_toggleElectrificationTo = "station/rail/modules/motras_track_train_normal_catenary.module",
                            motras_toggleHighspeedTo = "station/rail/modules/motras_track_train_highspeed.module"
                        },
                        name = "station/rail/modules/motras_track_train_normal.module",
                        variant = 0
                    },
                    [Slot.makeId({type = t.TRACK, gridX = 0, gridY = -1})] = {
                        metadata = {
                            motras_electrified = false,
                            motras_highspeed = false,
                            motras_toggleElectrificationTo = "station/rail/modules/motras_track_train_normal_catenary.module",
                            motras_toggleHighspeedTo = "station/rail/modules/motras_track_train_highspeed.module"
                        },
                        name = "station/rail/modules/motras_track_train_normal.module",
                        variant = 0
                    },
                    [Slot.makeId({type = t.TRACK, gridX = 1, gridY = -1})] = {
                        metadata = {
                            motras_electrified = false,
                            motras_highspeed = false,
                            motras_toggleElectrificationTo = "station/rail/modules/motras_track_train_normal_catenary.module",
                            motras_toggleHighspeedTo = "station/rail/modules/motras_track_train_highspeed.module"
                        },
                        name = "station/rail/modules/motras_track_train_normal.module",
                        variant = 0
                    },
                    [Slot.makeId({type = t.PLATFORM, gridX = 0, gridY = -2})] = {
                        metadata = {},
                        name = "station/rail/modules/motras_platform_270.module",
                        variant = 0
                    },
                    [Slot.makeId({type = t.PLATFORM, gridX = 1, gridY = -2})] = {
                        metadata = {},
                        name = "station/rail/modules/motras_platform_270.module",
                        variant = 0
                    },
                    [Slot.makeId({type = t.PLATFORM, gridX = 0, gridY = 1})] = {
                        metadata = {},
                        name = "station/rail/modules/motras_platform_270.module",
                        variant = 0
                    },
                    [Slot.makeId({type = t.PLATFORM, gridX = 1, gridY = 1})] = {
                        metadata = {},
                        name = "station/rail/modules/motras_platform_270.module",
                        variant = 0
                    }
                },
                motras_length = 1,
                motras_platform_height = 0,
                motras_platform_width = 0,
                motras_prefer_island_platforms = 0,
                motras_tracks = 1,
                oneWay = 0,
                paramX = 0,
                paramY = 0,
                seed = 1,
                slotId = Slot.makeId({type = t.TRACK, gridX = 1, gridY = 0}),
                trackCatenary = 2,
                trackType = 0,
                year = 2000
            }

            assert.are.same({
                { Slot.makeId({type = t.TRACK, gridX = 0, gridY = 0}), "station/rail/modules/motras_track_train_normal_catenary.module"},
                { Slot.makeId({type = t.TRACK, gridX = 1, gridY = 0}), "station/rail/modules/motras_track_train_normal_catenary.module"},
            }, TrackUpgradeUtils.upgradeFromParams(params))
        end)
    end)

    describe('filterAffectedModules', function ()
        it('filters out modules which are affected by track upgrade', function ()
            local modules = {
                [Slot.makeId({type = t.TRACK, gridX = 0, gridY = 0})] = {
                    metadata = {
                        motras_electrified = false,
                        motras_highspeed = false,
                        motras_toggleElectrificationTo = "station/rail/modules/motras_track_train_normal_catenary.module",
                        motras_toggleHighspeedTo = "station/rail/modules/motras_track_train_highspeed.module"
                    },
                    name = "station/rail/modules/motras_track_train_normal.module",
                    variant = 0
                },
                [Slot.makeId({type = t.TRACK, gridX = 1, gridY = 0})] = {
                    metadata = {
                        motras_electrified = false,
                        motras_highspeed = false,
                        motras_toggleElectrificationTo = "station/rail/modules/motras_track_train_normal_catenary.module",
                        motras_toggleHighspeedTo = "station/rail/modules/motras_track_train_highspeed.module"
                    },
                    name = "station/rail/modules/motras_track_train_normal.module",
                    variant = 0
                },
                [Slot.makeId({type = t.TRACK, gridX = 0, gridY = -1})] = {
                    metadata = {
                        motras_electrified = false,
                        motras_highspeed = false,
                        motras_toggleElectrificationTo = "station/rail/modules/motras_track_train_normal_catenary.module",
                        motras_toggleHighspeedTo = "station/rail/modules/motras_track_train_highspeed.module"
                    },
                    name = "station/rail/modules/motras_track_train_normal.module",
                    variant = 0
                },
                [Slot.makeId({type = t.TRACK, gridX = 1, gridY = -1})] = {
                    metadata = {
                        motras_electrified = false,
                        motras_highspeed = false,
                        motras_toggleElectrificationTo = "station/rail/modules/motras_track_train_normal_catenary.module",
                        motras_toggleHighspeedTo = "station/rail/modules/motras_track_train_highspeed.module"
                    },
                    name = "station/rail/modules/motras_track_train_normal.module",
                    variant = 0
                },
                [Slot.makeId({type = t.PLATFORM, gridX = 0, gridY = -2})] = {
                    metadata = {},
                    name = "station/rail/modules/motras_platform_270.module",
                    variant = 0
                },
                [Slot.makeId({type = t.PLATFORM, gridX = 1, gridY = -2})] = {
                    metadata = {},
                    name = "station/rail/modules/motras_platform_270.module",
                    variant = 0
                },
                [Slot.makeId({type = t.PLATFORM, gridX = 0, gridY = 1})] = {
                    metadata = {},
                    name = "station/rail/modules/motras_platform_270.module",
                    variant = 0
                },
                [Slot.makeId({type = t.PLATFORM, gridX = 1, gridY = 1})] = {
                    metadata = {},
                    name = "station/rail/modules/motras_platform_270.module",
                    variant = 0
                }
            }

            assert.are.same({
                [Slot.makeId({type = t.TRACK, gridX = 0, gridY = -1})] = {
                    metadata = {
                        motras_electrified = false,
                        motras_highspeed = false,
                        motras_toggleElectrificationTo = "station/rail/modules/motras_track_train_normal_catenary.module",
                        motras_toggleHighspeedTo = "station/rail/modules/motras_track_train_highspeed.module"
                    },
                    name = "station/rail/modules/motras_track_train_normal.module",
                    variant = 0
                },
                [Slot.makeId({type = t.TRACK, gridX = 1, gridY = -1})] = {
                    metadata = {
                        motras_electrified = false,
                        motras_highspeed = false,
                        motras_toggleElectrificationTo = "station/rail/modules/motras_track_train_normal_catenary.module",
                        motras_toggleHighspeedTo = "station/rail/modules/motras_track_train_highspeed.module"
                    },
                    name = "station/rail/modules/motras_track_train_normal.module",
                    variant = 0
                },
            }, TrackUpgradeUtils.filterAffectedModules(modules, Slot.makeId({type = t.TRACK, gridX = 0, gridY = -1})))
        end)

        it('filters out modules which are affected by track upgrade (interrupted by platform)', function ()
            local modules = {
                [Slot.makeId({type = t.TRACK, gridX = 0, gridY = 0})] = {
                    metadata = {
                        motras_electrified = false,
                        motras_highspeed = false,
                        motras_toggleElectrificationTo = "station/rail/modules/motras_track_train_normal_catenary.module",
                        motras_toggleHighspeedTo = "station/rail/modules/motras_track_train_highspeed.module"
                    },
                    name = "station/rail/modules/motras_track_train_normal.module",
                    variant = 0
                },
                [Slot.makeId({type = t.TRACK, gridX = 1, gridY = 0})] = {
                    metadata = {
                        motras_electrified = false,
                        motras_highspeed = false,
                        motras_toggleElectrificationTo = "station/rail/modules/motras_track_train_normal_catenary.module",
                        motras_toggleHighspeedTo = "station/rail/modules/motras_track_train_highspeed.module"
                    },
                    name = "station/rail/modules/motras_track_train_normal.module",
                    variant = 0
                },
                [Slot.makeId({type = t.PLATFORM, gridX = 2, gridY = 0})] = {
                    metadata = {},
                    name = "station/rail/modules/motras_platform_270.module",
                    variant = 0
                },
                [Slot.makeId({type = t.TRACK, gridX = 3, gridY = 0})] = {
                    metadata = {
                        motras_electrified = false,
                        motras_highspeed = false,
                        motras_toggleElectrificationTo = "station/rail/modules/motras_track_train_normal_catenary.module",
                        motras_toggleHighspeedTo = "station/rail/modules/motras_track_train_highspeed.module"
                    },
                    name = "station/rail/modules/motras_track_train_normal.module",
                    variant = 0
                },
            }

            assert.are.same({
                [Slot.makeId({type = t.TRACK, gridX = 0, gridY = 0})] = {
                    metadata = {
                        motras_electrified = false,
                        motras_highspeed = false,
                        motras_toggleElectrificationTo = "station/rail/modules/motras_track_train_normal_catenary.module",
                        motras_toggleHighspeedTo = "station/rail/modules/motras_track_train_highspeed.module"
                    },
                    name = "station/rail/modules/motras_track_train_normal.module",
                    variant = 0
                },
                [Slot.makeId({type = t.TRACK, gridX = 1, gridY = 0})] = {
                    metadata = {
                        motras_electrified = false,
                        motras_highspeed = false,
                        motras_toggleElectrificationTo = "station/rail/modules/motras_track_train_normal_catenary.module",
                        motras_toggleHighspeedTo = "station/rail/modules/motras_track_train_highspeed.module"
                    },
                    name = "station/rail/modules/motras_track_train_normal.module",
                    variant = 0
                },
            }, TrackUpgradeUtils.filterAffectedModules(modules, Slot.makeId({type = t.TRACK, gridX = 1, gridY = 0})))
        end)
    end)

    describe('toggleElectrification', function ()
        it ('toggles electrification', function ()
            local modules = {
                [Slot.makeId({type = t.TRACK, gridX = 0, gridY = -1})] = {
                    metadata = {
                        motras_electrified = false,
                        motras_highspeed = false,
                        motras_toggleElectrificationTo = "station/rail/modules/motras_track_train_normal_catenary.module",
                        motras_toggleHighspeedTo = "station/rail/modules/motras_track_train_highspeed.module"
                    },
                    name = "station/rail/modules/motras_track_train_normal.module",
                    variant = 0
                },
                [Slot.makeId({type = t.TRACK, gridX = 1, gridY = -1})] = {
                    metadata = {
                        motras_electrified = false,
                        motras_highspeed = false,
                        motras_toggleElectrificationTo = "station/rail/modules/motras_track_train_normal_catenary.module",
                        motras_toggleHighspeedTo = "station/rail/modules/motras_track_train_highspeed.module"
                    },
                    name = "station/rail/modules/motras_track_train_normal.module",
                    variant = 0
                },
                [Slot.makeId({type = t.TRACK, gridX = 2, gridY = -1})] = {
                    metadata = {
                        motras_highspeed = false,
                        motras_toggleElectrificationTo = "station/rail/modules/motras_track_train_normal_catenary.module",
                        motras_toggleHighspeedTo = "station/rail/modules/motras_track_train_highspeed.module"
                    },
                    name = "station/rail/modules/motras_track_train_normal.module",
                    variant = 0
                },
                [Slot.makeId({type = t.TRACK, gridX = 3, gridY = -1})] = {
                    metadata = {
                        motras_electrified = false,
                        motras_highspeed = false,
                        motras_toggleHighspeedTo = "station/rail/modules/motras_track_train_highspeed.module"
                    },
                    name = "station/rail/modules/motras_track_train_normal.module",
                    variant = 0
                },
            }

            assert.are.same({
                {Slot.makeId({type = t.TRACK, gridX = 1, gridY = -1}), "station/rail/modules/motras_track_train_normal_catenary.module"},
                {Slot.makeId({type = t.TRACK, gridX = 0, gridY = -1}), "station/rail/modules/motras_track_train_normal_catenary.module"}
            }, TrackUpgradeUtils.toggleElectrification(modules, true))
        end)
    end)

    describe('toggleHighspeed', function ()
        it ('toggles highspeed', function ()
            local modules = {
                [Slot.makeId({type = t.TRACK, gridX = 0, gridY = -1})] = {
                    metadata = {
                        motras_electrified = false,
                        motras_highspeed = false,
                        motras_toggleElectrificationTo = "station/rail/modules/motras_track_train_normal_catenary.module",
                        motras_toggleHighspeedTo = "station/rail/modules/motras_track_train_highspeed.module"
                    },
                    name = "station/rail/modules/motras_track_train_normal.module",
                    variant = 0
                },
                [Slot.makeId({type = t.TRACK, gridX = 1, gridY = -1})] = {
                    metadata = {
                        motras_electrified = false,
                        motras_highspeed = false,
                        motras_toggleElectrificationTo = "station/rail/modules/motras_track_train_normal_catenary.module",
                        motras_toggleHighspeedTo = "station/rail/modules/motras_track_train_highspeed.module"
                    },
                    name = "station/rail/modules/motras_track_train_normal.module",
                    variant = 0
                },
                [Slot.makeId({type = t.TRACK, gridX = 2, gridY = -1})] = {
                    metadata = {
                        motras_electrified = false,
                        motras_highspeed = true,
                        motras_toggleElectrificationTo = "station/rail/modules/motras_track_train_normal_catenary.module",
                        motras_toggleHighspeedTo = "station/rail/modules/motras_track_train_highspeed.module"
                    },
                    name = "station/rail/modules/motras_track_train_normal.module",
                    variant = 0
                },
                [Slot.makeId({type = t.TRACK, gridX = 3, gridY = -1})] = {
                    metadata = {
                        motras_electrified = false,
                        motras_highspeed = false,
                        motras_toggleElectrificationTo = "station/rail/modules/motras_track_train_normal_catenary.module",
                    },
                    name = "station/rail/modules/motras_track_train_normal.module",
                    variant = 0
                },
            }

            assert.are.same({
                {Slot.makeId({type = t.TRACK, gridX = 1, gridY = -1}), "station/rail/modules/motras_track_train_highspeed.module"},
                {Slot.makeId({type = t.TRACK, gridX = 0, gridY = -1}), "station/rail/modules/motras_track_train_highspeed.module"},
            }, TrackUpgradeUtils.toggleHighspeed(modules, true))
        end)
    end)
end)