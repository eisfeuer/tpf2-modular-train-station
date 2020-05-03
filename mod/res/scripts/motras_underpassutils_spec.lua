local Station = require('motras_station')
local Slot = require('motras_slot')
local PathUtils = require('motras_pathutils')
local t = require('motras_types')
local c = require('motras_constants')

local UnderpassUtils = require('motras_underpassutils')

local function assertAreSameModels(expected, passedIn)
    assert.are.equal(#expected, #passedIn)
    for i, model in ipairs(expected) do
        assert.are.equal(model.id, passedIn[i].id)
        for j, value in ipairs(model.transf) do
            local passedInValue = passedIn[i].transf[j]
            assert.is_true(passedInValue > value - 0.00001 and passedInValue < value + 0.00001, j .. ' Expected: ' .. value .. ' Passed In: ' .. passedInValue)
        end
    end
end

describe('UnderpassUtils', function ()
    describe('addUnderpassLaneToModels', function ()
        it ('adds no model when no platform is above', function ()
            local station = Station:new{}
            station:initializeAndRegister(Slot.makeId({type = t.PLATFORM, gridX = 0, gridY = 0}))
            station:initializeAndRegister(Slot.makeId({type = t.TRACK, gridX = 0, gridY = 14}))
            local stairs = station:initializeAndRegister(Slot.makeId({type = t.UNDERPASS, gridX = 0, gridY = 0, assetId = 25}))
            
            local models = {}
            UnderpassUtils.addUnderpassLaneToModels(stairs, models)

            assert.are.same({}, models)
        end)

        it ('adds connection at the platform mid (two small stairs)', function ()
            local station = Station:new{}
            station:initializeAndRegister(Slot.makeId({type = t.PLATFORM, gridX = 0, gridY = 0}))
            station:register(Slot.makeId({type = t.PLATFORM, gridX = 0, gridY = 0}), {platformHeight = 0.76})
            station:initializeAndRegister(Slot.makeId({type = t.PLATFORM, gridX = 0, gridY = 3}))
            station:register(Slot.makeId({type = t.PLATFORM, gridX = 0, gridY = 3}), {platformHeight = 0.96})
            station:initializeAndRegister(Slot.makeId({type = t.UNDERPASS, gridX = 0, gridY = 3, assetId = 28}))

            local stairs = station:initializeAndRegister(Slot.makeId({type = t.UNDERPASS, gridX = 0, gridY = 0, assetId = 25}))

            local models = {}
            UnderpassUtils.addUnderpassLaneToModels(stairs, models)
            assertAreSameModels({
                PathUtils.makePassengerPathModel({0, 0, 0.76 + c.DEFAULT_BASE_TRACK_HEIGHT}, {0, 15, 0.96 + c.DEFAULT_BASE_TRACK_HEIGHT})
            }, models)
        end)

        it ('adds connection at the platform mid (from large to small)', function ()
            local station = Station:new{}
            station:initializeAndRegister(Slot.makeId({type = t.PLATFORM, gridX = 0, gridY = 0}))
            station:register(Slot.makeId({type = t.PLATFORM, gridX = 0, gridY = 0}), {platformHeight = 0.76})
            station:initializeAndRegister(Slot.makeId({type = t.PLATFORM, gridX = 0, gridY = 3}))
            station:register(Slot.makeId({type = t.PLATFORM, gridX = 0, gridY = 3}), {platformHeight = 0.96})
            station:initializeAndRegister(Slot.makeId({type = t.UNDERPASS, gridX = 0, gridY = 3, assetId = 25}))

            local stairs = station:initializeAndRegister(Slot.makeId({type = t.UNDERPASS, gridX = 0, gridY = 0, assetId = 29}))

            local models = {}
            UnderpassUtils.addUnderpassLaneToModels(stairs, models)
            assertAreSameModels({
                PathUtils.makePassengerPathModel({0, -2.5, 0.76 + c.DEFAULT_BASE_TRACK_HEIGHT}, {0, 15.0, 0.96 + c.DEFAULT_BASE_TRACK_HEIGHT})
            }, models)
        end)

        it ('adds connection at the platform mid (from small to large)', function ()
            local station = Station:new{}
            station:initializeAndRegister(Slot.makeId({type = t.PLATFORM, gridX = 0, gridY = 0}))
            station:register(Slot.makeId({type = t.PLATFORM, gridX = 0, gridY = 0}), {platformHeight = 0.76})
            station:initializeAndRegister(Slot.makeId({type = t.PLATFORM, gridX = 0, gridY = 3}))
            station:register(Slot.makeId({type = t.PLATFORM, gridX = 0, gridY = 3}), {platformHeight = 0.96})
            station:initializeAndRegister(Slot.makeId({type = t.UNDERPASS, gridX = 0, gridY = 3, assetId = 29}))

            local stairs = station:initializeAndRegister(Slot.makeId({type = t.UNDERPASS, gridX = 0, gridY = 0, assetId = 25}))

            local models = {}
            UnderpassUtils.addUnderpassLaneToModels(stairs, models)
            assertAreSameModels({
                PathUtils.makePassengerPathModel({0, 0, 0.76 + c.DEFAULT_BASE_TRACK_HEIGHT}, {0, 12.5, 0.96 + c.DEFAULT_BASE_TRACK_HEIGHT})
            }, models)
        end)

        it ('adds connection at the platform mid (from large to large)', function ()
            local station = Station:new{}
            station:initializeAndRegister(Slot.makeId({type = t.PLATFORM, gridX = 0, gridY = 0}))
            station:register(Slot.makeId({type = t.PLATFORM, gridX = 0, gridY = 0}), {platformHeight = 0.76})
            station:initializeAndRegister(Slot.makeId({type = t.PLATFORM, gridX = 0, gridY = 3}))
            station:register(Slot.makeId({type = t.PLATFORM, gridX = 0, gridY = 3}), {platformHeight = 0.96})
            station:initializeAndRegister(Slot.makeId({type = t.UNDERPASS, gridX = 0, gridY = 3, assetId = 29}))

            local stairs = station:initializeAndRegister(Slot.makeId({type = t.UNDERPASS, gridX = 0, gridY = 0, assetId = 29}))

            local models = {}
            UnderpassUtils.addUnderpassLaneToModels(stairs, models)
            assertAreSameModels({
                PathUtils.makePassengerPathModel({0, -2.5, 0.76 + c.DEFAULT_BASE_TRACK_HEIGHT}, {0, 12.5, 0.96 + c.DEFAULT_BASE_TRACK_HEIGHT})
            }, models)
        end)

        it ('adds connection at the left platform ending', function ()
            local station = Station:new{}
            station:initializeAndRegister(Slot.makeId({type = t.PLATFORM, gridX = 0, gridY = 0}))
            station:register(Slot.makeId({type = t.PLATFORM, gridX = 0, gridY = 0}), {platformHeight = 0.76})
            station:initializeAndRegister(Slot.makeId({type = t.PLATFORM, gridX = -1, gridY = 3}))
            station:register(Slot.makeId({type = t.PLATFORM, gridX = -1, gridY = 3}), {platformHeight = 0.96})
            station:initializeAndRegister(Slot.makeId({type = t.UNDERPASS, gridX = -1, gridY = 3, assetId = 27}))

            local stairs = station:initializeAndRegister(Slot.makeId({type = t.UNDERPASS, gridX = 0, gridY = 0, assetId = 26}))

            local models = {}
            UnderpassUtils.addUnderpassLaneToModels(stairs, models)
            assertAreSameModels({
                PathUtils.makePassengerPathModel({-20, 0, 0.76 + c.DEFAULT_BASE_TRACK_HEIGHT}, {-20, 15, 0.96 + c.DEFAULT_BASE_TRACK_HEIGHT})
            }, models)
        end)

        it ('adds connection at the left platform ending', function ()
            local station = Station:new{}
            station:initializeAndRegister(Slot.makeId({type = t.PLATFORM, gridX = 0, gridY = 0}))
            station:register(Slot.makeId({type = t.PLATFORM, gridX = 0, gridY = 0}), {platformHeight = 0.76})
            station:initializeAndRegister(Slot.makeId({type = t.PLATFORM, gridX = 1, gridY = 3}))
            station:register(Slot.makeId({type = t.PLATFORM, gridX = 1, gridY = 3}), {platformHeight = 0.96})
            station:initializeAndRegister(Slot.makeId({type = t.UNDERPASS, gridX = 1, gridY = 3, assetId = 26}))

            local stairs = station:initializeAndRegister(Slot.makeId({type = t.UNDERPASS, gridX = 0, gridY = 0, assetId = 27}))

            local models = {}
            UnderpassUtils.addUnderpassLaneToModels(stairs, models)
            assertAreSameModels({
                PathUtils.makePassengerPathModel({20, 0, 0.76 + c.DEFAULT_BASE_TRACK_HEIGHT}, {20, 15, 0.96 + c.DEFAULT_BASE_TRACK_HEIGHT})
            }, models)
        end)
    end)
end)