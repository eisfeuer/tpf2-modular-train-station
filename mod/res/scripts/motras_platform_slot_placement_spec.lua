local Station = require("motras_station")
local Slot = require("motras_slot")
local t = require("motras_Types")

local PlatformSlotPlacement = require("motras_platform_slot_placement")

describe('PlatformSlotPlacement', function ()
    
    describe('isPassingPlacementRule', function ()
        it('fails if all neighbors are empty', function ()
            local station = Station:new{}

            local platformSlotPlacement = PlatformSlotPlacement:new{grid = station.grid, gridX = 0, gridY = 1}
            assert.is_false(platformSlotPlacement:isPassingPlacementRule())            
        end)

        it('passes if grid is empty and position is 0/0', function ()
            local station = Station:new{}

            local platformSlotPlacement = PlatformSlotPlacement:new{grid = station.grid, gridX = 0, gridY = 0}
            assert.is_true(platformSlotPlacement:isPassingPlacementRule())
        end)

        it('fails if grid is not empty and position is 0/0', function ()
            local platformSlodId = Slot.makeId({
                type = t.PLATFORM,
                gridX = 1,
                gridY = 3
            })

            local station  = Station:new{}
            station:initializeAndRegister(platformSlodId)
            local platformSlotPlacement = PlatformSlotPlacement:new{grid = station.grid, gridX = 0, gridY = 0}

            assert.is_false(platformSlotPlacement:isPassingPlacementRule())
        end)

        it('passes if one neighbor is a platform', function ()
            local platformSlodId = Slot.makeId({
                type = t.PLATFORM,
                gridX = 1,
                gridY = 3
            })

            local station  = Station:new{}
            station:initializeAndRegister(platformSlodId)
            local platformSlotPlacement = PlatformSlotPlacement:new{grid = station.grid, gridX = 1, gridY = 2}

            assert.is_true(platformSlotPlacement:isPassingPlacementRule())
        end)

        it('passes if one neighbor is a platform', function ()
            local platformSlodId = Slot.makeId({
                type = t.PLATFORM,
                gridX = 1,
                gridY = 3
            })

            local station  = Station:new{}
            station:initializeAndRegister(platformSlodId)
            local platformSlotPlacement = PlatformSlotPlacement:new{grid = station.grid, gridX = 1, gridY = 2}

            assert.is_true(platformSlotPlacement:isPassingPlacementRule())
        end)

        it('passes if one neighbor is a place', function ()
            local platformSlodId = Slot.makeId({
                type = t.PLACE,
                gridX = 1,
                gridY = 3
            })

            local station  = Station:new{}
            station:initializeAndRegister(platformSlodId)
            local platformSlotPlacement = PlatformSlotPlacement:new{grid = station.grid, gridX = 1, gridY = 2}

            assert.is_true(platformSlotPlacement:isPassingPlacementRule())
        end)

        it ('passes if platform is on position', function ()
            local platformSlodId = Slot.makeId({
                type = t.PLATFORM,
                gridX = 1,
                gridY = 3
            })

            local station  = Station:new{}
            station:initializeAndRegister(platformSlodId)
            local platformSlotPlacement = PlatformSlotPlacement:new{grid = station.grid, gridX = 1, gridY = 3}

            assert.is_true(platformSlotPlacement:isPassingPlacementRule())
        end)

        it ('fails if track is on position', function ()
            local platformSlodId = Slot.makeId({
                type = t.TRACK,
                gridX = 1,
                gridY = 3
            })

            local station  = Station:new{}
            station:initializeAndRegister(platformSlodId)
            local platformSlotPlacement = PlatformSlotPlacement:new{grid = station.grid, gridX = 1, gridY = 3}

            assert.is_false(platformSlotPlacement:isPassingPlacementRule())
        end)

        it ('fails if place is on position', function ()
            local platformSlodId = Slot.makeId({
                type = t.PLACE,
                gridX = 1,
                gridY = 3
            })

            local station  = Station:new{}
            station:initializeAndRegister(platformSlodId)
            local platformSlotPlacement = PlatformSlotPlacement:new{grid = station.grid, gridX = 1, gridY = 3}

            assert.is_false(platformSlotPlacement:isPassingPlacementRule())
        end)
    end)

    describe('getSlot', function ()
        it('returs slot in transport fever 2 style', function ()
            local station = Station:new{horizontalGridDistance = 40, verticalGridDistance = 10}
            local platformSlotPlacement = PlatformSlotPlacement:new{grid = station.grid, gridX = 1, gridY = 2}

            assert.are.same({
                id = Slot.makeId({type = t.PLATFORM, gridX = 1, gridY = 2}),
                type = 'motras_platform',
                transf = {
                    1, 0, 0, 0,
                    0, 1, 0, 0,
                    0, 0, 1, 0,
                    40, 20, 0, 1,
                },
                spacing = Slot.getGridElementSpacing(station.grid)
            }, platformSlotPlacement:getSlot())
        end)

        it('applies custom base height and module prefix', function ()
            local station = Station:new{horizontalGridDistance = 40, verticalGridDistance = 10, baseHeight = 3, modulePrefix = 'my_station'}
            local platformSlotPlacement = PlatformSlotPlacement:new{grid = station.grid, gridX = 1, gridY = 2}

            assert.are.same({
                id = Slot.makeId({type = t.PLATFORM, gridX = 1, gridY = 2}),
                type = 'my_station_platform',
                transf = {
                    1, 0, 0, 0,
                    0, 1, 0, 0,
                    0, 0, 1, 0,
                    40, 20, 3, 1,
                },
                spacing = Slot.getGridElementSpacing(station.grid)
            }, platformSlotPlacement:getSlot())
        end)
    end)

end)