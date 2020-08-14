local RailroadCrossing = {}

function RailroadCrossing:new(o)
    o = o or {}

    o.edges = o.edges or {}

    setmetatable(o, self)
    self.__index = self
    return o
end

function RailroadCrossing:addEdges(edges)
    for _, edge in ipairs(edges) do
        table.insert(self.edges, edge)
    end
end

function RailroadCrossing:getEdges()
    return self.edges
end

function RailroadCrossing:addToEdgeLists(edgeLists)
    if #self.edges > 0 then
        if #self.edges % 2 > 0 then
            error('Error in Railroad Crossing - Edge Count MUST be even')
        end

        table.insert(edgeLists, {		
            type = "STREET",
            alignTerrain = true,
            params = {type = 'motras/railroad_crossing.lua',},
            edges = self.edges,
            snapNodes = {},		
        })
    end
end

return RailroadCrossing