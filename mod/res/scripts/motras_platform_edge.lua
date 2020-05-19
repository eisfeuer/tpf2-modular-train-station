local ModelUtils = require('motras_modelutils')
local Transf = require('transf')

local PlatformEdge = {}

function PlatformEdge:new(o)
    o = o or {}
    setmetatable(o, self)
    self.__index = self
    return o
end

function PlatformEdge:addLeftPartToModels(models, rotation, flipFactor, leftPartModel, horizontalDistance, verticalDistance)
    if leftPartModel then
        table.insert(models, ModelUtils.makeTaggedModel(
            leftPartModel,
            Transf.mul(self.transformation, Transf.rotZTransl(rotation, {x = horizontalDistance / 2 * flipFactor, y = -verticalDistance / 2 * flipFactor, z = 0})),
            self.tag
        ))
    end
end

function PlatformEdge:addRightPartToModels(models, rotation, flipFactor, rightPartModel, horizontalDistance, verticalDistance)
    if rightPartModel then
        table.insert(models, ModelUtils.makeTaggedModel(
            rightPartModel,
            Transf.mul(self.transformation, Transf.rotZTransl(rotation, {x = -horizontalDistance / 2 * flipFactor, y = verticalDistance / 2 * flipFactor, z = 0})),
            self.tag
        ))
    end
end

function PlatformEdge:addToModels(models, flipped)
    local horizontalDistance = self.platform:getGrid():getHorizontalDistance()
    local verticalDistance = self.platform:getGrid():getVerticalDistance()
    local rotation = flipped and math.pi or 0
    local flipFactor = flipped and 1 or -1

    local leftNeighbor = self.platform:getNeighborLeft()
    local rightNeighbor = self.platform:getNeighborRight()

    if self.repeatingModel then
        table.insert(models, ModelUtils.makeTaggedModel(
            self.repeatingModel,
            Transf.mul(self.transformation, Transf.rotZTransl(rotation, {x = 0, y = verticalDistance / 2 * flipFactor, z = 0})),
            self.tag
        ))
    end

    if leftNeighbor:isPlatform() or leftNeighbor:isPlace() then
        if flipped then
            self:addRightPartToModels(models, rotation, flipFactor, self.rightConnectionModel, horizontalDistance, verticalDistance)
        else
            self:addLeftPartToModels(models, rotation, flipFactor, self.leftConnectionModel, horizontalDistance, verticalDistance)
        end
    else
        if flipped then
            self:addRightPartToModels(models, rotation, flipFactor, self.rightEndModel, horizontalDistance, verticalDistance)
        else
            self:addLeftPartToModels(models, rotation, flipFactor, self.leftEndModel, horizontalDistance, verticalDistance)
        end
    end

    if rightNeighbor:isPlatform() or rightNeighbor:isPlace() then
        if flipped then
            self:addLeftPartToModels(models, rotation, flipFactor, self.leftConnectionModel, horizontalDistance, verticalDistance)
        else
            self:addRightPartToModels(models, rotation, flipFactor, self.rightConnectionModel, horizontalDistance, verticalDistance)
        end
    else
        if flipped then
            self:addLeftPartToModels(models, rotation, flipFactor, self.leftEndModel, horizontalDistance, verticalDistance)
        else
            self:addRightPartToModels(models, rotation, flipFactor, self.rightEndModel, horizontalDistance, verticalDistance)
        end
    end
end

return PlatformEdge