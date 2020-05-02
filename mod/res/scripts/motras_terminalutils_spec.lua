local Station = require('motras_station')
local Slot = require('motras_slot')
local EdgeListMap = require('motras_edge_list_map')
local TrackUtils = require('motras_trackutils')
local c = require('motras_constants')
local t = require('motras_types')

local TerminalUtils = require('motras_terminalutils')

describe('TerminalUtils', function ()
    local trackEdges = {
        { {-20, 0, 0,}, {8, 0, 0} },
        { {-12, 0, 0,}, {8, 0, 0} },

        { {-12, 0, 0,}, {8, 0, 0} },
        { {-4, 0, 0,}, {8, 0, 0} },

        { {-4, 0, 0,}, {8, 0, 0} },
        { {4, 0, 0,}, {8, 0, 0} },

        { {4, 0, 0,}, {8, 0, 0} },
        { {12, 0, 0,}, {8, 0, 0} },

        { {12, 0, 0,}, {8, 0, 0} },
        { {20, 0, 0,}, {8, 0, 0} },
    }
    local trackStopNodes = {2, 4, 6, 10}

    local edgeLists = {
        {
            type = 'TRACK',
            params = {
                type = 'standard.lua',
                catenary = true
            },
            edges = {},
            snapNodes = {}
        }
    }

    local edgeListMap = EdgeListMap:new{edgeLists = edgeLists}

    local station = Station:new{}
    local track1 = station:initializeAndRegister(Slot.makeId({type = t.TRACK, gridX = -1, gridY = 0}))
    track1:setTrackType('standard.lua'):setCatenary(true):setEdges(trackEdges):setStopNodes(trackStopNodes)
    track1:setEdgeListMap(edgeListMap)
    track1:setFirstNode(#edgeLists[1].edges)
    TrackUtils.addEdgesToEdgeList(edgeLists[1], track1:getEdges(), {})
    local track2 = station:initializeAndRegister(Slot.makeId({type = t.TRACK, gridX = 0, gridY = 0}))
    track2:setTrackType('standard.lua'):setCatenary(true):setEdges(trackEdges):setStopNodes(trackStopNodes)
    track2:setEdgeListMap(edgeListMap)
    track2:setFirstNode(#edgeLists[1].edges)
    TrackUtils.addEdgesToEdgeList(edgeLists[1], track2:getEdges(), {})
    local track3 = station:initializeAndRegister(Slot.makeId({type = t.TRACK, gridX = 1, gridY = 0}))
    track3:setTrackType('standard.lua'):setCatenary(true):setEdges(trackEdges):setStopNodes(trackStopNodes)
    track3:setEdgeListMap(edgeListMap)
    track3:setFirstNode(#edgeLists[1].edges)
    TrackUtils.addEdgesToEdgeList(edgeLists[1], track3:getEdges(), {})
    local track4 = station:initializeAndRegister(Slot.makeId({type = t.TRACK, gridX = 2, gridY = 0}))
    track4:setTrackType('standard.lua'):setCatenary(true):setEdges(trackEdges):setStopNodes(trackStopNodes)
    track4:setEdgeListMap(edgeListMap)
    track4:setFirstNode(#edgeLists[1].edges)
    TrackUtils.addEdgesToEdgeList(edgeLists[1], track4:getEdges(), {})

    local topPlatform1 = station:initializeAndRegister(Slot.makeId({type = t.PLATFORM, gridX = -1, gridY = 1}))
    local topPlatform2 = station:initializeAndRegister(Slot.makeId({type = t.PLATFORM, gridX = 0, gridY = 1}))
    local topPlatform3 = station:initializeAndRegister(Slot.makeId({type = t.PLATFORM, gridX = 1, gridY = 1}))

    local btmPlatform1 = station:initializeAndRegister(Slot.makeId({type = t.PLATFORM, gridX = -1, gridY = -1}))
    local btmPlatform2 = station:initializeAndRegister(Slot.makeId({type = t.PLATFORM, gridX = 0, gridY = -1}))
    local btmPlatform3 = station:initializeAndRegister(Slot.makeId({type = t.PLATFORM, gridX = 1, gridY = -1}))
    local btmPlatform4 = station:initializeAndRegister(Slot.makeId({type = t.PLATFORM, gridX = 2, gridY = -1}))

    describe('addTerminal', function ()
        it('adds terminal models and terminal group for given terminal (odd terminal count)', function ()
            local models = {
                {
                    id = 'a_model',
                    transf = { 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1 }
                }
            }
            local terminalGroups = {}

            TerminalUtils.addTerminal(terminalGroups, models, {
                {track1, topPlatform1}, {track2, topPlatform2}, {track3, topPlatform3}
            })

            assert.are.same({
                {
                    id = 'a_model',
                    transf = { 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1 }
                },
                {
                    id = c.DEFAULT_PASSENGER_TERMINAL_MODEL,
                    transf = topPlatform1:getGlobalTransformationBasedOnPlatformTop({y = -c.DEFAULT_PLATFORM_WAITING_EDGE_OFFSET})
                },
                {
                    id = c.DEFAULT_PASSENGER_TERMINAL_MODEL,
                    transf = topPlatform2:getGlobalTransformationBasedOnPlatformTop({y = -c.DEFAULT_PLATFORM_WAITING_EDGE_OFFSET})
                },
                {
                    id = c.DEFAULT_PASSENGER_TERMINAL_MODEL,
                    transf = topPlatform3:getGlobalTransformationBasedOnPlatformTop({y = -c.DEFAULT_PLATFORM_WAITING_EDGE_OFFSET})
                }
            }, models)

            assert.are.same({
                {
                    terminals = {{1, 0}, {2, 0}, {3, 0}},
                    vehicleNodeOverride = 12
                }
            }, terminalGroups)
        end)

        it('adds terminal models and terminal group for given terminal (even terminal count)', function ()
            local models = {
                {
                    id = 'a_model',
                    transf = { 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1 }
                }
            }
            local terminalGroups = {}

            TerminalUtils.addTerminal(terminalGroups, models, {
                {track1, btmPlatform1}, {track2, btmPlatform2}, {track3, btmPlatform3}, {track4, btmPlatform4}
            })

            assert.are.same({
                {
                    id = 'a_model',
                    transf = { 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1 }
                },
                {
                    id = c.DEFAULT_PASSENGER_TERMINAL_MODEL,
                    transf = btmPlatform1:getGlobalTransformationBasedOnPlatformTop({y = c.DEFAULT_PLATFORM_WAITING_EDGE_OFFSET})
                },
                {
                    id = c.DEFAULT_PASSENGER_TERMINAL_MODEL,
                    transf = btmPlatform2:getGlobalTransformationBasedOnPlatformTop({y = c.DEFAULT_PLATFORM_WAITING_EDGE_OFFSET})
                },
                {
                    id = c.DEFAULT_PASSENGER_TERMINAL_MODEL,
                    transf = btmPlatform3:getGlobalTransformationBasedOnPlatformTop({y = c.DEFAULT_PLATFORM_WAITING_EDGE_OFFSET})
                },
                {
                    id = c.DEFAULT_PASSENGER_TERMINAL_MODEL,
                    transf = btmPlatform4:getGlobalTransformationBasedOnPlatformTop({y = c.DEFAULT_PLATFORM_WAITING_EDGE_OFFSET})
                }
            }, models)

            assert.are.same({
                {
                    terminals = {{1, 0}, {2, 0}, {3, 0}, {4, 0}},
                    vehicleNodeOverride = 20
                }
            }, terminalGroups)
        end)
    end)

    describe('addTerminalsFromGrid', function ()
        it ('adds all terminals from grid', function ()
            local models = {
                {
                    id = 'a_model',
                    transf = { 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1 }
                }
            }
            local terminalGroups = {}

            TerminalUtils.addTerminalsFromGrid(terminalGroups, models, station.grid)

            assert.are.same({
                {
                    id = 'a_model',
                    transf = { 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1 }
                },
                {
                    id = c.DEFAULT_PASSENGER_TERMINAL_MODEL,
                    transf = topPlatform1:getGlobalTransformationBasedOnPlatformTop({y = -c.DEFAULT_PLATFORM_WAITING_EDGE_OFFSET})
                },
                {
                    id = c.DEFAULT_PASSENGER_TERMINAL_MODEL,
                    transf = topPlatform2:getGlobalTransformationBasedOnPlatformTop({y = -c.DEFAULT_PLATFORM_WAITING_EDGE_OFFSET})
                },
                {
                    id = c.DEFAULT_PASSENGER_TERMINAL_MODEL,
                    transf = topPlatform3:getGlobalTransformationBasedOnPlatformTop({y = -c.DEFAULT_PLATFORM_WAITING_EDGE_OFFSET})
                },
                {
                    id = c.DEFAULT_PASSENGER_TERMINAL_MODEL,
                    transf = btmPlatform1:getGlobalTransformationBasedOnPlatformTop({y = c.DEFAULT_PLATFORM_WAITING_EDGE_OFFSET})
                },
                {
                    id = c.DEFAULT_PASSENGER_TERMINAL_MODEL,
                    transf = btmPlatform2:getGlobalTransformationBasedOnPlatformTop({y = c.DEFAULT_PLATFORM_WAITING_EDGE_OFFSET})
                },
                {
                    id = c.DEFAULT_PASSENGER_TERMINAL_MODEL,
                    transf = btmPlatform3:getGlobalTransformationBasedOnPlatformTop({y = c.DEFAULT_PLATFORM_WAITING_EDGE_OFFSET})
                },
                {
                    id = c.DEFAULT_PASSENGER_TERMINAL_MODEL,
                    transf = btmPlatform4:getGlobalTransformationBasedOnPlatformTop({y = c.DEFAULT_PLATFORM_WAITING_EDGE_OFFSET})
                }
            }, models)

            assert.are.same({
                {
                    terminals = {{1, 0}, {2, 0}, {3, 0}},
                    vehicleNodeOverride = 12
                },
                {
                    terminals = {{4, 0}, {5, 0}, {6, 0}, {7, 0}},
                    vehicleNodeOverride = 20
                }
            }, terminalGroups)
        end)
    end)
end)