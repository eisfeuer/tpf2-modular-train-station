local Station = require("motras_station")
local Slot = require("motras_slot")
local t = require("motras_Types")

local TrackSlotPlacement = require("motras_track_slot_placement")

describe('TrackSlotPlacement', function ()
    
    describe('isPassingPlacementRule', function ()
        it('fails if all neighbors are empty', function ()
            local station = Station:new{}

            local trackSlotPlacement = TrackSlotPlacement:new{grid = station.grid, gridX = 0, gridY = 1}
            assert.is_false(trackSlotPlacement:isPassingPlacementRule())            
        end)

        it('passes if grid is empty and position is 0/0', function ()
            local station = Station:new{}

            local trackSlotPlacement = TrackSlotPlacement:new{grid = station.grid, gridX = 0, gridY = 0}
            assert.is_true(trackSlotPlacement:isPassingPlacementRule())
        end)

        it('fails if grid is not empty and position is 0/0', function ()
            local trackSlodId = Slot.makeId({
                type = t.TRACK,
                gridX = 1,
                gridY = 3
            })

            local station  = Station:new{}
            station:initializeAndRegister(trackSlodId)
            local trackSlotPlacement = TrackSlotPlacement:new{grid = station.grid, gridX = 0, gridY = 0}

            assert.is_false(trackSlotPlacement:isPassingPlacementRule())
        end)

        it('passes if one neighbor is a track', function ()
            local trackSlodId = Slot.makeId({
                type = t.TRACK,
                gridX = 1,
                gridY = 3
            })

            local station  = Station:new{}
            station:initializeAndRegister(trackSlodId)
            local trackSlotPlacement = TrackSlotPlacement:new{grid = station.grid, gridX = 1, gridY = 2}

            assert.is_true(trackSlotPlacement:isPassingPlacementRule())
        end)

        it('passes if one neighbor is a platform', function ()
            local trackSlodId = Slot.makeId({
                type = t.PLATFORM,
                gridX = 1,
                gridY = 3
            })

            local station  = Station:new{}
            station:initializeAndRegister(trackSlodId)
            local trackSlotPlacement = TrackSlotPlacement:new{grid = station.grid, gridX = 1, gridY = 2}

            assert.is_true(trackSlotPlacement:isPassingPlacementRule())
        end)

        it('passes if one neighbor is a place', function ()
            local trackSlodId = Slot.makeId({
                type = t.PLACE,
                gridX = 1,
                gridY = 3
            })

            local station  = Station:new{}
            station:initializeAndRegister(trackSlodId)
            local trackSlotPlacement = TrackSlotPlacement:new{grid = station.grid, gridX = 1, gridY = 2}

            assert.is_true(trackSlotPlacement:isPassingPlacementRule())
        end)

        it ('passes if track is on position', function ()
            local trackSlodId = Slot.makeId({
                type = t.TRACK,
                gridX = 1,
                gridY = 3
            })

            local station  = Station:new{}
            station:initializeAndRegister(trackSlodId)
            local trackSlotPlacement = TrackSlotPlacement:new{grid = station.grid, gridX = 1, gridY = 3}

            assert.is_true(trackSlotPlacement:isPassingPlacementRule())
        end)

        it ('fails if platform is on position', function ()
            local trackSlodId = Slot.makeId({
                type = t.PLATFORM,
                gridX = 1,
                gridY = 3
            })

            local station  = Station:new{}
            station:initializeAndRegister(trackSlodId)
            local trackSlotPlacement = TrackSlotPlacement:new{grid = station.grid, gridX = 1, gridY = 3}

            assert.is_false(trackSlotPlacement:isPassingPlacementRule())
        end)

        it ('fails if place is on position', function ()
            local trackSlodId = Slot.makeId({
                type = t.PLACE,
                gridX = 1,
                gridY = 3
            })

            local station  = Station:new{}
            station:initializeAndRegister(trackSlodId)
            local trackSlotPlacement = TrackSlotPlacement:new{grid = station.grid, gridX = 1, gridY = 3}

            assert.is_false(trackSlotPlacement:isPassingPlacementRule())
        end)
    end)

    describe('getSlot', function ()
        it('returs slot in transport fever 2 style', function ()
            local station = Station:new{horizontalGridDistance = 40, verticalGridDistance = 10}
            local trackSlotPlacement = TrackSlotPlacement:new{grid = station.grid, gridX = 1, gridY = 2}

            assert.are.same({
                id = Slot.makeId({type = t.TRACK, gridX = 1, gridY = 2}),
                type = 'motras_track',
                transf = {
                    1, 0, 0, 0,
                    0, 1, 0, 0,
                    0, 0, 1, 0,
                    40, 20, 0, 1,
                },
                spacing = Slot.getGridElementSpacing(station.grid)
            }, trackSlotPlacement:getSlot())
        end)

        it('applies custom base height and module prefix', function ()
            local station = Station:new{horizontalGridDistance = 40, verticalGridDistance = 10, baseHeight = 3, modulePrefix = 'my_station'}
            local trackSlotPlacement = TrackSlotPlacement:new{grid = station.grid, gridX = 1, gridY = 2}

            assert.are.same({
                id = Slot.makeId({type = t.TRACK, gridX = 1, gridY = 2}),
                type = 'my_station_track',
                transf = {
                    1, 0, 0, 0,
                    0, 1, 0, 0,
                    0, 0, 1, 0,
                    40, 20, 3, 1,
                },
                spacing = Slot.getGridElementSpacing(station.grid)
            }, trackSlotPlacement:getSlot())
        end)
    end)

end)