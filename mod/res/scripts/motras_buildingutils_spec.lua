local Station = require('motras_station')
local Slot = require('motras_slot')
local Box = require('motras_box')
local t = require('motras_types')
local c = require('motras_constants')
local transf = require('transf')

local BuildingUtils = require('motras_buildingutils')

local function initializeScenario()
    local station = Station:new{}

    station:initializeAndRegister(Slot.makeId({type = t.PLATFORM, gridX = -1, gridY = 0}))
    station:initializeAndRegister(Slot.makeId({type = t.PLATFORM, gridX = 0, gridY = 0}))
    station:initializeAndRegister(Slot.makeId({type = t.PLATFORM, gridX = 1, gridY = 0}))

    return station
end

describe('BuildingUtils', function ()
    describe('getSmallLeftNeighborBuildingOn40m', function ()
        it('get small neighbor building on same platform (small building)', function ()
            local station = initializeScenario()

            local building1 = station:initializeAndRegister(Slot.makeId({type = t.BUILDING, gridX = 0, gridY = 0, assetId = 4}))
            local building2 = station:initializeAndRegister(Slot.makeId({type = t.BUILDING, gridX = 0, gridY = 0, assetId = 3}))
            local building3 = station:initializeAndRegister(Slot.makeId({type = t.BUILDING, gridX = 0, gridY = 0, assetId = 16}))
            local building4 = station:initializeAndRegister(Slot.makeId({type = t.BUILDING, gridX = 0, gridY = 0, assetId = 15}))

            assert.are.equal(building2, BuildingUtils.getSmallLeftNeighborBuildingOn40m(building1))
            assert.are.equal(nil, BuildingUtils.getSmallLeftNeighborBuildingOn40m(building2))
            assert.are.equal(building4, BuildingUtils.getSmallLeftNeighborBuildingOn40m(building3))
            assert.are.equal(nil, BuildingUtils.getSmallLeftNeighborBuildingOn40m(building4))
        end)
        
        it('has small neighbor building at neighbor platform (small building)', function ()
            local station = initializeScenario()

            local building1 = station:initializeAndRegister(Slot.makeId({type = t.BUILDING, gridX = 0, gridY = 0, assetId = 1}))
            local building2 = station:initializeAndRegister(Slot.makeId({type = t.BUILDING, gridX = -1, gridY = 0, assetId = 4}))
            local building3 = station:initializeAndRegister(Slot.makeId({type = t.BUILDING, gridX = 1, gridY = 0, assetId = 1}))

            local building4 = station:initializeAndRegister(Slot.makeId({type = t.BUILDING, gridX = 0, gridY = 0, assetId = 13}))
            local building5 = station:initializeAndRegister(Slot.makeId({type = t.BUILDING, gridX = 1, gridY = 0, assetId = 16}))
            local building6 = station:initializeAndRegister(Slot.makeId({type = t.BUILDING, gridX = -1, gridY = 0, assetId = 13}))

            local building7 = station:initializeAndRegister(Slot.makeId({type = t.BUILDING, gridX = -1, gridY = 0, assetId = 1}))

            assert.are.equal(building2, BuildingUtils.getSmallLeftNeighborBuildingOn40m(building1))
            assert.are.equal(nil, BuildingUtils.getSmallLeftNeighborBuildingOn40m(building2))
            assert.are.equal(nil, BuildingUtils.getSmallLeftNeighborBuildingOn40m(building3))

            assert.are.equal(building5, BuildingUtils.getSmallLeftNeighborBuildingOn40m(building4))
            assert.are.equal(nil, BuildingUtils.getSmallLeftNeighborBuildingOn40m(building5))
            assert.are.equal(nil, BuildingUtils.getSmallLeftNeighborBuildingOn40m(building6))

            assert.are.equal(nil, BuildingUtils.getSmallLeftNeighborBuildingOn40m(building7))
        end)

        it('get small neighbor building on same platform (medium building)', function ()
            local station = initializeScenario()

            local building1 = station:initializeAndRegister(Slot.makeId({type = t.BUILDING, gridX = 0, gridY = 0, assetId = 2}))
            local building2 = station:initializeAndRegister(Slot.makeId({type = t.BUILDING, gridX = 0, gridY = 0, assetId = 8}))
            local building3 = station:initializeAndRegister(Slot.makeId({type = t.BUILDING, gridX = 0, gridY = 0, assetId = 7}))

            local building4 = station:initializeAndRegister(Slot.makeId({type = t.BUILDING, gridX = 0, gridY = 0, assetId = 14}))
            local building5 = station:initializeAndRegister(Slot.makeId({type = t.BUILDING, gridX = 0, gridY = 0, assetId = 20}))
            local building6 = station:initializeAndRegister(Slot.makeId({type = t.BUILDING, gridX = 0, gridY = 0, assetId = 19}))

            assert.is_nil(BuildingUtils.getSmallLeftNeighborBuildingOn40m(building1))
            assert.are.equal(building1, BuildingUtils.getSmallLeftNeighborBuildingOn40m(building2))
            assert.is_nil(BuildingUtils.getSmallLeftNeighborBuildingOn40m(building3))

            assert.is_nil(BuildingUtils.getSmallLeftNeighborBuildingOn40m(building4))
            assert.are.equal(building4, BuildingUtils.getSmallLeftNeighborBuildingOn40m(building5))
            assert.is_nil(BuildingUtils.getSmallLeftNeighborBuildingOn40m(building6))
        end)

        it('has small neighbor building at neighbor platform (medium building)', function ()
            local station = initializeScenario()

            local building1 = station:initializeAndRegister(Slot.makeId({type = t.BUILDING, gridX = 0, gridY = 0, assetId = 5}))
            local building2 = station:initializeAndRegister(Slot.makeId({type = t.BUILDING, gridX = -1, gridY = 0, assetId = 3}))
            local building3 = station:initializeAndRegister(Slot.makeId({type = t.BUILDING, gridX = 1, gridY = 0, assetId = 5}))

            local building4 = station:initializeAndRegister(Slot.makeId({type = t.BUILDING, gridX = 0, gridY = 0, assetId = 17}))
            local building5 = station:initializeAndRegister(Slot.makeId({type = t.BUILDING, gridX = 1, gridY = 0, assetId = 15}))
            local building6 = station:initializeAndRegister(Slot.makeId({type = t.BUILDING, gridX = -1, gridY = 0, assetId = 17}))

            assert.are.equal(building2, BuildingUtils.getSmallLeftNeighborBuildingOn40m(building1))
            assert.are.equal(nil, BuildingUtils.getSmallLeftNeighborBuildingOn40m(building2))
            assert.are.equal(nil, BuildingUtils.getSmallLeftNeighborBuildingOn40m(building3))

            assert.are.equal(building5, BuildingUtils.getSmallLeftNeighborBuildingOn40m(building4))
            assert.are.equal(nil, BuildingUtils.getSmallLeftNeighborBuildingOn40m(building5))
            assert.are.equal(nil, BuildingUtils.getSmallLeftNeighborBuildingOn40m(building6))
        end)

        it('get small neighbor building on same platform (large building)', function ()
            local station = initializeScenario()

            local building1 = station:initializeAndRegister(Slot.makeId({type = t.BUILDING, gridX = 0, gridY = 0, assetId = 1}))
            local building2 = station:initializeAndRegister(Slot.makeId({type = t.BUILDING, gridX = 0, gridY = 0, assetId = 12}))
            local building3 = station:initializeAndRegister(Slot.makeId({type = t.BUILDING, gridX = 0, gridY = 0, assetId = 11}))

            local building4 = station:initializeAndRegister(Slot.makeId({type = t.BUILDING, gridX = 0, gridY = 0, assetId = 13}))
            local building5 = station:initializeAndRegister(Slot.makeId({type = t.BUILDING, gridX = 0, gridY = 0, assetId = 24}))
            local building6 = station:initializeAndRegister(Slot.makeId({type = t.BUILDING, gridX = 0, gridY = 0, assetId = 23}))

            assert.are.equal(nil, BuildingUtils.getSmallLeftNeighborBuildingOn40m(building1))
            assert.are.equal(building1, BuildingUtils.getSmallLeftNeighborBuildingOn40m(building2))
            assert.are.equal(nil, BuildingUtils.getSmallLeftNeighborBuildingOn40m(building3))

            assert.are.equal(nil, BuildingUtils.getSmallLeftNeighborBuildingOn40m(building4))
            assert.are.equal(building4, BuildingUtils.getSmallLeftNeighborBuildingOn40m(building5))
            assert.are.equal(nil, BuildingUtils.getSmallLeftNeighborBuildingOn40m(building6))
        end)

        it('has small neighbor building at neighbor platform (large building)', function ()
            local station = initializeScenario()

            local building1 = station:initializeAndRegister(Slot.makeId({type = t.BUILDING, gridX = 0, gridY = 0, assetId = 9}))
            local building2 = station:initializeAndRegister(Slot.makeId({type = t.BUILDING, gridX = -1, gridY = 0, assetId = 2}))
            local building3 = station:initializeAndRegister(Slot.makeId({type = t.BUILDING, gridX = 1, gridY = 0, assetId = 9}))

            local building4 = station:initializeAndRegister(Slot.makeId({type = t.BUILDING, gridX = 0, gridY = 0, assetId = 21}))
            local building5 = station:initializeAndRegister(Slot.makeId({type = t.BUILDING, gridX = 1, gridY = 0, assetId = 14}))
            local building6 = station:initializeAndRegister(Slot.makeId({type = t.BUILDING, gridX = -1, gridY = 0, assetId = 21}))

            assert.are.equal(building2, BuildingUtils.getSmallLeftNeighborBuildingOn40m(building1))
            assert.are.equal(nil, BuildingUtils.getSmallLeftNeighborBuildingOn40m(building2))
            assert.are.equal(nil, BuildingUtils.getSmallLeftNeighborBuildingOn40m(building3))

            assert.are.equal(building5, BuildingUtils.getSmallLeftNeighborBuildingOn40m(building4))
            assert.are.equal(nil, BuildingUtils.getSmallLeftNeighborBuildingOn40m(building5))
            assert.are.equal(nil, BuildingUtils.getSmallLeftNeighborBuildingOn40m(building6))
        end)  
    end)

    describe('getMediumLeftNeighborBuildingOn40m', function ()
        it('get medium neighbor building on same platform (small building)', function ()
            local station = initializeScenario()

            local building1 = station:initializeAndRegister(Slot.makeId({type = t.BUILDING, gridX = 0, gridY = 0, assetId = 4}))
            local building2 = station:initializeAndRegister(Slot.makeId({type = t.BUILDING, gridX = 0, gridY = 0, assetId = 7}))
            local building3 = station:initializeAndRegister(Slot.makeId({type = t.BUILDING, gridX = 0, gridY = 0, assetId = 16}))
            local building4 = station:initializeAndRegister(Slot.makeId({type = t.BUILDING, gridX = 0, gridY = 0, assetId = 19}))

            assert.are.equal(building2, BuildingUtils.getMediumLeftNeighborBuildingOn40m(building1))
            assert.are.equal(nil, BuildingUtils.getMediumLeftNeighborBuildingOn40m(building2))
            assert.are.equal(building4, BuildingUtils.getMediumLeftNeighborBuildingOn40m(building3))
            assert.are.equal(nil, BuildingUtils.getMediumLeftNeighborBuildingOn40m(building4))
        end)
        
        it('has medium neighbor building at neighbor platform (small building)', function ()
            local station = initializeScenario()

            local building1 = station:initializeAndRegister(Slot.makeId({type = t.BUILDING, gridX = 0, gridY = 0, assetId = 1}))
            local building2 = station:initializeAndRegister(Slot.makeId({type = t.BUILDING, gridX = -1, gridY = 0, assetId = 8}))
            local building3 = station:initializeAndRegister(Slot.makeId({type = t.BUILDING, gridX = 1, gridY = 0, assetId = 1}))

            local building4 = station:initializeAndRegister(Slot.makeId({type = t.BUILDING, gridX = 0, gridY = 0, assetId = 13}))
            local building5 = station:initializeAndRegister(Slot.makeId({type = t.BUILDING, gridX = 1, gridY = 0, assetId = 20}))
            local building6 = station:initializeAndRegister(Slot.makeId({type = t.BUILDING, gridX = -1, gridY = 0, assetId = 13}))

            local building7 = station:initializeAndRegister(Slot.makeId({type = t.BUILDING, gridX = -1, gridY = 0, assetId = 1}))

            assert.are.equal(building2, BuildingUtils.getMediumLeftNeighborBuildingOn40m(building1))
            assert.are.equal(nil, BuildingUtils.getMediumLeftNeighborBuildingOn40m(building2))
            assert.are.equal(nil, BuildingUtils.getMediumLeftNeighborBuildingOn40m(building3))

            assert.are.equal(building5, BuildingUtils.getMediumLeftNeighborBuildingOn40m(building4))
            assert.are.equal(nil, BuildingUtils.getMediumLeftNeighborBuildingOn40m(building5))
            assert.are.equal(nil, BuildingUtils.getMediumLeftNeighborBuildingOn40m(building6))

            assert.are.equal(nil, BuildingUtils.getMediumLeftNeighborBuildingOn40m(building7))
        end)

        it('get medium neighbor building on same platform (medium building)', function ()
            local station = initializeScenario()

            local building1 = station:initializeAndRegister(Slot.makeId({type = t.BUILDING, gridX = 0, gridY = 0, assetId = 8}))
            local building2 = station:initializeAndRegister(Slot.makeId({type = t.BUILDING, gridX = 0, gridY = 0, assetId = 6}))
            local building3 = station:initializeAndRegister(Slot.makeId({type = t.BUILDING, gridX = 0, gridY = 0, assetId = 20}))
            local building4 = station:initializeAndRegister(Slot.makeId({type = t.BUILDING, gridX = 0, gridY = 0, assetId = 18}))

            assert.are.equal(building2, BuildingUtils.getMediumLeftNeighborBuildingOn40m(building1))
            assert.are.equal(nil, BuildingUtils.getMediumLeftNeighborBuildingOn40m(building2))
            assert.are.equal(building4, BuildingUtils.getMediumLeftNeighborBuildingOn40m(building3))
            assert.are.equal(nil, BuildingUtils.getMediumLeftNeighborBuildingOn40m(building4))
        end)
        
        it('has medium neighbor building at neighbor platform (medium building)', function ()
            local station = initializeScenario()

            local building1 = station:initializeAndRegister(Slot.makeId({type = t.BUILDING, gridX = 0, gridY = 0, assetId = 6}))
            local building2 = station:initializeAndRegister(Slot.makeId({type = t.BUILDING, gridX = -1, gridY = 0, assetId = 8}))
            local building3 = station:initializeAndRegister(Slot.makeId({type = t.BUILDING, gridX = 1, gridY = 0, assetId = 6}))

            local building4 = station:initializeAndRegister(Slot.makeId({type = t.BUILDING, gridX = 0, gridY = 0, assetId = 17}))
            local building5 = station:initializeAndRegister(Slot.makeId({type = t.BUILDING, gridX = 1, gridY = 0, assetId = 19}))
            local building6 = station:initializeAndRegister(Slot.makeId({type = t.BUILDING, gridX = -1, gridY = 0, assetId = 17}))

            assert.are.equal(building2, BuildingUtils.getMediumLeftNeighborBuildingOn40m(building1))
            assert.are.equal(nil, BuildingUtils.getMediumLeftNeighborBuildingOn40m(building2))
            assert.are.equal(nil, BuildingUtils.getMediumLeftNeighborBuildingOn40m(building3))

            assert.are.equal(building5, BuildingUtils.getMediumLeftNeighborBuildingOn40m(building4))
            assert.are.equal(nil, BuildingUtils.getMediumLeftNeighborBuildingOn40m(building5))
            assert.are.equal(nil, BuildingUtils.getMediumLeftNeighborBuildingOn40m(building6))
        end)

        it('get medium neighbor building on same platform (large building)', function ()
            local station = initializeScenario()

            local building1 = station:initializeAndRegister(Slot.makeId({type = t.BUILDING, gridX = 0, gridY = 0, assetId = 12}))
            local building2 = station:initializeAndRegister(Slot.makeId({type = t.BUILDING, gridX = 0, gridY = 0, assetId = 5}))
            local building3 = station:initializeAndRegister(Slot.makeId({type = t.BUILDING, gridX = 0, gridY = 0, assetId = 24}))
            local building4 = station:initializeAndRegister(Slot.makeId({type = t.BUILDING, gridX = 0, gridY = 0, assetId = 17}))

            assert.are.equal(building2, BuildingUtils.getMediumLeftNeighborBuildingOn40m(building1))
            assert.are.equal(nil, BuildingUtils.getMediumLeftNeighborBuildingOn40m(building2))
            assert.are.equal(building4, BuildingUtils.getMediumLeftNeighborBuildingOn40m(building3))
            assert.are.equal(nil, BuildingUtils.getMediumLeftNeighborBuildingOn40m(building4))
        end)
        
        it('has medium neighbor building at neighbor platform (large building)', function ()
            local station = initializeScenario()

            local building1 = station:initializeAndRegister(Slot.makeId({type = t.BUILDING, gridX = 0, gridY = 0, assetId = 11}))
            local building2 = station:initializeAndRegister(Slot.makeId({type = t.BUILDING, gridX = -1, gridY = 0, assetId = 8}))
            local building3 = station:initializeAndRegister(Slot.makeId({type = t.BUILDING, gridX = 1, gridY = 0, assetId = 11}))

            local building4 = station:initializeAndRegister(Slot.makeId({type = t.BUILDING, gridX = 0, gridY = 0, assetId = 21}))
            local building5 = station:initializeAndRegister(Slot.makeId({type = t.BUILDING, gridX = 1, gridY = 0, assetId = 18}))
            local building6 = station:initializeAndRegister(Slot.makeId({type = t.BUILDING, gridX = -1, gridY = 0, assetId = 21}))

            assert.are.equal(building2, BuildingUtils.getMediumLeftNeighborBuildingOn40m(building1))
            assert.are.equal(nil, BuildingUtils.getMediumLeftNeighborBuildingOn40m(building2))
            assert.are.equal(nil, BuildingUtils.getMediumLeftNeighborBuildingOn40m(building3))

            assert.are.equal(building5, BuildingUtils.getMediumLeftNeighborBuildingOn40m(building4))
            assert.are.equal(nil, BuildingUtils.getMediumLeftNeighborBuildingOn40m(building5))
            assert.are.equal(nil, BuildingUtils.getMediumLeftNeighborBuildingOn40m(building6))
        end)
    end)

    describe('getLargeLeftNeighborBuildingOn40m', function ()
        it('get large neighbor building on same platform (small building)', function ()
            local station = initializeScenario()

            local building1 = station:initializeAndRegister(Slot.makeId({type = t.BUILDING, gridX = 0, gridY = 0, assetId = 4}))
            local building2 = station:initializeAndRegister(Slot.makeId({type = t.BUILDING, gridX = 0, gridY = 0, assetId = 10}))
            local building3 = station:initializeAndRegister(Slot.makeId({type = t.BUILDING, gridX = 0, gridY = 0, assetId = 15}))
            local building4 = station:initializeAndRegister(Slot.makeId({type = t.BUILDING, gridX = 0, gridY = 0, assetId = 21}))

            assert.are.equal(building2, BuildingUtils.getLargeLeftNeighborBuildingOn40m(building1))
            assert.are.equal(nil, BuildingUtils.getLargeLeftNeighborBuildingOn40m(building2))
            assert.are.equal(building4, BuildingUtils.getLargeLeftNeighborBuildingOn40m(building3))
            assert.are.equal(nil, BuildingUtils.getLargeLeftNeighborBuildingOn40m(building4))
        end)
        
        it('has large neighbor building at neighbor platform (small building)', function ()
            local station = initializeScenario()

            local building1 = station:initializeAndRegister(Slot.makeId({type = t.BUILDING, gridX = 0, gridY = 0, assetId = 2}))
            local building2 = station:initializeAndRegister(Slot.makeId({type = t.BUILDING, gridX = -1, gridY = 0, assetId = 12}))
            local building3 = station:initializeAndRegister(Slot.makeId({type = t.BUILDING, gridX = 1, gridY = 0, assetId = 2}))

            local building4 = station:initializeAndRegister(Slot.makeId({type = t.BUILDING, gridX = 0, gridY = 0, assetId = 13}))
            local building5 = station:initializeAndRegister(Slot.makeId({type = t.BUILDING, gridX = 1, gridY = 0, assetId = 23}))
            local building6 = station:initializeAndRegister(Slot.makeId({type = t.BUILDING, gridX = -1, gridY = 0, assetId = 13}))

            assert.are.equal(building2, BuildingUtils.getLargeLeftNeighborBuildingOn40m(building1))
            assert.are.equal(nil, BuildingUtils.getLargeLeftNeighborBuildingOn40m(building2))
            assert.are.equal(nil, BuildingUtils.getLargeLeftNeighborBuildingOn40m(building3))

            assert.are.equal(building5, BuildingUtils.getLargeLeftNeighborBuildingOn40m(building4))
            assert.are.equal(nil, BuildingUtils.getLargeLeftNeighborBuildingOn40m(building5))
            assert.are.equal(nil, BuildingUtils.getLargeLeftNeighborBuildingOn40m(building6))
        end)

        it('get large neighbor building on same platform (medium building)', function ()
            local station = initializeScenario()

            local building1 = station:initializeAndRegister(Slot.makeId({type = t.BUILDING, gridX = 0, gridY = 0, assetId = 8}))
            local building2 = station:initializeAndRegister(Slot.makeId({type = t.BUILDING, gridX = 0, gridY = 0, assetId = 9}))
            local building3 = station:initializeAndRegister(Slot.makeId({type = t.BUILDING, gridX = 0, gridY = 0, assetId = 20}))
            local building4 = station:initializeAndRegister(Slot.makeId({type = t.BUILDING, gridX = 0, gridY = 0, assetId = 21}))

            assert.are.equal(building2, BuildingUtils.getLargeLeftNeighborBuildingOn40m(building1))
            assert.are.equal(nil, BuildingUtils.getLargeLeftNeighborBuildingOn40m(building2))
            assert.are.equal(building4, BuildingUtils.getLargeLeftNeighborBuildingOn40m(building3))
            assert.are.equal(nil, BuildingUtils.getLargeLeftNeighborBuildingOn40m(building4))
        end)
        
        it('has large neighbor building at neighbor platform (medium building)', function ()
            local station = initializeScenario()

            local building1 = station:initializeAndRegister(Slot.makeId({type = t.BUILDING, gridX = 0, gridY = 0, assetId = 7}))
            local building2 = station:initializeAndRegister(Slot.makeId({type = t.BUILDING, gridX = -1, gridY = 0, assetId = 12}))
            local building3 = station:initializeAndRegister(Slot.makeId({type = t.BUILDING, gridX = 1, gridY = 0, assetId = 7}))

            local building4 = station:initializeAndRegister(Slot.makeId({type = t.BUILDING, gridX = 0, gridY = 0, assetId = 17}))
            local building5 = station:initializeAndRegister(Slot.makeId({type = t.BUILDING, gridX = 1, gridY = 0, assetId = 22}))
            local building6 = station:initializeAndRegister(Slot.makeId({type = t.BUILDING, gridX = -1, gridY = 0, assetId = 17}))

            assert.are.equal(building2, BuildingUtils.getLargeLeftNeighborBuildingOn40m(building1))
            assert.are.equal(nil, BuildingUtils.getLargeLeftNeighborBuildingOn40m(building2))
            assert.are.equal(nil, BuildingUtils.getLargeLeftNeighborBuildingOn40m(building3))

            assert.are.equal(building5, BuildingUtils.getLargeLeftNeighborBuildingOn40m(building4))
            assert.are.equal(nil, BuildingUtils.getLargeLeftNeighborBuildingOn40m(building5))
            assert.are.equal(nil, BuildingUtils.getLargeLeftNeighborBuildingOn40m(building6))
        end)

        it('has large neighbor building at neighbor platform (large building)', function ()
            local station = initializeScenario()

            local building1 = station:initializeAndRegister(Slot.makeId({type = t.BUILDING, gridX = 0, gridY = 0, assetId = 9}))
            local building2 = station:initializeAndRegister(Slot.makeId({type = t.BUILDING, gridX = -1, gridY = 0, assetId = 9}))
            local building3 = station:initializeAndRegister(Slot.makeId({type = t.BUILDING, gridX = 1, gridY = 0, assetId = 10}))

            local building4 = station:initializeAndRegister(Slot.makeId({type = t.BUILDING, gridX = 0, gridY = 0, assetId = 22}))
            local building5 = station:initializeAndRegister(Slot.makeId({type = t.BUILDING, gridX = 1, gridY = 0, assetId = 22}))
            local building6 = station:initializeAndRegister(Slot.makeId({type = t.BUILDING, gridX = -1, gridY = 0, assetId = 23}))

            assert.are.equal(building2, BuildingUtils.getLargeLeftNeighborBuildingOn40m(building1))
            assert.are.equal(nil, BuildingUtils.getLargeLeftNeighborBuildingOn40m(building2))
            assert.are.equal(nil, BuildingUtils.getLargeLeftNeighborBuildingOn40m(building3))

            assert.are.equal(building5, BuildingUtils.getLargeLeftNeighborBuildingOn40m(building4))
            assert.are.equal(nil, BuildingUtils.getLargeLeftNeighborBuildingOn40m(building5))
            assert.are.equal(nil, BuildingUtils.getLargeLeftNeighborBuildingOn40m(building6))
        end)
    end)

    describe('getSmallRightNeighborBuildingOn40m', function ()
        it('get small neighbor building on same platform (small building)', function ()
            local station = initializeScenario()

            local building1 = station:initializeAndRegister(Slot.makeId({type = t.BUILDING, gridX = 0, gridY = 0, assetId = 1}))
            local building2 = station:initializeAndRegister(Slot.makeId({type = t.BUILDING, gridX = 0, gridY = 0, assetId = 2}))
            local building3 = station:initializeAndRegister(Slot.makeId({type = t.BUILDING, gridX = 0, gridY = 0, assetId = 13}))
            local building4 = station:initializeAndRegister(Slot.makeId({type = t.BUILDING, gridX = 0, gridY = 0, assetId = 14}))

            assert.are.equal(building2, BuildingUtils.getSmallRightNeighborBuildingOn40m(building1))
            assert.are.equal(nil, BuildingUtils.getSmallRightNeighborBuildingOn40m(building2))
            assert.are.equal(building4, BuildingUtils.getSmallRightNeighborBuildingOn40m(building3))
            assert.are.equal(nil, BuildingUtils.getSmallRightNeighborBuildingOn40m(building4))
        end)
        
        it('has small neighbor building at neighbor platform (small building)', function ()
            local station = initializeScenario()

            local building1 = station:initializeAndRegister(Slot.makeId({type = t.BUILDING, gridX = 0, gridY = 0, assetId = 4}))
            local building2 = station:initializeAndRegister(Slot.makeId({type = t.BUILDING, gridX = 1, gridY = 0, assetId = 1}))
            local building3 = station:initializeAndRegister(Slot.makeId({type = t.BUILDING, gridX = -1, gridY = 0, assetId = 4}))

            local building4 = station:initializeAndRegister(Slot.makeId({type = t.BUILDING, gridX = 0, gridY = 0, assetId = 16}))
            local building5 = station:initializeAndRegister(Slot.makeId({type = t.BUILDING, gridX = -1, gridY = 0, assetId = 13}))
            local building6 = station:initializeAndRegister(Slot.makeId({type = t.BUILDING, gridX = 1, gridY = 0, assetId = 16}))

            local building7 = station:initializeAndRegister(Slot.makeId({type = t.BUILDING, gridX = -1, gridY = 0, assetId = 1}))

            assert.are.equal(building2, BuildingUtils.getSmallRightNeighborBuildingOn40m(building1))
            assert.are.equal(nil, BuildingUtils.getSmallRightNeighborBuildingOn40m(building2))
            assert.are.equal(nil, BuildingUtils.getSmallRightNeighborBuildingOn40m(building3))

            assert.are.equal(building5, BuildingUtils.getSmallRightNeighborBuildingOn40m(building4))
            assert.are.equal(nil, BuildingUtils.getSmallRightNeighborBuildingOn40m(building5))
            assert.are.equal(nil, BuildingUtils.getSmallRightNeighborBuildingOn40m(building6))

            assert.are.equal(nil, BuildingUtils.getSmallRightNeighborBuildingOn40m(building7))
        end)

        it('get small neighbor building on same platform (medium building)', function ()
            local station = initializeScenario()

            local building1 = station:initializeAndRegister(Slot.makeId({type = t.BUILDING, gridX = 0, gridY = 0, assetId = 3}))
            local building2 = station:initializeAndRegister(Slot.makeId({type = t.BUILDING, gridX = 0, gridY = 0, assetId = 6}))
            local building3 = station:initializeAndRegister(Slot.makeId({type = t.BUILDING, gridX = 0, gridY = 0, assetId = 5}))

            local building4 = station:initializeAndRegister(Slot.makeId({type = t.BUILDING, gridX = 0, gridY = 0, assetId = 15}))
            local building5 = station:initializeAndRegister(Slot.makeId({type = t.BUILDING, gridX = 0, gridY = 0, assetId = 18}))
            local building6 = station:initializeAndRegister(Slot.makeId({type = t.BUILDING, gridX = 0, gridY = 0, assetId = 17}))

            assert.is_nil(BuildingUtils.getSmallRightNeighborBuildingOn40m(building1))
            assert.are.equal(building1, BuildingUtils.getSmallRightNeighborBuildingOn40m(building2))
            assert.is_nil(BuildingUtils.getSmallRightNeighborBuildingOn40m(building3))

            assert.is_nil(BuildingUtils.getSmallRightNeighborBuildingOn40m(building4))
            assert.are.equal(building4, BuildingUtils.getSmallRightNeighborBuildingOn40m(building5))
            assert.is_nil(BuildingUtils.getSmallRightNeighborBuildingOn40m(building6))
        end)

        it('has small neighbor building at neighbor platform (medium building)', function ()
            local station = initializeScenario()

            local building1 = station:initializeAndRegister(Slot.makeId({type = t.BUILDING, gridX = 0, gridY = 0, assetId = 8}))
            local building2 = station:initializeAndRegister(Slot.makeId({type = t.BUILDING, gridX = 1, gridY = 0, assetId = 1}))
            local building3 = station:initializeAndRegister(Slot.makeId({type = t.BUILDING, gridX = -1, gridY = 0, assetId = 8}))

            local building4 = station:initializeAndRegister(Slot.makeId({type = t.BUILDING, gridX = 0, gridY = 0, assetId = 20}))
            local building5 = station:initializeAndRegister(Slot.makeId({type = t.BUILDING, gridX = -1, gridY = 0, assetId = 13}))
            local building6 = station:initializeAndRegister(Slot.makeId({type = t.BUILDING, gridX = 1, gridY = 0, assetId = 20}))

            assert.are.equal(building2, BuildingUtils.getSmallRightNeighborBuildingOn40m(building1))
            assert.are.equal(nil, BuildingUtils.getSmallRightNeighborBuildingOn40m(building2))
            assert.are.equal(nil, BuildingUtils.getSmallRightNeighborBuildingOn40m(building3))

            assert.are.equal(building5, BuildingUtils.getSmallRightNeighborBuildingOn40m(building4))
            assert.are.equal(nil, BuildingUtils.getSmallRightNeighborBuildingOn40m(building5))
            assert.are.equal(nil, BuildingUtils.getSmallRightNeighborBuildingOn40m(building6))
        end)

        it('get small neighbor building on same platform (large building)', function ()
            local station = initializeScenario()

            local building1 = station:initializeAndRegister(Slot.makeId({type = t.BUILDING, gridX = 0, gridY = 0, assetId = 4}))
            local building2 = station:initializeAndRegister(Slot.makeId({type = t.BUILDING, gridX = 0, gridY = 0, assetId = 9}))
            local building3 = station:initializeAndRegister(Slot.makeId({type = t.BUILDING, gridX = 0, gridY = 0, assetId = 10}))

            local building4 = station:initializeAndRegister(Slot.makeId({type = t.BUILDING, gridX = 0, gridY = 0, assetId = 16}))
            local building5 = station:initializeAndRegister(Slot.makeId({type = t.BUILDING, gridX = 0, gridY = 0, assetId = 21}))
            local building6 = station:initializeAndRegister(Slot.makeId({type = t.BUILDING, gridX = 0, gridY = 0, assetId = 22}))

            assert.are.equal(nil, BuildingUtils.getSmallRightNeighborBuildingOn40m(building1))
            assert.are.equal(building1, BuildingUtils.getSmallRightNeighborBuildingOn40m(building2))
            assert.are.equal(nil, BuildingUtils.getSmallRightNeighborBuildingOn40m(building3))

            assert.are.equal(nil, BuildingUtils.getSmallRightNeighborBuildingOn40m(building4))
            assert.are.equal(building4, BuildingUtils.getSmallRightNeighborBuildingOn40m(building5))
            assert.are.equal(nil, BuildingUtils.getSmallRightNeighborBuildingOn40m(building6))
        end)

        it('has small neighbor building at neighbor platform (large building)', function ()
            local station = initializeScenario()

            local building1 = station:initializeAndRegister(Slot.makeId({type = t.BUILDING, gridX = 0, gridY = 0, assetId = 12}))
            local building2 = station:initializeAndRegister(Slot.makeId({type = t.BUILDING, gridX = 1, gridY = 0, assetId = 2}))
            local building3 = station:initializeAndRegister(Slot.makeId({type = t.BUILDING, gridX = -1, gridY = 0, assetId = 12}))

            local building4 = station:initializeAndRegister(Slot.makeId({type = t.BUILDING, gridX = 0, gridY = 0, assetId = 24}))
            local building5 = station:initializeAndRegister(Slot.makeId({type = t.BUILDING, gridX = -1, gridY = 0, assetId = 14}))
            local building6 = station:initializeAndRegister(Slot.makeId({type = t.BUILDING, gridX = 1, gridY = 0, assetId = 24}))

            assert.are.equal(building2, BuildingUtils.getSmallRightNeighborBuildingOn40m(building1))
            assert.are.equal(nil, BuildingUtils.getSmallRightNeighborBuildingOn40m(building2))
            assert.are.equal(nil, BuildingUtils.getSmallRightNeighborBuildingOn40m(building3))

            assert.are.equal(building5, BuildingUtils.getSmallRightNeighborBuildingOn40m(building4))
            assert.are.equal(nil, BuildingUtils.getSmallRightNeighborBuildingOn40m(building5))
            assert.are.equal(nil, BuildingUtils.getSmallRightNeighborBuildingOn40m(building6))
        end)  
    end)

    describe('getMediumRightNeighborBuildingOn40m', function ()
        it('get medium neighbor building on same platform (small building)', function ()
            local station = initializeScenario()

            local building1 = station:initializeAndRegister(Slot.makeId({type = t.BUILDING, gridX = 0, gridY = 0, assetId = 1}))
            local building2 = station:initializeAndRegister(Slot.makeId({type = t.BUILDING, gridX = 0, gridY = 0, assetId = 7}))
            local building3 = station:initializeAndRegister(Slot.makeId({type = t.BUILDING, gridX = 0, gridY = 0, assetId = 13}))
            local building4 = station:initializeAndRegister(Slot.makeId({type = t.BUILDING, gridX = 0, gridY = 0, assetId = 19}))

            assert.are.equal(building2, BuildingUtils.getMediumRightNeighborBuildingOn40m(building1))
            assert.are.equal(nil, BuildingUtils.getMediumRightNeighborBuildingOn40m(building2))
            assert.are.equal(building4, BuildingUtils.getMediumRightNeighborBuildingOn40m(building3))
            assert.are.equal(nil, BuildingUtils.getMediumRightNeighborBuildingOn40m(building4))
        end)
        
        it('has medium neighbor building at neighbor platform (small building)', function ()
            local station = initializeScenario()

            local building1 = station:initializeAndRegister(Slot.makeId({type = t.BUILDING, gridX = 0, gridY = 0, assetId = 4}))
            local building2 = station:initializeAndRegister(Slot.makeId({type = t.BUILDING, gridX = 1, gridY = 0, assetId = 6}))
            local building3 = station:initializeAndRegister(Slot.makeId({type = t.BUILDING, gridX = -1, gridY = 0, assetId = 4}))

            local building4 = station:initializeAndRegister(Slot.makeId({type = t.BUILDING, gridX = 0, gridY = 0, assetId = 16}))
            local building5 = station:initializeAndRegister(Slot.makeId({type = t.BUILDING, gridX = -1, gridY = 0, assetId = 18}))
            local building6 = station:initializeAndRegister(Slot.makeId({type = t.BUILDING, gridX = 1, gridY = 0, assetId = 16}))

            assert.are.equal(building2, BuildingUtils.getMediumRightNeighborBuildingOn40m(building1))
            assert.are.equal(nil, BuildingUtils.getMediumRightNeighborBuildingOn40m(building2))
            assert.are.equal(nil, BuildingUtils.getMediumRightNeighborBuildingOn40m(building3))

            assert.are.equal(building5, BuildingUtils.getMediumRightNeighborBuildingOn40m(building4))
            assert.are.equal(nil, BuildingUtils.getMediumRightNeighborBuildingOn40m(building5))
            assert.are.equal(nil, BuildingUtils.getMediumRightNeighborBuildingOn40m(building6))
        end)

        it('get medium neighbor building on same platform (medium building)', function ()
            local station = initializeScenario()

            local building1 = station:initializeAndRegister(Slot.makeId({type = t.BUILDING, gridX = 0, gridY = 0, assetId = 5}))
            local building2 = station:initializeAndRegister(Slot.makeId({type = t.BUILDING, gridX = 0, gridY = 0, assetId = 7}))
            local building3 = station:initializeAndRegister(Slot.makeId({type = t.BUILDING, gridX = 0, gridY = 0, assetId = 18}))
            local building4 = station:initializeAndRegister(Slot.makeId({type = t.BUILDING, gridX = 0, gridY = 0, assetId = 20}))

            assert.are.equal(building2, BuildingUtils.getMediumRightNeighborBuildingOn40m(building1))
            assert.are.equal(nil, BuildingUtils.getMediumRightNeighborBuildingOn40m(building2))
            assert.are.equal(building4, BuildingUtils.getMediumRightNeighborBuildingOn40m(building3))
            assert.are.equal(nil, BuildingUtils.getMediumRightNeighborBuildingOn40m(building4))
        end)
        
        it('has medium neighbor building at neighbor platform (medium building)', function ()
            local station = initializeScenario()

            local building1 = station:initializeAndRegister(Slot.makeId({type = t.BUILDING, gridX = 0, gridY = 0, assetId = 7}))
            local building2 = station:initializeAndRegister(Slot.makeId({type = t.BUILDING, gridX = 1, gridY = 0, assetId = 5}))
            local building3 = station:initializeAndRegister(Slot.makeId({type = t.BUILDING, gridX = -1, gridY = 0, assetId = 7}))

            local building4 = station:initializeAndRegister(Slot.makeId({type = t.BUILDING, gridX = 0, gridY = 0, assetId = 20}))
            local building5 = station:initializeAndRegister(Slot.makeId({type = t.BUILDING, gridX = -1, gridY = 0, assetId = 18}))
            local building6 = station:initializeAndRegister(Slot.makeId({type = t.BUILDING, gridX = 1, gridY = 0, assetId = 20}))

            assert.are.equal(building2, BuildingUtils.getMediumRightNeighborBuildingOn40m(building1))
            assert.are.equal(nil, BuildingUtils.getMediumRightNeighborBuildingOn40m(building2))
            assert.are.equal(nil, BuildingUtils.getMediumRightNeighborBuildingOn40m(building3))

            assert.are.equal(building5, BuildingUtils.getMediumRightNeighborBuildingOn40m(building4))
            assert.are.equal(nil, BuildingUtils.getMediumRightNeighborBuildingOn40m(building5))
            assert.are.equal(nil, BuildingUtils.getMediumRightNeighborBuildingOn40m(building6))
        end)

        it('get medium neighbor building on same platform (large building)', function ()
            local station = initializeScenario()

            local building1 = station:initializeAndRegister(Slot.makeId({type = t.BUILDING, gridX = 0, gridY = 0, assetId = 9}))
            local building2 = station:initializeAndRegister(Slot.makeId({type = t.BUILDING, gridX = 0, gridY = 0, assetId = 8}))
            local building3 = station:initializeAndRegister(Slot.makeId({type = t.BUILDING, gridX = 0, gridY = 0, assetId = 21}))
            local building4 = station:initializeAndRegister(Slot.makeId({type = t.BUILDING, gridX = 0, gridY = 0, assetId = 20}))

            assert.are.equal(building2, BuildingUtils.getMediumRightNeighborBuildingOn40m(building1))
            assert.are.equal(nil, BuildingUtils.getMediumRightNeighborBuildingOn40m(building2))
            assert.are.equal(building4, BuildingUtils.getMediumRightNeighborBuildingOn40m(building3))
            assert.are.equal(nil, BuildingUtils.getMediumRightNeighborBuildingOn40m(building4))
        end)
        
        it('has medium neighbor building at neighbor platform (large building)', function ()
            local station = initializeScenario()

            local building1 = station:initializeAndRegister(Slot.makeId({type = t.BUILDING, gridX = 0, gridY = 0, assetId = 10}))
            local building2 = station:initializeAndRegister(Slot.makeId({type = t.BUILDING, gridX = 1, gridY = 0, assetId = 5}))
            local building3 = station:initializeAndRegister(Slot.makeId({type = t.BUILDING, gridX = -1, gridY = 0, assetId = 10}))

            local building4 = station:initializeAndRegister(Slot.makeId({type = t.BUILDING, gridX = 0, gridY = 0, assetId = 24}))
            local building5 = station:initializeAndRegister(Slot.makeId({type = t.BUILDING, gridX = -1, gridY = 0, assetId = 19}))
            local building6 = station:initializeAndRegister(Slot.makeId({type = t.BUILDING, gridX = 1, gridY = 0, assetId = 24}))

            assert.are.equal(building2, BuildingUtils.getMediumRightNeighborBuildingOn40m(building1))
            assert.are.equal(nil, BuildingUtils.getMediumRightNeighborBuildingOn40m(building2))
            assert.are.equal(nil, BuildingUtils.getMediumRightNeighborBuildingOn40m(building3))

            assert.are.equal(building5, BuildingUtils.getMediumRightNeighborBuildingOn40m(building4))
            assert.are.equal(nil, BuildingUtils.getMediumRightNeighborBuildingOn40m(building5))
            assert.are.equal(nil, BuildingUtils.getMediumRightNeighborBuildingOn40m(building6))
        end)
    end)

    describe('getLargeRightNeighborBuildingOn40m', function ()
        it('get large neighbor building on same platform (small building)', function ()
            local station = initializeScenario()

            local building1 = station:initializeAndRegister(Slot.makeId({type = t.BUILDING, gridX = 0, gridY = 0, assetId = 1}))
            local building2 = station:initializeAndRegister(Slot.makeId({type = t.BUILDING, gridX = 0, gridY = 0, assetId = 12}))
            local building3 = station:initializeAndRegister(Slot.makeId({type = t.BUILDING, gridX = 0, gridY = 0, assetId = 13}))
            local building4 = station:initializeAndRegister(Slot.makeId({type = t.BUILDING, gridX = 0, gridY = 0, assetId = 24}))

            assert.are.equal(building2, BuildingUtils.getLargeRightNeighborBuildingOn40m(building1))
            assert.are.equal(nil, BuildingUtils.getLargeRightNeighborBuildingOn40m(building2))
            assert.are.equal(building4, BuildingUtils.getLargeRightNeighborBuildingOn40m(building3))
            assert.are.equal(nil, BuildingUtils.getLargeRightNeighborBuildingOn40m(building4))
        end)
        
        it('has large neighbor building at neighbor platform (small building)', function ()
            local station = initializeScenario()

            local building1 = station:initializeAndRegister(Slot.makeId({type = t.BUILDING, gridX = 0, gridY = 0, assetId = 2}))
            local building2 = station:initializeAndRegister(Slot.makeId({type = t.BUILDING, gridX = 1, gridY = 0, assetId = 9}))
            local building3 = station:initializeAndRegister(Slot.makeId({type = t.BUILDING, gridX = -1, gridY = 0, assetId = 2}))

            local building4 = station:initializeAndRegister(Slot.makeId({type = t.BUILDING, gridX = 0, gridY = 0, assetId = 15}))
            local building5 = station:initializeAndRegister(Slot.makeId({type = t.BUILDING, gridX = -1, gridY = 0, assetId = 22}))
            local building6 = station:initializeAndRegister(Slot.makeId({type = t.BUILDING, gridX = 1, gridY = 0, assetId = 15}))

            assert.are.equal(building2, BuildingUtils.getLargeRightNeighborBuildingOn40m(building1))
            assert.are.equal(nil, BuildingUtils.getLargeRightNeighborBuildingOn40m(building2))
            assert.are.equal(nil, BuildingUtils.getLargeRightNeighborBuildingOn40m(building3))

            assert.are.equal(building5, BuildingUtils.getLargeRightNeighborBuildingOn40m(building4))
            assert.are.equal(nil, BuildingUtils.getLargeRightNeighborBuildingOn40m(building5))
            assert.are.equal(nil, BuildingUtils.getLargeRightNeighborBuildingOn40m(building6))
        end)

        it('get large neighbor building on same platform (medium building)', function ()
            local station = initializeScenario()

            local building1 = station:initializeAndRegister(Slot.makeId({type = t.BUILDING, gridX = 0, gridY = 0, assetId = 5}))
            local building2 = station:initializeAndRegister(Slot.makeId({type = t.BUILDING, gridX = 0, gridY = 0, assetId = 12}))
            local building3 = station:initializeAndRegister(Slot.makeId({type = t.BUILDING, gridX = 0, gridY = 0, assetId = 17}))
            local building4 = station:initializeAndRegister(Slot.makeId({type = t.BUILDING, gridX = 0, gridY = 0, assetId = 24}))

            assert.are.equal(building2, BuildingUtils.getLargeRightNeighborBuildingOn40m(building1))
            assert.are.equal(nil, BuildingUtils.getLargeRightNeighborBuildingOn40m(building2))
            assert.are.equal(building4, BuildingUtils.getLargeRightNeighborBuildingOn40m(building3))
            assert.are.equal(nil, BuildingUtils.getLargeRightNeighborBuildingOn40m(building4))
        end)
        
        it('has large neighbor building at neighbor platform (medium building)', function ()
            local station = initializeScenario()

            local building1 = station:initializeAndRegister(Slot.makeId({type = t.BUILDING, gridX = 0, gridY = 0, assetId = 6}))
            local building2 = station:initializeAndRegister(Slot.makeId({type = t.BUILDING, gridX = 1, gridY = 0, assetId = 9}))
            local building3 = station:initializeAndRegister(Slot.makeId({type = t.BUILDING, gridX = -1, gridY = 0, assetId = 6}))

            local building4 = station:initializeAndRegister(Slot.makeId({type = t.BUILDING, gridX = 0, gridY = 0, assetId = 20}))
            local building5 = station:initializeAndRegister(Slot.makeId({type = t.BUILDING, gridX = -1, gridY = 0, assetId = 23}))
            local building6 = station:initializeAndRegister(Slot.makeId({type = t.BUILDING, gridX = 1, gridY = 0, assetId = 20}))

            assert.are.equal(building2, BuildingUtils.getLargeRightNeighborBuildingOn40m(building1))
            assert.are.equal(nil, BuildingUtils.getLargeRightNeighborBuildingOn40m(building2))
            assert.are.equal(nil, BuildingUtils.getLargeRightNeighborBuildingOn40m(building3))

            assert.are.equal(building5, BuildingUtils.getLargeRightNeighborBuildingOn40m(building4))
            assert.are.equal(nil, BuildingUtils.getLargeRightNeighborBuildingOn40m(building5))
            assert.are.equal(nil, BuildingUtils.getLargeRightNeighborBuildingOn40m(building6))
        end)

        it('has large neighbor building at neighbor platform (large building)', function ()
            local station = initializeScenario()

            local building1 = station:initializeAndRegister(Slot.makeId({type = t.BUILDING, gridX = 0, gridY = 0, assetId = 9}))
            local building2 = station:initializeAndRegister(Slot.makeId({type = t.BUILDING, gridX = 1, gridY = 0, assetId = 9}))
            local building3 = station:initializeAndRegister(Slot.makeId({type = t.BUILDING, gridX = -1, gridY = 0, assetId = 10}))

            local building4 = station:initializeAndRegister(Slot.makeId({type = t.BUILDING, gridX = 0, gridY = 0, assetId = 22}))
            local building5 = station:initializeAndRegister(Slot.makeId({type = t.BUILDING, gridX = -1, gridY = 0, assetId = 22}))
            local building6 = station:initializeAndRegister(Slot.makeId({type = t.BUILDING, gridX = 1, gridY = 0, assetId = 23}))

            assert.are.equal(building2, BuildingUtils.getLargeRightNeighborBuildingOn40m(building1))
            assert.are.equal(nil, BuildingUtils.getLargeRightNeighborBuildingOn40m(building2))
            assert.are.equal(nil, BuildingUtils.getLargeRightNeighborBuildingOn40m(building3))

            assert.are.equal(building5, BuildingUtils.getLargeRightNeighborBuildingOn40m(building4))
            assert.are.equal(nil, BuildingUtils.getLargeRightNeighborBuildingOn40m(building5))
            assert.are.equal(nil, BuildingUtils.getLargeRightNeighborBuildingOn40m(building6))
        end)
    end)

    describe('buildingIsInGroup', function ()
        it('it checks whether building is in group', function ()
            local station = initializeScenario()
            station:initializeAndRegister(Slot.makeId({type = t.BUILDING, gridX = 0, gridY = 0, assetId = 12}))
            local building1 = station:register(Slot.makeId({type = t.BUILDING, gridX = 0, gridY = 0, assetId = 12}), {groups = {'group1', 'group2'}})

            assert.is_true(BuildingUtils.buildingIsInGroup(building1, {'group1'}))
            assert.is_true(BuildingUtils.buildingIsInGroup(building1, {'group2'}))
            assert.is_false(BuildingUtils.buildingIsInGroup(building1, {'group3'}))
            assert.is_true(BuildingUtils.buildingIsInGroup(building1, {'group3', 'group2'}))
            assert.is_false(BuildingUtils.buildingIsInGroup(building1, {'group3', 'group4'}))
        end)

        it('returns false when building is nil', function ()
            assert.is_false(BuildingUtils.buildingIsInGroup(nil, 'group1'))
        end)
    end)

    describe('makeConnectableBuilding', function ()
        local station = initializeScenario()
        station:initializeAndRegister(Slot.makeId({type = t.PLATFORM, gridX = -3, gridY = 0}))
        station:initializeAndRegister(Slot.makeId({type = t.PLATFORM, gridX = -2, gridY = 0}))
        station:initializeAndRegister(Slot.makeId({type = t.PLATFORM, gridX = 2, gridY = 0}))
        station:initializeAndRegister(Slot.makeId({type = t.PLATFORM, gridX = 3, gridY = 0}))

        station:initializeAndRegister(Slot.makeId({type = t.BUILDING, gridX = -2, gridY = 0, assetId = 12}))
        local building1 = station:register(Slot.makeId({type = t.BUILDING, gridX = -2, gridY = 0, assetId = 12}), {groups = {'group1'}})

        station:initializeAndRegister(Slot.makeId({type = t.BUILDING, gridX = -1, gridY = 0, assetId = 2}))
        local building2 = station:register(Slot.makeId({type = t.BUILDING, gridX = -1, gridY = 0, assetId = 2}), {groups = {'group1'}})

        station:initializeAndRegister(Slot.makeId({type = t.BUILDING, gridX = -1, gridY = 0, assetId = 8}))
        local building3 = station:register(Slot.makeId({type = t.BUILDING, gridX = -1, gridY = 0, assetId = 8}), {groups = {'group1'}})

        station:initializeAndRegister(Slot.makeId({type = t.BUILDING, gridX = 0, gridY = 0, assetId = 11}))
        local building4 = station:register(Slot.makeId({type = t.BUILDING, gridX = 0, gridY = 0, assetId = 11}), {groups = {'group1'}})

        station:initializeAndRegister(Slot.makeId({type = t.BUILDING, gridX = 1, gridY = 0, assetId = 6}))
        local building5 = station:register(Slot.makeId({type = t.BUILDING, gridX = 1, gridY = 0, assetId = 6}), {groups = {'group1'}})

        station:initializeAndRegister(Slot.makeId({type = t.BUILDING, gridX = 1, gridY = 0, assetId = 3}))
        local building6 = station:register(Slot.makeId({type = t.BUILDING, gridX = 1, gridY = 0, assetId = 3}), {groups = {'group1'}})

        station:initializeAndRegister(Slot.makeId({type = t.BUILDING, gridX = 2, gridY = 0, assetId = 10}))
        local building7 = station:register(Slot.makeId({type = t.BUILDING, gridX = 2, gridY = 0, assetId = 10}), {groups = {'group1'}})

        local models = {
            mainBuilding = "main_building.mdl",
            connectionToLeftSmallBuilding = "con_left_small.mdl",
            connectionToLeftMediumBuilding = "con_left_medium.mdl",
            connectionToLeftLargeBuilding = "con_left_large.mdl",
            connectionToRightSmallBuilding = "con_right_small.mdl",
            connectionToRightMediumBuilding = "con_right_medium.mdl",
            connectionToRightLargeBuilding = "con_right_large.mdl",
            endingLeft = "ending_left.mdl",
            endingRight = "ending_right.mdl",
        }

        local result = {
            models = {}
        }
        local transform = {
            1, 0, 0, 0,
            0, 1, 0, 0,
            0, 0, 1, 0,
            0, 0, 0, 1,
        }

        BuildingUtils.makeConnectableBuilding(building1, result, models, transform, 'katze')
        
        assert.are.same({
            {
                id = "main_building.mdl",
                transf = transform,
                tag = "katze",
            }, {
                id = "ending_left.mdl",
                transf = transform,
                tag = "katze",
            }, {
                id = "con_right_small.mdl",
                transf = transform,
                tag = "katze",
            }
        }, result.models)

        result.models = {}
        BuildingUtils.makeConnectableBuilding(building2, result, models, transform)

        assert.are.same({
            {
                id = "main_building.mdl",
                transf = transform
            }, {
                id = "con_left_large.mdl",
                transf = transform
            }, {
                id = "con_right_medium.mdl",
                transf = transform
            }
        }, result.models)

        result.models = {}
        BuildingUtils.makeConnectableBuilding(building3, result, models, transform)

        assert.are.same({
            {
                id = "main_building.mdl",
                transf = transform
            }, {
                id = "con_left_small.mdl",
                transf = transform
            }, {
                id = "con_right_large.mdl",
                transf = transform
            }
        }, result.models)

        result.models = {}
        BuildingUtils.makeConnectableBuilding(building4, result, models, transform)

        assert.are.same({
            {
                id = "main_building.mdl",
                transf = transform
            }, {
                id = "con_left_medium.mdl",
                transf = transform
            }, {
                id = "con_right_medium.mdl",
                transf = transform
            }
        }, result.models)

        result.models = {}
        BuildingUtils.makeConnectableBuilding(building5, result, models, transform)

        assert.are.same({
            {
                id = "main_building.mdl",
                transf = transform
            }, {
                id = "con_left_large.mdl",
                transf = transform
            }, {
                id = "con_right_small.mdl",
                transf = transform
            }
        }, result.models)

        result.models = {}
        BuildingUtils.makeConnectableBuilding(building6, result, models, transform)

        assert.are.same({
            {
                id = "main_building.mdl",
                transf = transform
            }, {
                id = "con_left_medium.mdl",
                transf = transform
            }, {
                id = "con_right_large.mdl",
                transf = transform
            }
        }, result.models)

        result.models = {}
        BuildingUtils.makeConnectableBuilding(building7, result, models, transform)

        assert.are.same({
            {
                id = "main_building.mdl",
                transf = transform
            }, {
                id = "con_left_small.mdl",
                transf = transform
            }, {
                id = "ending_right.mdl",
                transf = transform
            }
        }, result.models)
    end)

    describe('makeLot', function ()
        it('makes ground (terrain alignment and ground faces and colliders)', function ()
            local result = {
                groundFaces = {},
                terrainAlignmentLists = {},
                colliders = {}
            }

            local box = Box:new({ -6, -17, 0 }, { 6, 0, 4 })
            local forecourt = Box:new({ -6, 0, 0 }, { 6, 2, 4 })

            local matrix = {
                1, 0, 0, 0,
                0, 1, 0, 0,
                0, 0, 1, 0,
                0, 0, 0, 1
            }

            BuildingUtils.makeLot(result, box, matrix)

            assert.are.same({{ 
                type = "BOX",
                transf = transf.mul(matrix, transf.transl(box:getCenterPointAsVec3())),
                params = {
                    halfExtents = box:getHalfExtends(),
                }
            }}, result.colliders)

            assert.are.same({{
                face = box:getGroundFace(),
                modes = {
                    {
                        type = "FILL",
                        key = "shared/asphalt_01.gtex.lua"
                    },
                    {
                        type = "STROKE_OUTER",
                        key = "street_border.lua"
                    },
                },
            }, {
                face = forecourt:getGroundFace(),
                modes = {
                    {
                        type = "FILL",
                        key = "shared/gravel_03.gtex.lua"
                    },
                    {
                        type = "STROKE_OUTER",
                        key = "street_border.lua"
                    },
                },
            }}, result.groundFaces)

            assert.are.same({
                { type = "EQUAL", faces = { box:getGroundFace() } },
            }, result.terrainAlignmentLists)
        end)

        it('makes ground (terrain alignment and ground faces and colliders) with custom ground faces', function ()
            local result = {
                groundFaces = {},
                terrainAlignmentLists = {},
                colliders = {}
            }

            local box = Box:new({ -6, -17, 0 }, { 6, 0, 4 })
            local forecourt = Box:new({ -6, 0, 0 }, { 6, 2, 4 })

            local matrix = {
                1, 0, 0, 0,
                0, 1, 0, 0,
                0, 0, 1, 0,
                0, 0, 0, 1
            }

            BuildingUtils.makeLot(result, box, matrix, {
                mainFill = "main_fill.lua",
                mainStroke = "main_stroke.lua",
                forecourtFill = "forecourt_fill.lua",
                forecourtStroke = "forecourt_stroke.lua"
            })

            assert.are.same({{ 
                type = "BOX",
                transf = transf.mul(matrix, transf.transl(box:getCenterPointAsVec3())),
                params = {
                    halfExtents = box:getHalfExtends(),
                }
            }}, result.colliders)

            assert.are.same({{
                face = box:getGroundFace(),
                modes = {
                    {
                        type = "FILL",
                        key = "main_fill.lua"
                    },
                    {
                        type = "STROKE_OUTER",
                        key = "main_stroke.lua"
                    },
                },
            }, {
                face = forecourt:getGroundFace(),
                modes = {
                    {
                        type = "FILL",
                        key = "forecourt_fill.lua"
                    },
                    {
                        type = "STROKE_OUTER",
                        key = "forecourt_stroke.lua"
                    },
                },
            }}, result.groundFaces)

            assert.are.same({
                { type = "EQUAL", faces = { box:getGroundFace() } },
            }, result.terrainAlignmentLists)
        end)
    end)

end)