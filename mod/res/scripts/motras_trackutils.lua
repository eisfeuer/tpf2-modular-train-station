local TrackUtils = {}

function TrackUtils.addEdgesToEdgeList(edgeList, edges, snapNodes)
    local currentEdgeListCnt = #edgeList.edges

    for index, edge in ipairs(edges) do
        table.insert(edgeList.edges, edge)
    end

    for index, snapNode in ipairs(snapNodes) do
        table.insert(edgeList.snapNodes, snapNode + currentEdgeListCnt)
    end
end

return TrackUtils