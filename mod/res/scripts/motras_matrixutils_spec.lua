local MatrixUtils = require('motras_matrixutils')

local function matrixIsVeryNearTo(expected, passed)
    for i = 1, 16 do
        if expected[i] < passed[i] - 0.000001 or expected[i] > passed[i] + 0.0000001 then
            print('Matrices are not equal at position ' .. i .. '. Expected: ' .. expected[i] .. ' Passed in: ' .. passed[i])
            return false
        end
    end
    return true
end

describe('MatrixUtils', function ()
    describe('rotateAroundZAxis', function ()
        local matrix = {
            1, 0, 0, 0,
            0, 1, 0, 0,
            0, 0, 1, 0,
            1, 2, 4, 1,
        }

        local rotated_matrix = MatrixUtils.rotateAroundZAxis(90, matrix)        

        assert.are_not.equal(matrix, rotated_matrix)
        assert.is_true(matrixIsVeryNearTo({
            0, -1, 0, 0,
            1, 0, 0, 0,
            0, 0, 1, 0,
            1, 2, 4, 1,
        }, rotated_matrix))
    end)
end)