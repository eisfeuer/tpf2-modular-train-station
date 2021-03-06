describe("slot", function ()
    local Station = require('motras_station')
    local TrackSlotPlacement = require('motras_track_slot_placement')
    local natbomb = require('natbomb')
    local t = require('motras_types')

    local Slot = require('motras_slot')

    describe('makeId', function ()

        it('generates module id', function ()
            local id = Slot.makeId({
                type = t.TRACK,
                gridX = 3,
                gridY = 1,
                assetId = 2,
                assetDecorationId = 3
            })

            assert.are.equal(natbomb.implode({7, 7, 6, 4}, {t.TRACK, 3 +  64, 1 + 64, 2, 3}), id)
        end)
    end)

    describe('object', function ()
        local slotId = natbomb.implode({7, 7, 6, 4}, {t.TRACK, 3 +  64, 1 + 64, 2, 3})
        local slot = Slot:new{id = slotId}

        it('has id', function ()
            assert.are.equal(slotId, slot.id)
        end)

        it('has grid type', function ()
            assert.are.equal(t.GRID_TRACK, slot.gridType)
        end)

        it('has type', function ()
            assert.are.equal(t.TRACK, slot.type)
        end)

        it('has grid x position', function ()
            assert.are.equal(3, slot.gridX)
        end)

        it('has grid y position', function ()
            assert.are.equal(1, slot.gridY)
        end)

        it('has asset id', function ()
            assert.are.equal(2, slot.assetId)
        end)

        it('has asset decoration id', function ()
            assert.are.equal(3, slot.assetDecorationId)
        end)
    end)

    describe('gridType', function ()
        it('returns track', function ()
            local slotId = Slot.makeId({type = t.TRACK, gridX = 0, gridY = 0, assetId = 0, assetDecorationId = 0})
            local slot = Slot:new{id = slotId}

            assert.are.equal(t.GRID_TRACK, slot.gridType)
        end)
        it('returns platform', function ()
            local slotId = Slot.makeId({type = t.PLATFORM, gridX = 0, gridY = 0, assetId = 0, assetDecorationId = 0})
            local slot = Slot:new{id = slotId}

            assert.are.equal(t.GRID_PLATFORM, slot.gridType)
        end)
        it('returns place', function ()
            local slotId = Slot.makeId({type = t.PLACE, gridX = 0, gridY = 0, assetId = 0, assetDecorationId = 0})
            local slot = Slot:new{id = slotId}

            assert.are.equal(t.GRID_PLACE, slot.gridType)
        end)
        it('returns asset', function ()
            local slotId = Slot.makeId({type = t.ASSET, gridX = 0, gridY = 0, assetId = 1, assetDecorationId = 0})
            local slot = Slot:new{id = slotId}

            assert.are.equal(t.GRID_ASSET, slot.gridType)
        end)
        it('returns asset decoration', function ()
            local slotId = Slot.makeId({type = t.ASSET_DECORATION, gridX = 0, gridY = 0, assetId = 1, assetDecorationId = 1})
            local slot = Slot:new{id = slotId}

            assert.are.equal(t.GRID_ASSET_DECORATION, slot.gridType)
        end)
    end)

    describe('getModuleData', function ()
        it ('returns empty table when not module data given', function ()
            local slotId = Slot.makeId({type = t.TRACK, gridX = 0, gridY = 0})
            local slot = Slot:new{id = slotId}

            assert.are.same({}, slot:getModuleData())
        end)

        it ('returns module data', function ()
            local moduleData = {name = 'a.module'}

            local slotId = Slot.makeId({type = t.TRACK, gridX = 0, gridY = 0})
            local slot = Slot:new{id = slotId, moduleData = moduleData}
            assert.are.equal(moduleData, slot:getModuleData())
        end)
    end)

    describe('getOptions', function ()
        it ('returns empty array when no module data given', function ()
            local slotId = Slot.makeId({type = t.TRACK, gridX = 0, gridY = 0})
            local slot = Slot:new{id = slotId}

            assert.are.same({}, slot:getOptions())
        end)

        it ('returns options', function ()
            local moduleData = {
                name = 'a.module',
                metadata = {
                    motras = {
                        speed = 120
                    },
                    motras_hasCatenary = true,
                    katze = 'Mauz'
                }
            }

            local slotId = Slot.makeId({type = t.TRACK, gridX = 0, gridY = 0})
            local slot = Slot:new{id = slotId, moduleData = moduleData}
            assert.are.same({
                moduleName = 'a.module',
                speed = 120,
                hasCatenary = true
            }, slot:getOptions())
        end)
    end)

    describe('addGridSlotsToCollection', function ()
        local station = Station:new{horizontalGridDistance = 10, verticalGridDistance = 10}
        station:initializeAndRegister(Slot.makeId({type = t.TRACK, gridX = 0, gridY = 0}))
        station:initializeAndRegister(Slot.makeId({type = t.TRACK, gridX = 1, gridY = 0}))
        station:initializeAndRegister(Slot.makeId({type = t.PLATFORM, gridX = 0, gridY = 1}))
        station:initializeAndRegister(Slot.makeId({type = t.PLACE, gridX = 1, gridY = -2}))

        it('adds tracks slots', function ()
            local slots = {}
            Slot.addGridSlotsToCollection(slots, station.grid, TrackSlotPlacement)

            assert.are.same({
                {
                    id = Slot.makeId({type = t.TRACK, gridX = 1, gridY = -3}),
                    type = 'motras_track',
                    transf = {
                        1, 0, 0, 0,
                        0, 1, 0, 0,
                        0, 0, 1, 0,
                        10, -30, 0, 1,
                    },
                    spacing = Slot.getGridElementSpacing(station.grid)
                }, {
                    id = Slot.makeId({type = t.TRACK, gridX = 0, gridY = -2}),
                    type = 'motras_track',
                    transf = {
                        1, 0, 0, 0,
                        0, 1, 0, 0,
                        0, 0, 1, 0,
                        0, -20, 0, 1,
                    },
                    spacing = Slot.getGridElementSpacing(station.grid)
                }, {
                    id = Slot.makeId({type = t.TRACK, gridX = 2, gridY = -2}),
                    type = 'motras_track',
                    transf = {
                        1, 0, 0, 0,
                        0, 1, 0, 0,
                        0, 0, 1, 0,
                        20, -20, 0, 1,
                    },
                    spacing = Slot.getGridElementSpacing(station.grid)
                }, {
                    id = Slot.makeId({type = t.TRACK, gridX = 0, gridY = -1}),
                    type = 'motras_track',
                    transf = {
                        1, 0, 0, 0,
                        0, 1, 0, 0,
                        0, 0, 1, 0,
                        0, -10, 0, 1,
                    },
                    spacing = Slot.getGridElementSpacing(station.grid)
                }, {
                    id = Slot.makeId({type = t.TRACK, gridX = 1, gridY = -1}),
                    type = 'motras_track',
                    transf = {
                        1, 0, 0, 0,
                        0, 1, 0, 0,
                        0, 0, 1, 0,
                        10, -10, 0, 1,
                    },
                    spacing = Slot.getGridElementSpacing(station.grid)
                }, {
                    id = Slot.makeId({type = t.TRACK, gridX = -1, gridY = 0}),
                    type = 'motras_track',
                    transf = {
                        1, 0, 0, 0,
                        0, 1, 0, 0,
                        0, 0, 1, 0,
                        -10, 0, 0, 1,
                    },
                    spacing = Slot.getGridElementSpacing(station.grid)
                }, {
                    id = Slot.makeId({type = t.TRACK, gridX = 0, gridY = 0}),
                    type = 'motras_track',
                    transf = {
                        1, 0, 0, 0,
                        0, 1, 0, 0,
                        0, 0, 1, 0,
                        0, 0, 0, 1,
                    },
                    spacing = Slot.getGridElementSpacing(station.grid)
                }, {
                    id = Slot.makeId({type = t.TRACK, gridX = 1, gridY = 0}),
                    type = 'motras_track',
                    transf = {
                        1, 0, 0, 0,
                        0, 1, 0, 0,
                        0, 0, 1, 0,
                        10, 0, 0, 1,
                    },
                    spacing = Slot.getGridElementSpacing(station.grid)
                }, {
                    id = Slot.makeId({type = t.TRACK, gridX = 2, gridY = 0}),
                    type = 'motras_track',
                    transf = {
                        1, 0, 0, 0,
                        0, 1, 0, 0,
                        0, 0, 1, 0,
                        20, 0, 0, 1,
                    },
                    spacing = Slot.getGridElementSpacing(station.grid)
                }, {
                    id = Slot.makeId({type = t.TRACK, gridX = -1, gridY = 1}),
                    type = 'motras_track',
                    transf = {
                        1, 0, 0, 0,
                        0, 1, 0, 0,
                        0, 0, 1, 0,
                        -10, 10, 0, 1,
                    },
                    spacing = Slot.getGridElementSpacing(station.grid)
                }, {
                    id = Slot.makeId({type = t.TRACK, gridX = 1, gridY = 1}),
                    type = 'motras_track',
                    transf = {
                        1, 0, 0, 0,
                        0, 1, 0, 0,
                        0, 0, 1, 0,
                        10, 10, 0, 1,
                    },
                    spacing = Slot.getGridElementSpacing(station.grid)
                }, {
                    id = Slot.makeId({type = t.TRACK, gridX = 0, gridY = 2}),
                    type = 'motras_track',
                    transf = {
                        1, 0, 0, 0,
                        0, 1, 0, 0,
                        0, 0, 1, 0,
                        0, 20, 0, 1,
                    },
                    spacing = Slot.getGridElementSpacing(station.grid)
                }
            }, slots)
        end)
    end)

    describe('getGridElementSpacing', function ()
        it ('returns grid element spacing', function ()
            local station = Station:new{horizontalGridDistance = 40, verticalGridDistance = 10}
            assert.are.same({19.99, 19.99, 4.99, 4.99}, Slot.getGridElementSpacing(station.grid))
        end)
    end)

    describe('getGridTypeFromSlotType', function ()
        assert.are.equal(t.GRID_TRACK, Slot.getGridTypeFromSlotType(t.TRACK))
        assert.are.equal(t.GRID_PLATFORM, Slot.getGridTypeFromSlotType(t.PLATFORM))
    end)
end)