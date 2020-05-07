local TrackUtils = {}

function TrackUtils.addEdgesToEdgeList(edgeList, edges, snapNodes, tagNodeKey, tagNodes)
    local currentEdgeListCnt = #edgeList.edges

    for index, edge in ipairs(edges) do
        table.insert(edgeList.edges, edge)
    end

    for index, snapNode in ipairs(snapNodes) do
        table.insert(edgeList.snapNodes, snapNode + currentEdgeListCnt)
    end

    if tagNodeKey then
        edgeList.tag2nodes[tagNodeKey] = {}
        for index, node in ipairs(tagNodes) do
            table.insert(edgeList.tag2nodes[tagNodeKey], node + currentEdgeListCnt)
        end
    end
end

return TrackUtils