local Stairway = require('motras_stairway')
local PathUtils = require('motras_pathutils')

local function assertNearBy(expected, passedIn)
    assert.is_true(passedIn > expected - 0.00001, passedIn .. ' is not equal to ' .. expected)
    assert.is_true(passedIn < expected + 0.00001, passedIn .. ' is not equal to ' .. expected)
end

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

describe('Stairway', function ()
    describe('getStepCount', function ()
        it('calculates amount of stairs (scenario 1)', function ()
            local stairway = Stairway:new{
                height = 1.7
            }
            assert.are.equal(10, stairway:getStepCount())
        end)

        it('calculates amount of stairs (scenario 1)', function ()
            local stairway = Stairway:new{
                height = 2.0
            }
            assert.are.equal(12, stairway:getStepCount())
        end)
    end)

    describe('getStepHeight', function ()
        it('calculates step height', function ()
            local stairway = Stairway:new{
                height = 2.0
            }
            assertNearBy(0.166666, stairway:getStepHeight())
        end)
    end)

    describe('getWidth', function ()
        it('calculates width', function ()
            local stairway = Stairway:new{
                height = 2.0,
                stepWidth = 0.3
            }

            assertNearBy(3.6, stairway:getWidth())
        end)
    end)

    describe('addStepsToModels', function()
        it('adds stairway to models', function ()
            local models = {}

            local stairway = Stairway:new{
                height = 0.36,
                stepWidth = 0.3,
                stepModel = 'step.mdl'
            }


            local transf = {
                1, 0, 0, 0, 
                0, 1, 0, 0,
                0, 0, 1, 0,
                0, 0, 0, 1
            }

            stairway:addStepsToModels(models, transf)

            assert.are.equal(2, #models)
            assert.are.equal('step.mdl', models[1].id)
            assert.are.equal('step.mdl', models[2].id)

            assertNearBy(0.0, models[1].transf[14])
            assertNearBy(0.36, models[1].transf[15])

            assertNearBy(0.3, models[2].transf[14])
            assertNearBy(0.18, models[2].transf[15])
        end) 

        it('adds stairway to models with tag', function ()
            local models = {}

            local stairway = Stairway:new{
                height = 0.36,
                stepWidth = 0.3,
                stepModel = 'step.mdl'
            }


            local transf = {
                1, 0, 0, 0, 
                0, 1, 0, 0,
                0, 0, 1, 0,
                0, 0, 0, 1
            }

            stairway:addStepsToModels(models, transf, 'katze')

            assert.are.equal(2, #models)
            assert.are.equal('step.mdl', models[1].id)
            assert.are.equal('step.mdl', models[2].id)
            assert.are.equal('katze', models[1].tag)
            assert.are.equal('katze', models[2].tag)

            assertNearBy(0.0, models[1].transf[14])
            assertNearBy(0.36, models[1].transf[15])

            assertNearBy(0.3, models[2].transf[14])
            assertNearBy(0.18, models[2].transf[15])
        end) 
    end)

    describe('addPathToModels', function ()
        it('adds path to model', function ()
            local models = {}

            local stairway = Stairway:new{
                height = 0.36,
                stepWidth = 0.3,
                stepModel = 'step.mdl'
            }

            local transf = {
                1, 0, 0, 0, 
                0, 1, 0, 0,
                0, 0, 1, 0,
                0, 0, 0, 1
            }

            stairway:addPathToModels(models, 1, transf)

            assertAreSameModels({
                PathUtils.makePassengerPathModel({1, 0.3, 0.36}, {1, 0.9, 0.0}, transf)
            }, models)
        end)

        it('adds path model with start and endpoint', function ()
            local models = {}

            local stairway = Stairway:new{
                height = 0.36,
                stepWidth = 0.3,
                stepModel = 'step.mdl'
            }

            local transf = {
                1, 0, 0, 0, 
                0, 1, 0, 0,
                0, 0, 1, 0,
                0, 0, 0, 1
            }

            stairway:addPathToModels(models, 1, transf, -1, 5)

            assertAreSameModels({
                PathUtils.makePassengerPathModel({1, -1, 0.36}, {1, 0.3, 0.36}, transf),
                PathUtils.makePassengerPathModel({1, 0.3, 0.36}, {1, 0.9, 0.0}, transf),
                PathUtils.makePassengerPathModel({1, 0.9, 0.0}, {1, 5, 0.0}, transf)
            }, models)
        end)
    end)
end)