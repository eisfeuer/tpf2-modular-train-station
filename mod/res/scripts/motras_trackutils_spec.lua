local Station = require('motras_station')
local Slot = require('motras_slot')
local t = require('motras_types')
local TrackUtils = require('motras_trackutils')

describe('TrackUtils', function ()
    
    describe('addTrackIdsToAllTracksOnGrid', function ()
        it ('adds track ids', function ()
            local station = Station:new{}
            local displayMapper = {
                getDisplayedId = function (self, trackId, platformId)
                    return trackId + (platformId or 0)
                end,

                getDisplayedDestination = function(self, trackId, platformId)
                    return 'target' .. trackId
                end
            }

            local track1 = station:initializeAndRegister(Slot.makeId({type = t.TRACK, gridX = 0, gridY = 0}))
            local track2 = station:initializeAndRegister(Slot.makeId({type = t.TRACK, gridX = 0, gridY = 1}))
            local track3 = station:initializeAndRegister(Slot.makeId({type = t.TRACK, gridX = 1, gridY = 2}))
            local track4 = station:initializeAndRegister(Slot.makeId({type = t.TRACK, gridX = 0, gridY = 3}))
            local track5 = station:initializeAndRegister(Slot.makeId({type = t.TRACK, gridX = 0, gridY = 5}))
            local track6 = station:initializeAndRegister(Slot.makeId({type = t.TRACK, gridX = 0, gridY = 6}))
            local track7 = station:initializeAndRegister(Slot.makeId({type = t.TRACK, gridX = 0, gridY = 7}))
            local track8 = station:initializeAndRegister(Slot.makeId({type = t.TRACK, gridX = 0, gridY = 10}))
            local track9 = station:initializeAndRegister(Slot.makeId({type = t.TRACK, gridX = 1, gridY = 11}))

            station:initializeAndRegister(Slot.makeId({type = t.PLATFORM, gridX = 0, gridY = 2}))
            station:initializeAndRegister(Slot.makeId({type = t.PLATFORM, gridX = 0, gridY = 4}))
            station:initializeAndRegister(Slot.makeId({type = t.PLATFORM, gridX = 0, gridY = 8}))
            station:initializeAndRegister(Slot.makeId({type = t.PLATFORM, gridX = 0, gridY = 9}))
            station:initializeAndRegister(Slot.makeId({type = t.PLATFORM, gridX = 0, gridY = 11}))
            station:initializeAndRegister(Slot.makeId({type = t.PLATFORM, gridX = 0, gridY = 12}))

            TrackUtils.addTrackIdsToAllTracksOnGrid(station.grid, displayMapper)

            assert.are.equal(9, track1:getTrackId())
            assert.is_nil(track1:getPlatformId())
            assert.are.equal(9, track1:getDisplayedId())
            assert.are.equal('target9', track1:getDisplayedDestination())

            assert.are.equal(8, track2:getTrackId())
            assert.are.equal(6, track2:getPlatformId())
            assert.are.equal(14, track2:getDisplayedId())
            assert.are.equal('target8', track2:getDisplayedDestination())

            assert.are.equal(7, track3:getTrackId())
            assert.is_nil(track3:getPlatformId())
            assert.are.equal(7, track3:getDisplayedId())
            assert.are.equal('target7', track3:getDisplayedDestination())

            assert.are.equal(6, track4:getTrackId())
            assert.are.equal(5, track4:getPlatformId())
            assert.are.equal(11, track4:getDisplayedId())
            assert.are.equal('target6', track4:getDisplayedDestination())

            assert.are.equal(5, track5:getTrackId())
            assert.are.equal(4, track5:getPlatformId())
            assert.are.equal(9, track5:getDisplayedId())
            assert.are.equal('target5', track5:getDisplayedDestination())

            assert.are.equal(4, track6:getTrackId())
            assert.is_nil(track6:getPlatformId())
            assert.are.equal(4, track6:getDisplayedId())
            assert.are.equal('target4', track6:getDisplayedDestination())

            assert.are.equal(3, track7:getTrackId())
            assert.are.equal(3, track7:getPlatformId())
            assert.are.equal(6, track7:getDisplayedId())
            assert.are.equal('target3', track7:getDisplayedDestination())

            assert.are.equal(2, track8:getTrackId())
            assert.are.equal(2, track8:getPlatformId())
            assert.are.equal(4, track8:getDisplayedId())
            assert.are.equal('target2', track8:getDisplayedDestination())

            assert.are.equal(1, track9:getTrackId())
            assert.are.equal(1, track9:getPlatformId())
            assert.are.equal(2, track9:getDisplayedId())
            assert.are.equal('target1', track9:getDisplayedDestination())
        end)
        
    end)

    describe('addEdgesToEdgeList', function ()
        it('adds edges to a single edge list', function ()
            local edgeList = {
                edges = {
                    { { 18, 2.0, 0.0 }, {-2.0, 0.0, 0.0 } },
                    { { 20, 2.0, 0.0 }, {-2.0, 0.0, 0.0 } },

                    { { 2, 2.0, 0.0 }, {-16.0, 0.0, 0.0 } },
                    { { 18, 2.0,  0.0 }, {-16.0, 0.0, 0.0 } },
                },
                snapNodes = {0},
                tag2nodes = {}
            }

            TrackUtils = TrackUtils.addEdgesToEdgeList(edgeList, {
                { {10.0, 4.0, 0.0}, {-20.0, 0.0, 0.0} },
                { {-10.0, 4.0, 0.0}, {-20.0, 0.0, 0.0} },

                { {10.0, 6.0, 0.0}, {-20.0, 0.0, 0.0} },
                { {-10.0, 6.0, 0.0}, {-20.0, 0.0, 0.0} },
            }, {0, 2}, '__1234', {0, 1, 2, 3})

            assert.are.same({
                edges = {
                    { { 18, 2.0, 0.0 }, {-2.0, 0.0, 0.0 } },
                    { { 20, 2.0, 0.0 }, {-2.0, 0.0, 0.0 } },

                    { { 2, 2.0, 0.0 }, {-16.0, 0.0, 0.0 } },
                    { { 18, 2.0,  0.0 }, {-16.0, 0.0, 0.0 } },

                    { {10.0, 4.0, 0.0}, {-20.0, 0.0, 0.0} },
                    { {-10.0, 4.0, 0.0}, {-20.0, 0.0, 0.0} },

                    { {10.0, 6.0, 0.0}, {-20.0, 0.0, 0.0} },
                    { {-10.0, 6.0, 0.0}, {-20.0, 0.0, 0.0} },
                },
                snapNodes = {0, 4, 6},
                tag2nodes = {
                    __1234 = {4, 5, 6, 7}
                }
            }, edgeList)
        end)
    end)
end)