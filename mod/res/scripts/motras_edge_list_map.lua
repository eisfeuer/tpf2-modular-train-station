local EdgeListMap = {}

function EdgeListMap:new(o)
    if not (o and o.edgeLists) then
        error("Required Property edgeLists is missing")
    end

    setmetatable(o, self)
    self.__index = self

    self.edgeListMap = {}

    for i, edgeList in ipairs(o.edgeLists) do
        if edgeList.type == 'TRACK' and edgeList.params and edgeList.params.type and edgeList.params.catenary ~= nil then
            self:registerEdgeList(edgeList, edgeList.params.type, edgeList.params.catenary)
        end
    end

    return o
end

function EdgeListMap:registerEdgeList(edgeList, trackType, hasCatenary)
    if self.edgeListMap[trackType] then
        if not self.edgeListMap[trackType][hasCatenary] then
            self.edgeListMap[trackType][hasCatenary] = edgeList
        end
    else
        self.edgeListMap[trackType] = {
            [hasCatenary] = edgeList
        }
    end
end

function EdgeListMap:getOrCreateEdgeList(trackType, hasCatenary)
    if self.edgeListMap[trackType] and self.edgeListMap[trackType][hasCatenary] then
        return self.edgeListMap[trackType][hasCatenary]
    end

    local newEdgeList = {
        type = 'TRACK',
        params = {
            type = trackType,
            catenary = hasCatenary
        },
        edges = {},
        snapNodes = {}
    }

    table.insert(self.edgeLists, newEdgeList)
    self:registerEdgeList(newEdgeList, trackType, hasCatenary)

    return newEdgeList
end

function EdgeListMap:getEdgeLists()
    return self.edgeLists
end

function EdgeListMap:getIndexOfFirstNodeInEdgeList(trackType, hasCatenary)
    local nodesBeforFirstNode = 0
    for i, edgeList in ipairs(self.edgeLists) do
        if edgeList.type == 'TRACK' and edgeList.params.type == trackType and edgeList.params.catenary == hasCatenary then
            return nodesBeforFirstNode
        end
        nodesBeforFirstNode = nodesBeforFirstNode + #edgeList.edges
    end

    return 0
end

return EdgeListMap