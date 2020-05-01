local Box = {}

local function avg(value1, value2)
    return (value1 + value2) / 2
end

local function halfDist(from, to)
    return (to - from) / 2
end

function Box:new(pointNeg, pointPos, o)
    o = o or {}
    o.pointNeg = pointNeg
    o.pointPos = pointPos
    setmetatable(o, self)
    self.__index = self
    return o
end

function Box:getCenterPoint()
    return {
        avg(self.pointNeg[1], self.pointPos[1]),
        avg(self.pointNeg[2], self.pointPos[2]),
        avg(self.pointNeg[3], self.pointPos[3])
    }
end

function Box:getCenterPointAsVec3()
    local centerPoint = self:getCenterPoint()
    return {x = centerPoint[1], y = centerPoint[2], z = centerPoint[3]}
end

function Box:getHalfExtends()
    return {
        halfDist(self.pointNeg[1], self.pointPos[1]),
        halfDist(self.pointNeg[2], self.pointPos[2]),
        halfDist(self.pointNeg[3], self.pointPos[3])
    }
end

function Box:getGroundFace()
    return {
        { self.pointPos[1], self.pointPos[2], 0.0, 1.0 },
        { self.pointPos[1], self.pointNeg[2], 0.0, 1.0 },
        { self.pointNeg[1], self.pointNeg[2], 0.0, 1.0 },
        { self.pointNeg[1], self.pointPos[2], 0.0, 1.0 },
    }
end

return Box