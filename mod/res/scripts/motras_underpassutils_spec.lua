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

    describe('addUnderpassLaneGridToModels', function ()
        it ('adds underpass lane grid to models', function ()
            local station = Station:new{}
            local track1 = station:initializeAndRegister(Slot.makeId{type = t.TRACK, gridX = 0, gridY = 0})
            local track2 = station:initializeAndRegister(Slot.makeId{type = t.TRACK, gridX = 1, gridY = 1})

            local models = {}
            UnderpassUtils.addUnderpassLaneGridToModels(station.grid, models)

            assert.are.same({{
                id = c.DEFAULT_UNDERPASS_GRID_START_MODEL,
                transf = {
                    1, 0, 0, 0,
                    0, 1, 0, 0,
                    0, 0, 1, 0,
                    track1:getAbsoluteX(), track1:getAbsoluteY(), station.grid:getUnderpassZ(), 1
                }
            }, {
                id = c.DEFAULT_UNDERPASS_GRID_REPEAT_MODEL,
                transf = {
                    1, 0, 0, 0,
                    0, 1, 0, 0,
                    0, 0, 1, 0,
                    track1:getAbsoluteX(), track1:getAbsoluteY(), station.grid:getUnderpassZ(), 1
                }
            }, {
                id = c.DEFAULT_UNDERPASS_GRID_REPEAT_MODEL,
                transf = {
                    1, 0, 0, 0,
                    0, 1, 0, 0,
                    0, 0, 1, 0,
                    track2:getAbsoluteX(), track1:getAbsoluteY(), station.grid:getUnderpassZ(), 1
                }
            }, {
                id = c.DEFAULT_UNDERPASS_GRID_START_MODEL,
                transf = {
                    1, 0, 0, 0,
                    0, 1, 0, 0,
                    0, 0, 1, 0,
                    track1:getAbsoluteX(), track2:getAbsoluteY(), station.grid:getUnderpassZ(), 1
                }
            }, {
                id = c.DEFAULT_UNDERPASS_GRID_REPEAT_MODEL,
                transf = {
                    1, 0, 0, 0,
                    0, 1, 0, 0,
                    0, 0, 1, 0,
                    track1:getAbsoluteX(), track2:getAbsoluteY(), station.grid:getUnderpassZ(), 1
                }
            }, {
                id = c.DEFAULT_UNDERPASS_GRID_REPEAT_MODEL,
                transf = {
                    1, 0, 0, 0,
                    0, 1, 0, 0,
                    0, 0, 1, 0,
                    track2:getAbsoluteX(), track2:getAbsoluteY(), station.grid:getUnderpassZ(), 1
                }
            }}, models)
        end)
    end)
end)