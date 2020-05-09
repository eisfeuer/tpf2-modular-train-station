local Slot = require("motras_slot")
local UnderpassUtils = require("motras_underpassutils")
local t = require("motras_types")
local c = require("motras_constants")

local Station = require("motras_station")

describe("Station", function ()
    describe('new', function ()
        it('creates station with default grid distances', function ()
            local station = Station:new{}
            assert.are.equal(c.DEFAULT_HORIZONTAL_GRID_DISTANCE, station.grid:getHorizontalDistance())
            assert.are.equal(c.DEFAULT_VERTICAL_GRID_DISTANCE, station.grid:getVerticalDistance())
        end)

        it('creates station with custom grid distances', function ()
            local station = Station:new{horizontalGridDistance = 40, verticalGridDistance = 10}
            assert.are.equal(40, station.grid:getHorizontalDistance())
            assert.are.equal(10, station.grid:getVerticalDistance())
        end)

        it('creates station with default module prefix', function ()
            local station = Station:new{}
            assert.are.equal('motras', station.grid:getModulePrefix())
        end)

        it('creates station with custom module prefix', function ()
            local station = Station:new{modulePrefix = 'my_station'}
            assert.are.equal('my_station', station.grid:getModulePrefix())
        end)

        it('creates station with default base height', function ()
            local station = Station:new{}
            assert.are.equal(c.DEFAULT_BASE_HEIGHT, station.grid:getBaseHeight())
        end)

        it('creates station with custom base height', function ()
            local station  = Station:new{baseHeight = 4}
            assert.are.equal(4, station.grid:getBaseHeight())
        end)
    end)

    describe("initializeAndRegister", function ()
        it("creates track", function ()
            local station = Station:new()

            local slotId = Slot.makeId({
                type = t.TRACK,
                gridX = 2,
                gridY = 5
            })

            local track = station:initializeAndRegister(slotId)

            assert.is_true(track:isTrack())
            assert.are.equal(t.TRACK, track:getType())
            assert.are.equal(2, track:getGridX())
            assert.are.equal(5, track:getGridY())

            assert.are.equal(track, track:getGrid():get(2,5))
        end)

        it("creates platform", function ()
            local station = Station:new()

            local slotId = Slot.makeId({
                type = t.PLATFORM,
                gridX = 2,
                gridY = 5
            })

            local platform = station:initializeAndRegister(slotId)

            assert.is_true(platform:isPlatform())
            assert.are.equal(t.PLATFORM, platform:getType())
            assert.are.equal(2, platform:getGridX())
            assert.are.equal(5, platform:getGridY())

            assert.are.equal(platform, platform:getGrid():get(2,5))
        end)

        it("creates place", function ()
            local station = Station:new()

            local slotId = Slot.makeId({
                type = t.PLACE,
                gridX = 2,
                gridY = 5
            })

            local place = station:initializeAndRegister(slotId)

            assert.is_true(place:isPlace())
            assert.are.equal(t.PLACE, place:getType())
            assert.are.equal(2, place:getGridX())
            assert.are.equal(5, place:getGridY())

            assert.are.equal(place, place:getGrid():get(2,5))
        end)

        it("creates asset and put it in the asset cache", function ()
            local station = Station:new()

            local slotId = Slot.makeId({
                type = t.DECORATION,
                gridX = 2,
                gridY = 5,
                assetId = 1
            })

            station:initializeAndRegister(slotId)

            assert.are.equal(slotId, station.assetSlotCache.assetSlots[2][5][1].id)
        end)

        it("creates asset and bind it to grid element", function ()
            local station = Station:new()

            local slotId = Slot.makeId({
                type = t.PLATFORM,
                gridX = 2,
                gridY = 5
            })

            local platform = station:initializeAndRegister(slotId)

            local assetSlotId = Slot.makeId({
                type = t.DECORATION,
                gridX = 2,
                gridY = 5,
                assetId = 4
            })

            station:initializeAndRegister(assetSlotId)

            assert.are.equal(nil, station.assetSlotCache.assetSlots[2])
            assert.are.equal(assetSlotId, platform:getAsset(4):getSlotId())
        end)

        it("creates asset and bind it to grid element (from cache)", function ()
            local station = Station:new()

            local assetSlotId = Slot.makeId({
                type = t.DECORATION,
                gridX = 2,
                gridY = 5,
                assetId = 4
            })

            station:initializeAndRegister(assetSlotId)

            local slotId = Slot.makeId({
                type = t.PLATFORM,
                gridX = 2,
                gridY = 5
            })

            local platform = station:initializeAndRegister(slotId)

            assert.are.equal(assetSlotId, platform:getAsset(4):getSlotId())
        end)

        it("creates asset decoration and put it in the asset cache", function ()
            local station = Station:new()

            local slotId = Slot.makeId({
                type = t.ASSET_DECORATION,
                gridX = 2,
                gridY = 5,
                assetId = 1,
                assetDecorationId = 2
            })

            station:initializeAndRegister(slotId)

            assert.are.equal(slotId, station.assetDecorationSlotCache:find(Slot:new{id = slotId}).id)
        end)

        it("creates asset and bind it to grid element", function ()
            local station = Station:new()

            local slotId = Slot.makeId({
                type = t.PLATFORM,
                gridX = 2,
                gridY = 5
            })

            local platform = station:initializeAndRegister(slotId)

            local assetSlotId = Slot.makeId({
                type = t.DECORATION,
                gridX = 2,
                gridY = 5,
                assetId = 4
            })

            station:initializeAndRegister(assetSlotId)

            local assetDecorationSlotId = Slot.makeId({
                type = t.ASSET_DECORATION,
                gridX = 2,
                gridY = 5,
                assetId = 4,
                assetDecorationId = 7
            })

            station:initializeAndRegister(assetDecorationSlotId)

            assert.are.equal(nil, station.assetDecorationSlotCache.assetDecorationSlots[2])
            assert.are.equal(assetDecorationSlotId, platform:getAsset(4):getDecoration(7):getSlotId())
        end)

        it("creates asset descoration and bind it to grid element (from cache)", function ()
            local station = Station:new()

            local assetDecorationSlotId = Slot.makeId({
                type = t.ASSET_DECORATION,
                gridX = 2,
                gridY = 5,
                assetId = 4,
                assetDecorationId = 7
            })

            station:initializeAndRegister(assetDecorationSlotId)

            local slotId = Slot.makeId({
                type = t.PLATFORM,
                gridX = 2,
                gridY = 5
            })

            local assetSlotId = Slot.makeId({
                type = t.DECORATION,
                gridX = 2,
                gridY = 5,
                assetId = 4
            })

            station:initializeAndRegister(assetSlotId)

            local platform = station:initializeAndRegister(slotId)

            assert.are.equal(assetDecorationSlotId, platform:getAsset(4):getDecoration(7):getSlotId())
        end)
    end)

    describe("initializeAndRegisterAll", function ()
        it("initializes and registeres many modules", function ()
            local trackSlotId = Slot.makeId({
                type = t.TRACK,
                gridX = 2,
                gridY = 5
            })
            local platformSlotId = Slot.makeId({
                type = t.PLATFORM,
                gridX = 3,
                gridY = 4
            })

            local station = Station:new()
            station:initializeAndRegisterAll({
                [trackSlotId] = 'track.module',
                [platformSlotId] = 'platform.module'
            })

            local track = station.grid:get(2,5)
            assert.is_true(track:isTrack())
            assert.are.equal(t.TRACK, track:getType())
            assert.are.equal(2, track:getGridX())
            assert.are.equal(5, track:getGridY())

            local platform = station.grid:get(3,4)
            assert.is_true(platform:isPlatform())
            assert.are.equal(t.PLATFORM, platform:getType())
            assert.are.equal(3, platform:getGridX())
            assert.are.equal(4, platform:getGridY())

        end)
    end)

    describe('register', function ()
        it('registers module', function ()
            local station = Station:new()

            local slotId = Slot.makeId({
                type = t.TRACK,
                gridX = 2,
                gridY = 5
            })

            station:initializeAndRegister(slotId)
            local track = station:register(slotId)

            assert.is_true(track:isTrack())
            assert.are.equal(t.TRACK, track:getType())
            assert.are.equal(2, track:getGridX())
            assert.are.equal(5, track:getGridY())

            assert.are.equal(track, track:getGrid():get(2,5))
        end)

        it('registers module with additional data', function ()
            local station = Station:new()

            local slotId = Slot.makeId({
                type = t.PLATFORM,
                gridX = 2,
                gridY = 5
            })

            station:initializeAndRegister(slotId)
            local platform = station:register(slotId, {platformHeight = 0.96})

            assert.is_true(platform:isPlatform())
            assert.are.equal(t.PLATFORM, platform:getType())
            assert.are.equal(2, platform:getGridX())
            assert.are.equal(5, platform:getGridY())

            assert.are.equal(platform, platform:getGrid():get(2,5))

            assert.are.equal(0.96, platform:getPlatformHeight())
        end)

        it('registers asset', function ()
            local station = Station:new()

            local slotId = Slot.makeId({
                type = t.TRACK,
                gridX = 2,
                gridY = 5
            })
            local assetSlotId = Slot.makeId({
                type = t.DECORATION,
                gridX = 2,
                gridY = 5,
                assetId = 4
            })

            station:initializeAndRegister(slotId)
            station:initializeAndRegister(assetSlotId)

            local asset = station:register(assetSlotId, {height = 20})

            assert.are.equal(asset, asset:getGrid():get(2,5):getAsset(4))
        end)

        it('registers asset decoration', function ()
            local station = Station:new{}
            station:initializeAndRegister(Slot.makeId({type = t.PLATFORM, gridX = 0, gridY = 0}))
            station:initializeAndRegister(Slot.makeId({type = t.ASSET, gridX = 0, gridY = 0, assetId = 4}))
            station:initializeAndRegister(Slot.makeId({type = t.ASSET_DECORATION, gridX = 0, gridY = 0, assetId = 4, assetDecorationId = 7}))

            local deco = station:register(Slot.makeId({type = t.ASSET_DECORATION, gridX = 0, gridY = 0, assetId = 4, assetDecorationId = 7}))

            assert.are.equal(deco, deco:getGrid():get(0,0):getAsset(4):getDecoration(7))
        end)
    end)

    describe('getData', function ()
        it('has question mark as model when station has no models', function ()
            local station1 = Station:new()
            local data = station1:getData()
            data.terminateConstructionHook()

            assert.are.same({{
                id = 'asset/icon/marker_question.mdl',
                transf = { 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1 }
            }}, data.models)

            local station2 = Station:new()
            station2:initializeAndRegister(Slot.makeId({type = t.TRACK, gridX = 0, gridY = 0}))

            data = station2:getData()
            data.terminateConstructionHook()
            assert.are.same({{
                id = 'asset/icon/marker_question.mdl',
                transf = { 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1 }
            }}, data.models)

            local station3 = Station:new()
            local platform = station3:initializeAndRegister(Slot.makeId({type = t.PLATFORM, gridX = 0, gridY = 0}))
            platform:handle(function (result)
                table.insert(result.models, {
                    id = 'a_model.mdl',
                    transf = { 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1 }
                })
            end)

            data = station3:getData()
            data.terminateConstructionHook()

            local expectedModels = {{
                id = 'a_model.mdl',
                transf = { 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1 }
            }}
            UnderpassUtils.addUnderpassLaneGridToModels(station3.grid, expectedModels)

            assert.are.same(expectedModels, data.models)
        end)

        it ('has terminateConstructionHook', function ()
            local station = Station:new()
            assert.is.truthy(station:getData().terminateConstructionHook)
        end)

        it ('has properties necessary for Transport Fever 2', function ()
            local station = Station:new()
            assert.is.truthy(station:getData().slots)
            assert.is.truthy(station:getData().edgeLists)
            assert.is.truthy(station:getData().terminalGroups)
            assert.is.truthy(station:getData().terrainAlignmentLists)
            assert.is.truthy(station:getData().groundFaces)
        end)

        it ('has itself as motras property', function ()
            local station = Station:new()
            assert.are.equal(station, station:getData().motras)
        end)

        it ('has places edges', function ()
            local station = Station:new()

            local track1 = station:initializeAndRegister(Slot.makeId({type = t.TRACK, gridX = 0, gridY = 0}))
            local track2 = station:initializeAndRegister(Slot.makeId({type = t.TRACK, gridX = 1, gridY = 0}))
            local track3 = station:initializeAndRegister(Slot.makeId({type = t.TRACK, gridX = 0, gridY = 1}))

            track1:handle(function (track)
                track1:setEdges({
                    {{-10, 0.0, 0.0}, {20.0, 0.0, 0.0}},
                    {{ 10, 0.0, 0.0}, {20.0, 0.0, 0.0}}
                }, {0})
            end)

            track2:handle(function (track)
                track2:setEdges({
                    {{ 10, 0.0, 0.0}, {20.0, 0.0, 0.0}},
                    {{ 30, 0.0, 0.0}, {20.0, 0.0, 0.0}}
                }, {1})
            end)

            track3:handle(function (track)
                track3:setTrackType('high_speed.lua'):setCatenary(true):setEdges({
                    {{-10, 5.0, 0.0}, {20.0, 0.0, 0.0}},
                    {{ 10, 5.0, 0.0}, {20.0, 0.0, 0.0}}
                }, {0,1})
            end)

            local data = station:getData()
            data.terminateConstructionHook()

            assert.are.same({
                {
                    type = 'TRACK',
                    params = {
                        type = 'standard.lua',
                        catenary = false
                    },
                    edges = {
                        {{ 10, 0.0, 0.0}, {20.0, 0.0, 0.0}},
                        {{ 30, 0.0, 0.0}, {20.0, 0.0, 0.0}},
                        {{-10, 0.0, 0.0}, {20.0, 0.0, 0.0}},
                        {{ 10, 0.0, 0.0}, {20.0, 0.0, 0.0}}
                    },
                    snapNodes = {1, 2},
                    tag2nodes = {
                        [track1:getTagNodesKey()] = {2, 3},
                        [track2:getTagNodesKey()] = {0, 1}
                    },
                }, {
                    type = 'TRACK',
                    params = {
                        type = 'high_speed.lua',
                        catenary = true
                    },
                    edges = {
                        {{-10, 5.0, 0.0}, {20.0, 0.0, 0.0}},
                        {{ 10, 5.0, 0.0}, {20.0, 0.0, 0.0}}
                    },
                    snapNodes = {0,1},
                    tag2nodes = {
                        [track3:getTagNodesKey()] = {0, 1}
                    },
                }
            }, data.edgeLists)

            assert.are.equal(2, track1:getFirstNode())
            assert.are.equal(0, track2:getFirstNode())
            assert.are.equal(0, track3:getFirstNode())
        end)
    end)

    describe('getCustomTrack1', function ()
        it ('returns custom track 1', function ()
            local station = Station:new{customTrack1 = 's_bahn_hamburg.lua'}
            assert.are.equal('s_bahn_hamburg.lua', station:getCustomTrack1())
        end)

        it ('returns standard.lua when no custom track is set', function ()
            local station = Station:new()
            assert.are.equal('standard.lua', station:getCustomTrack1())
        end)
    end)

    describe('getCustomTrack2', function ()
        it ('returns custom track 2', function ()
            local station = Station:new{customTrack2 = 's_bahn_hamburg.lua'}
            assert.are.equal('s_bahn_hamburg.lua', station:getCustomTrack2())
        end)

        it ('returns standard.lua when no custom track is set', function ()
            local station = Station:new()
            assert.are.equal('standard.lua', station:getCustomTrack2())
        end)
    end)
end)