local ModelUtils = require('motras_modelutils')
local Transf = require('transf')

local PlatformEdge = {}

function PlatformEdge:new(o)
    o = o or {}
    setmetatable(o, self)
    self.__index = self
    return o
end

function PlatformEdge:addBottomPartToModels(models, rotation, flipFactor, bottomPartModel, horizontalDistance, verticalDistance)
    if bottomPartModel then
        table.insert(models, ModelUtils.makeTaggedModel(
            bottomPartModel,
            Transf.mul(self.transformation, Transf.rotZTransl(rotation, {x = -horizontalDistance / 2 * flipFactor, y = -verticalDistance / 2 * flipFactor, z = 0})),
            self.tag
        ))
    end
end

function PlatformEdge:addTopPartToModels(models, rotation, flipFactor, topPartModel, horizontalDistance, verticalDistance)
    if topPartModel then
        table.insert(models, ModelUtils.makeTaggedModel(
            topPartModel,
            Transf.mul(self.transformation, Transf.rotZTransl(rotation, {x = -horizontalDistance / 2 * flipFactor, y = verticalDistance / 2 * flipFactor, z = 0})),
            self.tag
        ))
    end
end

function PlatformEdge:addToModels(models, flipped)
    local horizontalDistance = self.platform:getGrid():getHorizontalDistance()
    local verticalDistance = self.platform:getGrid():getVerticalDistance()
    local rotation = flipped and math.pi or 0
    local flipFactor = flipped and -1 or 1

    local neighborBottom = self.platform:getNeighborBottom()
    local neighborTop = self.platform:getNeighborTop()

    if self.repeatingModel then
        table.insert(models, ModelUtils.makeTaggedModel(
            self.repeatingModel,
            Transf.mul(self.transformation, Transf.rotZTransl(rotation, {x = -horizontalDistance / 2 * flipFactor, y = 0, z = 0})),
            self.tag
        ))
    end

    if neighborTop:isPlatform() or neighborTop:isPlace() then
        if flipped then
            self:addBottomPartToModels(models, rotation, flipFactor, self.bottomConnectionModel, horizontalDistance, verticalDistance)
        else
            self:addTopPartToModels(models, rotation, flipFactor, self.topConnectionModel, horizontalDistance, verticalDistance)
        end
    else
        if flipped then
            self:addBottomPartToModels(models, rotation, flipFactor, self.bottomEndModel, horizontalDistance, verticalDistance)
        else
            self:addTopPartToModels(models, rotation, flipFactor, self.topEndModel, horizontalDistance, verticalDistance)
        end
    end

    if neighborBottom:isPlatform() or neighborBottom:isPlace() then
        if flipped then
            self:addTopPartToModels(models, rotation, flipFactor, self.topConnectionModel, horizontalDistance, verticalDistance)
        else
            self:addBottomPartToModels(models, rotation, flipFactor, self.bottomConnectionModel, horizontalDistance, verticalDistance)
        end
    else
        if flipped then
            self:addTopPartToModels(models, rotation, flipFactor, self.topEndModel, horizontalDistance, verticalDistance)
        else
            self:addBottomPartToModels(models, rotation, flipFactor, self.bottomEndModel, horizontalDistance, verticalDistance)
        end
    end
end

return PlatformEdge