local MatrixUtils = {}

function MatrixUtils.rotateAroundZAxis(angleInDegree, matrix)
    local anglleInRadians = angleInDegree * math.pi / 180

    local rotation = {
        math.cos(anglleInRadians), -math.sin(anglleInRadians),
        math.sin(anglleInRadians), math.cos(anglleInRadians)
    }

    return {
        matrix[1] * rotation[1] + matrix[2] * rotation[3], matrix[1] * rotation[2] + matrix[2] * rotation[4], matrix[3], matrix[4],
        matrix[5] * rotation[1] + matrix[6] * rotation[3], matrix[5] * rotation[2] + matrix[6] * rotation[4], matrix[7], matrix[8],
        matrix[9] * rotation[1] + matrix[10] * rotation[3], matrix[9] * rotation[2] + matrix[10] * rotation[4], matrix[11], matrix[12],
        matrix[13], matrix[14], matrix[15], matrix[16]
    }
end

return MatrixUtils