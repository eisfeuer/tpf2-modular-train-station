local c = require('motras_constants')

local PathUtils = require('motras_pathutils')

describe('PathUtils', function ()
    describe('makePassengerPathModel', function ()
        it ('creates passenger path between two points', function ()
            assert.are.same({
                id = c.PASSENGER_PATH_MODEL,
                transf = {
                    -3, 0, 0, 0,
                    0, -3, 0, 0,
                    0, 0, 7, 0,
                    2, 5, -4, 1
                }
            }, PathUtils.makePassengerPathModel({x = 2, y = 5, z = -4}, {x = -1, y = 2, z = 3}))

            assert.are.same({
                id = c.PASSENGER_PATH_MODEL,
                transf = {
                    -3, 0, 0, 0,
                    0, -3, 0, 0,
                    0, 0, 7, 0,
                    2, 5, -4, 1
                }
            }, PathUtils.makePassengerPathModel({2, 5, -4}, {-1, 2, 3}))
        end)

        it ('creates passenger path between two points (with transformation)', function ()
            local  transformation = {
                1, 0, 0, 0,
                0, 1, 0, 0,
                0, 0, 1, 0,
                0, 2, 0, 1,
            }

            assert.are.same({
                id = c.PASSENGER_PATH_MODEL,
                transf = {
                    -3, 0, 0, 0,
                    0, -3, 0, 0,
                    0, 0, 7, 0,
                    2, 7, -4, 1
                }
            }, PathUtils.makePassengerPathModel({x = 2, y = 5, z = -4}, {x = -1, y = 2, z = 3}, transformation))
        end)
    end)
end)