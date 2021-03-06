local c = require('motras_constants')
local Transf = require('transf')

local PathUtils = {}

function PathUtils.makePassengerPathModel(from, to, transformation)
    local fromX = from.x or from[1] or 0
    local fromY = from.y or from[2] or 0
    local fromZ = from.z or from[3] or 0

    local toX = to.x or to[1] or 0
    local toY = to.y or to[2] or 0
    local toZ = to.z or to[3] or 0

    local modelTransformation = {
        toX - fromX, 0, 0, 0,
        0, toY - fromY, 0, 0,
        0, 0, toZ - fromZ, 0,
        fromX, fromY, fromZ, 1
    }

    if transformation then
        modelTransformation = Transf.mul(transformation, modelTransformation)
    end

    return {
        id = c.PASSENGER_PATH_MODEL,
        transf = modelTransformation
    }
end

return PathUtils