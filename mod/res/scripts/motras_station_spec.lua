local Slot = require("motras_slot")
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

            assert.are.same({{
                id = 'a_model.mdl',
                transf = { 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1 }
            }}, data.models)
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
    end)
end)