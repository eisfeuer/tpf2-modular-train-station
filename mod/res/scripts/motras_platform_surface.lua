local ModelUtils = require('motras_modelutils')

local PlatformSurface = {}

function PlatformSurface:new(o)
    o = o or {}
    o.models = {}

    if o.mainPart then
        table.insert(o.models, ModelUtils.makeTaggedModel(
            o.mainPart,
            o.transformation,
            o.tag
        ))
    end

    setmetatable(o, self)
    self.__index = self
    return o
end

function PlatformSurface:addPartModels(part1, part2)
    table.insert(self.models, ModelUtils.makeTaggedModel(
        part1,
        self.transformation,
        self.tag
    ))
    table.insert(self.models, ModelUtils.makeTaggedModel(
        part2,
        self.transformation,
        self.tag
    ))
end

function PlatformSurface:addStairsSegment(stairsSmallAssetId, stairsLargeAssetId, topOuterSegmentModel, topInnerSegmentModel, bottomInnerSegmentModel, bottomOuterSegmentModel)
    if self.platform:hasAsset(stairsSmallAssetId) then
        self:addPartModels(topOuterSegmentModel, bottomOuterSegmentModel)
    elseif self.platform:hasAsset(stairsLargeAssetId) then
        self:addPartModels(topOuterSegmentModel, topInnerSegmentModel)
    elseif self.platform:hasNeighborTop() and self.platform:getNeighborTop():isPlatform() and self.platform:getNeighborTop():hasAsset(stairsLargeAssetId) then
        self:addPartModels(bottomInnerSegmentModel, bottomOuterSegmentModel)
    else
        self:addPartModels(topOuterSegmentModel, topInnerSegmentModel)
        self:addPartModels(bottomInnerSegmentModel, bottomOuterSegmentModel)
    end

    return self
end

function PlatformSurface:addStairsSegmentFromIdLists(listIndex, topOuterSegmentModel, topInnerSegmentModel, bottomInnerSegmentModel, bottomOuterSegmentModel)
    return self:addStairsSegment(
        self.smallUnderpassAssetIds[listIndex],
        self.largeUnderpassAssetIds[listIndex],
        topOuterSegmentModel,
        topInnerSegmentModel,
        bottomInnerSegmentModel,
        bottomOuterSegmentModel
    )
end

function PlatformSurface:addOuterLeftSegment(topOuterSegmentModel, topInnerSegmentModel, bottomInnerSegmentModel, bottomOuterSegmentModel)
    return self:addStairsSegmentFromIdLists(1, topOuterSegmentModel, topInnerSegmentModel, bottomInnerSegmentModel, bottomOuterSegmentModel)
end

function PlatformSurface:addInnerLeftSegment(topOuterSegmentModel, topInnerSegmentModel, bottomInnerSegmentModel, bottomOuterSegmentModel)
    return self:addStairsSegmentFromIdLists(2, topOuterSegmentModel, topInnerSegmentModel, bottomInnerSegmentModel, bottomOuterSegmentModel)
end

function PlatformSurface:addInnerRightSegment(topOuterSegmentModel, topInnerSegmentModel, bottomInnerSegmentModel, bottomOuterSegmentModel)
    return self:addStairsSegmentFromIdLists(3, topOuterSegmentModel, topInnerSegmentModel, bottomInnerSegmentModel, bottomOuterSegmentModel)
end

function PlatformSurface:addOuterRightSegment(topOuterSegmentModel, topInnerSegmentModel, bottomInnerSegmentModel, bottomOuterSegmentModel)
    return self:addStairsSegmentFromIdLists(4, topOuterSegmentModel, topInnerSegmentModel, bottomInnerSegmentModel, bottomOuterSegmentModel)
end

function PlatformSurface:addToModels(models)
    for i, model in ipairs(self.models) do
        table.insert(models, model)
    end
end

return PlatformSurface