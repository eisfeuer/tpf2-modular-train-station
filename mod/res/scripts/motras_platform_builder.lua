local PlatformBuilder = {}

function PlatformBuilder:new(o)
    o = o or {}

    if not o.platform then
        error('Platform object is required')
    end
    if not o.surface then
        error('Platform without surface looks not very well.')
    end

    setmetatable(o, self)
    self.__index = self
    return o
end

function PlatformBuilder:addToModels(models)
    local neighborLeft = self.platform:getNeighborLeft()
    local neighborRight = self.platform:getNeighborRight()
    local neighborTop = self.platform:getNeighborTop()
    local neighbotBottom = self.platform:getNeighborBottom()

    self.surface:addToModels(models)

    if not (neighbotBottom:isPlatform() or neighbotBottom:isPlace()) then
        if neighbotBottom:isTrack() and self.platformEdgeOnTrack then
            self.platformEdgeOnTrack:addToModels(models, false)
        elseif self.platformEdge then
            self.platformEdge:addToModels(models, false)
        end
    end

    if not (neighborTop:isPlatform() or neighborTop:isPlace()) then
        if neighborTop:isTrack() and self.platformEdgeOnTrack then
            self.platformEdgeOnTrack:addToModels(models, true)
        elseif self.platformEdge then
            self.platformEdge:addToModels(models, true)
        end
    end

    if self.platformSide then
        if not (neighborLeft:isPlatform() or neighborLeft:isPlace()) then
            self.platformSide:addToModels(models, false)
        end
        if not (neighborRight:isPlatform() or neighborRight:isPlace()) then
            self.platformSide:addToModels(models, true)
        end
    end

end

return PlatformBuilder