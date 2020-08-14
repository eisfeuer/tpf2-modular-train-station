local RailroadCrossing = require('motras_railroad_crossing')

describe('RailroadCrossing', function ()
    describe('addEdges', function ()
        it ('adds lanes', function ()
            local rc = RailroadCrossing:new{}

            rc:addEdges({
                {{-1.0, 0.0, 0.0}, {1.0, 0.0, 0.0}},
                {{1.0, 0.0, 0.0}, {1.0, 0.0, 0.0}},
            })

            assert.are.same({
                {{-1.0, 0.0, 0.0}, {1.0, 0.0, 0.0}},
                {{1.0, 0.0, 0.0}, {1.0, 0.0, 0.0}},
            }, rc:getEdges())

            rc:addEdges({
                {{-1.0, 1.0, 0.0}, {1.0, 1.0, 0.0}},
                {{1.0, 1.0, 0.0}, {1.0, 1.0, 0.0}},
            })

            assert.are.same({
                {{-1.0, 0.0, 0.0}, {1.0, 0.0, 0.0}},
                {{1.0, 0.0, 0.0}, {1.0, 0.0, 0.0}},
                {{-1.0, 1.0, 0.0}, {1.0, 1.0, 0.0}},
                {{1.0, 1.0, 0.0}, {1.0, 1.0, 0.0}},
            }, rc:getEdges())
        end)
    end)

    describe('addToEdgeLists', function ()
        it ('adds crossing edges to edge lists', function ()    
            local edgeLists = {}

            local rc = RailroadCrossing:new{}

            rc:addEdges({
                {{-1.0, 0.0, 0.0}, {1.0, 0.0, 0.0}},
                {{1.0, 0.0, 0.0}, {1.0, 0.0, 0.0}},
            })

            rc:addToEdgeLists(edgeLists)

            assert.are.same({{		
                type = "STREET",
                alignTerrain = true,
                params = {type = 'motras/railroad_crossing.lua',},
                edges = {
                    {{-1.0, 0.0, 0.0}, {1.0, 0.0, 0.0}},
                    {{1.0, 0.0, 0.0}, {1.0, 0.0, 0.0}},
                },
                snapNodes = {},		
            }}, edgeLists)
        end)

        it ('adds nothing when edges are empty', function ()
            local edgeLists = {}

            local rc = RailroadCrossing:new{}

            rc:addToEdgeLists(edgeLists)

            assert.are.same({}, edgeLists)
        end)
    end)

end)