local Transf = require('transf')
local PathUtils = require('motras_pathutils')
local ModelUtils = require('motras_modelutils')

local Stairway = {}

function Stairway:new(o)
    o = o or {}
    setmetatable(o, self)
    self.__index = self
    return o
end

function Stairway:getStepCount()
    return math.floor(self.height / 0.17 + 0.5)
end

function Stairway:getStepHeight()
    return self.height / self:getStepCount()
end

function Stairway:getWidth()
    return self:getStepCount() * self.stepWidth
end

function Stairway:getHeight()
    return self.getHeight()
end

function Stairway:addStepsToModels(models, transformation, tag)
    local stepHeight = self:getStepHeight()

    for i = 0, self:getStepCount() - 1 do
        table.insert(
            models,
            ModelUtils.makeTaggedModel(
                self.stepModel,
                Transf.mul(transformation, Transf.transl({x = 0, y = i * self.stepWidth, z = self.height - i * stepHeight})),
                tag
            )
        )
    end
end

function Stairway:addPathToModels(models, xPos, transformation, startY, endY)
    if startY then
        table.insert(models, PathUtils.makePassengerPathModel({xPos, startY, self.height}, {xPos, self.stepWidth, self.height}, transformation))
    end

    table.insert(models, PathUtils.makePassengerPathModel({xPos, self.stepWidth, self.height}, {xPos, self:getWidth() + self.stepWidth, 0.0}, transformation))

    if endY then
        table.insert(models, PathUtils.makePassengerPathModel({xPos, self:getWidth() + self.stepWidth, 0.0}, {xPos, endY, 0.0}, transformation))
    end
end

return Stairway