local TrackUtils = require('motras_trackutils')

describe('TrackUtils', function ()
    
    describe('addEdgesToEdgeList', function ()
        it('adds edges to a single edge list', function ()
            local edgeList = {
                edges = {
                    { { 18, 2.0, 0.0 }, {-2.0, 0.0, 0.0 } },
                    { { 20, 2.0, 0.0 }, {-2.0, 0.0, 0.0 } },

                    { { 2, 2.0, 0.0 }, {-16.0, 0.0, 0.0 } },
                    { { 18, 2.0,  0.0 }, {-16.0, 0.0, 0.0 } },
                },
                snapNodes = {0}
            }

            TrackUtils = TrackUtils.addEdgesToEdgeList(edgeList, {
                { {10.0, 4.0, 0.0}, {-20.0, 0.0, 0.0} },
                { {-10.0, 4.0, 0.0}, {-20.0, 0.0, 0.0} },

                { {10.0, 6.0, 0.0}, {-20.0, 0.0, 0.0} },
                { {-10.0, 6.0, 0.0}, {-20.0, 0.0, 0.0} },
            }, {0, 2})

            assert.are.same({
                edges = {
                    { { 18, 2.0, 0.0 }, {-2.0, 0.0, 0.0 } },
                    { { 20, 2.0, 0.0 }, {-2.0, 0.0, 0.0 } },

                    { { 2, 2.0, 0.0 }, {-16.0, 0.0, 0.0 } },
                    { { 18, 2.0,  0.0 }, {-16.0, 0.0, 0.0 } },

                    { {10.0, 4.0, 0.0}, {-20.0, 0.0, 0.0} },
                    { {-10.0, 4.0, 0.0}, {-20.0, 0.0, 0.0} },

                    { {10.0, 6.0, 0.0}, {-20.0, 0.0, 0.0} },
                    { {-10.0, 6.0, 0.0}, {-20.0, 0.0, 0.0} },
                },
                snapNodes = {0, 4, 6}
            }, edgeList)
        end)
    end)
end)