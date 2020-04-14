local EdgeListMap = require('motras_edge_list_map')

describe('EdgeListMap', function ()
    local edgeList1 = {
        type = 'TRACK',
        params = {
            type = 'standard.lua',
            catenary = false
        },
        edges = {},
        snapNodes = {}
    }

    local edgeList2 = {
        type = 'TRACK',
        params = {
            type = 'standard.lua',
            catenary = true
        },
        edges = {},
        snapNodes = {}
    }

    local edgeList3 = {
        type = 'TRACK',
        params = {
            type = 'high_speed.lua',
            catenary = false
        },
        edges = {},
        snapNodes = {}
    }

    local edgeList4 = {
        type = 'STREET',
        params = {
            type = 'country_small.lua',
            tram = 'ELECTRIC'
        },
        edges = {},
        snapNodes = {}
    }

    local edgeLists = {
        edgeList1, edgeList2, edgeList3, edgeList4
    }

    local edgeListMap = EdgeListMap:new{edgeLists = edgeLists}

    describe('getOrCreateEdgeList', function ()
        it('returns existing edge list', function ()
            assert.are.equal(edgeList1, edgeListMap:getOrCreateEdgeList('standard.lua', false))
            assert.are.equal(edgeList2, edgeListMap:getOrCreateEdgeList('standard.lua', true))
            assert.are.equal(edgeList3, edgeListMap:getOrCreateEdgeList('high_speed.lua', false)) 
            
            assert.are.same({
                {
                    type = 'TRACK',
                    params = {
                        type = 'standard.lua',
                        catenary = false
                    },
                    edges = {},
                    snapNodes = {}
                }, {
                    type = 'TRACK',
                    params = {
                        type = 'standard.lua',
                        catenary = true
                    },
                    edges = {},
                    snapNodes = {}
                }, {
                    type = 'TRACK',
                    params = {
                        type = 'high_speed.lua',
                        catenary = false
                    },
                    edges = {},
                    snapNodes = {}
                }, {
                    type = 'STREET',
                    params = {
                        type = 'country_small.lua',
                        tram = 'ELECTRIC'
                    },
                    edges = {},
                    snapNodes = {}
                }
            }, edgeLists)
        end)

        it('creates new edge lists', function ()
            assert.are.same({
                type = 'TRACK',
                params = {
                    type = 'high_speed.lua',
                    catenary = true
                },
                edges = {},
                snapNodes = {}
            }, edgeListMap:getOrCreateEdgeList('high_speed.lua', true))

            assert.are.same({
                type = 'TRACK',
                params = {
                    type = 'monorail.lua',
                    catenary = false
                },
                edges = {},
                snapNodes = {}
            }, edgeListMap:getOrCreateEdgeList('monorail.lua', false))

            assert.are.same({
                {
                    type = 'TRACK',
                    params = {
                        type = 'standard.lua',
                        catenary = false
                    },
                    edges = {},
                    snapNodes = {}
                }, {
                    type = 'TRACK',
                    params = {
                        type = 'standard.lua',
                        catenary = true
                    },
                    edges = {},
                    snapNodes = {}
                }, {
                    type = 'TRACK',
                    params = {
                        type = 'high_speed.lua',
                        catenary = false
                    },
                    edges = {},
                    snapNodes = {}
                }, {
                    type = 'STREET',
                    params = {
                        type = 'country_small.lua',
                        tram = 'ELECTRIC'
                    },
                    edges = {},
                    snapNodes = {}
                }, {
                    type = 'TRACK',
                    params = {
                        type = 'high_speed.lua',
                        catenary = true
                    },
                    edges = {},
                    snapNodes = {}
                }, {
                    type = 'TRACK',
                    params = {
                        type = 'monorail.lua',
                        catenary = false
                    },
                    edges = {},
                    snapNodes = {}
                }
            }, edgeLists)
        end)
    end)

    describe('getEdgeLists', function ()
        it('returns edge lists table', function ()
            assert.are.equal(edgeLists, edgeListMap:getEdgeLists())
        end)
    end)

end)