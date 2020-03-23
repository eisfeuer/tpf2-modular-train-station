local Slot = require("motras_slot")
local t = require("motras_types")

local Station = require("motras_station")

describe("Station", function ()
    describe("initializeAndRegister", function ()
        
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