local Slot = require("motras_slot")
local t = require("motras_types")
local c = require("motras_constants")

local Station = require("motras_station")

describe("Station", function ()
    describe("initializeAndRegister", function ()
        
        describe('new', function ()
            it('creates station with default grid distances', function ()
                local station = Station:new{}
                assert.are.equal(c.DEFAULT_HORIZONTAL_GRID_DISTANCE, station.grid:getHorizontalDistance())
                assert.are.equal(c.DEFAULT_VERTICAL_GRID_DISTANCE, station.grid:getVerticalDistance())
            end)

            it('creates station with custom grid distances', function ()
                local station = Station:new{horizontalGridDistance = 40, verticalGridDistance = 10}
                assert.are.equal(40, station.grid:getHorizontalDistance())
                assert.are.equal(10, station.grid:getVerticalDistance())
            end)
        end)

        it("creates track", function ()
            local station = Station:new()

            local slotId = Slot.makeId({
                type = t.TRACK,
                gridX = 2,
                gridY = 5
            })

            local track = station:initializeAndRegister(slotId)

            assert.is_true(track:isTrack())
            assert.are.equal(t.TRACK, track:getType())
            assert.are.equal(2, track:getGridX())
            assert.are.equal(5, track:getGridY())

            assert.are.equal(track, track:getGrid():get(2,5))
        end)

        it("creates platform", function ()
            local station = Station:new()

            local slotId = Slot.makeId({
                type = t.PLATFORM,
                gridX = 2,
                gridY = 5
            })

            local platform = station:initializeAndRegister(slotId)

            assert.is_true(platform:isPlatform())
            assert.are.equal(t.PLATFORM, platform:getType())
            assert.are.equal(2, platform:getGridX())
            assert.are.equal(5, platform:getGridY())

            assert.are.equal(platform, platform:getGrid():get(2,5))
        end)

        it("creates place", function ()
            local station = Station:new()

            local slotId = Slot.makeId({
                type = t.PLACE,
                gridX = 2,
                gridY = 5
            })

            local place = station:initializeAndRegister(slotId)

            assert.is_true(place:isPlace())
            assert.are.equal(t.PLACE, place:getType())
            assert.are.equal(2, place:getGridX())
            assert.are.equal(5, place:getGridY())

            assert.are.equal(place, place:getGrid():get(2,5))
        end)

    end)
end)