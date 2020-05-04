local Station = require('motras_station')
local Slot = require('motras_slot')
local PathUtils = require('motras_pathutils')
local t = require('motras_types')
local c = require('motras_constants')

local UnderpassEntry = require('motras_underpass_entry')

describe('UnderpassEntry', function ()
    describe('isMainEntry', function ()
        it ('is main entry, when entry is the only one (Scenario 1)', function ()
            local station = Station:new{}
            station:initializeAndRegister(Slot.makeId({type = t.PLATFORM, gridX = 0, gridY = 0}))
            local underpassModule = station:initializeAndRegister(Slot.makeId({type = t.UNDERPASS, gridX = 0, gridY = 0, assetId = 28}))

            local underpassEntry = UnderpassEntry:new{underpassModule = underpassModule}
            assert.is_true(underpassEntry:isMainEntry())
        end)

        it ('is main entry, when entry is the only one (Scenario 2)', function ()
            local station = Station:new{}
            station:initializeAndRegister(Slot.makeId({type = t.PLATFORM, gridX = 0, gridY = 0}))
            local underpassModule = station:initializeAndRegister(Slot.makeId({type = t.UNDERPASS, gridX = 0, gridY = 0, assetId = 27}))

            local underpassEntry = UnderpassEntry:new{underpassModule = underpassModule}
            assert.is_true(underpassEntry:isMainEntry())
        end)

        it ('is main entry, when entry is the only one (Scenario 3)', function ()
            local station = Station:new{}
            station:initializeAndRegister(Slot.makeId({type = t.PLATFORM, gridX = 0, gridY = 0}))
            local underpassModule = station:initializeAndRegister(Slot.makeId({type = t.UNDERPASS, gridX = 0, gridY = 0, assetId = 31}))

            local underpassEntry = UnderpassEntry:new{underpassModule = underpassModule}
            assert.is_true(underpassEntry:isMainEntry())
        end)

        it ('is main entry, when entry is the only one (Scenario 4)', function ()
            local station = Station:new{}
            station:initializeAndRegister(Slot.makeId({type = t.PLATFORM, gridX = 0, gridY = 0}))
            local underpassModule = station:initializeAndRegister(Slot.makeId({type = t.UNDERPASS, gridX = 0, gridY = 0, assetId = 32}))

            local underpassEntry = UnderpassEntry:new{underpassModule = underpassModule}
            assert.is_true(underpassEntry:isMainEntry())
        end)

        it ('is main entry when entry is in position 1 or 2 (Scenario 1)', function ()
            local station = Station:new{}
            station:initializeAndRegister(Slot.makeId({type = t.PLATFORM, gridX = 0, gridY = 0}))
            local underpassModule = station:initializeAndRegister(Slot.makeId({type = t.UNDERPASS, gridX = 0, gridY = 0, assetId = 25}))
            local underpassModule2 = station:initializeAndRegister(Slot.makeId({type = t.UNDERPASS, gridX = 0, gridY = 0, assetId = 28}))

            local underpassEntry1 = UnderpassEntry:new{underpassModule = underpassModule}
            local underpassEntry2 = UnderpassEntry:new{underpassModule = underpassModule2}

            assert.is_true(underpassEntry1:isMainEntry())
            assert.is_false(underpassEntry2:isMainEntry())
        end)

        it ('is main entry when entry is in position 1 or 2 (Scenario 2)', function ()
            local station = Station:new{}
            station:initializeAndRegister(Slot.makeId({type = t.PLATFORM, gridX = 0, gridY = 0}))
            local underpassModule = station:initializeAndRegister(Slot.makeId({type = t.UNDERPASS, gridX = 0, gridY = 0, assetId = 29}))
            local underpassModule2 = station:initializeAndRegister(Slot.makeId({type = t.UNDERPASS, gridX = 0, gridY = 0, assetId = 28}))

            local underpassEntry1 = UnderpassEntry:new{underpassModule = underpassModule}
            local underpassEntry2 = UnderpassEntry:new{underpassModule = underpassModule2}

            assert.is_true(underpassEntry1:isMainEntry())
            assert.is_false(underpassEntry2:isMainEntry())
        end)

        it ('is main entry when entry is in position 1 or 2 (Scenario 3)', function ()
            local station = Station:new{}
            station:initializeAndRegister(Slot.makeId({type = t.PLATFORM, gridX = 0, gridY = 0}))
            station:initializeAndRegister(Slot.makeId({type = t.PLATFORM, gridX = -1, gridY = 0}))
            local underpassModule = station:initializeAndRegister(Slot.makeId({type = t.UNDERPASS, gridX = -1, gridY = 0, assetId = 27}))
            local underpassModule2 = station:initializeAndRegister(Slot.makeId({type = t.UNDERPASS, gridX = 0, gridY = 0, assetId = 26}))

            local underpassEntry1 = UnderpassEntry:new{underpassModule = underpassModule}
            local underpassEntry2 = UnderpassEntry:new{underpassModule = underpassModule2}

            assert.is_true(underpassEntry2:isMainEntry())
            assert.is_false(underpassEntry1:isMainEntry())
        end)

        it ('is main entry when entry is in position 1 or 2 (Scenario 4)', function ()
            local station = Station:new{}
            station:initializeAndRegister(Slot.makeId({type = t.PLATFORM, gridX = 0, gridY = 0}))
            station:initializeAndRegister(Slot.makeId({type = t.PLATFORM, gridX = -1, gridY = 0}))
            local underpassModule = station:initializeAndRegister(Slot.makeId({type = t.UNDERPASS, gridX = -1, gridY = 0, assetId = 27}))
            local underpassModule2 = station:initializeAndRegister(Slot.makeId({type = t.UNDERPASS, gridX = 0, gridY = 0, assetId = 30}))

            local underpassEntry1 = UnderpassEntry:new{underpassModule = underpassModule}
            local underpassEntry2 = UnderpassEntry:new{underpassModule = underpassModule2}

            assert.is_true(underpassEntry2:isMainEntry())
            assert.is_false(underpassEntry1:isMainEntry())
        end)

        it ('is main entry when entry is in position 1 or 2 (Scenario 5)', function ()
            local station = Station:new{}
            station:initializeAndRegister(Slot.makeId({type = t.PLATFORM, gridX = 0, gridY = 0}))
            station:initializeAndRegister(Slot.makeId({type = t.PLATFORM, gridX = -1, gridY = 0}))
            local underpassModule = station:initializeAndRegister(Slot.makeId({type = t.UNDERPASS, gridX = -1, gridY = 0, assetId = 31}))
            local underpassModule2 = station:initializeAndRegister(Slot.makeId({type = t.UNDERPASS, gridX = 0, gridY = 0, assetId = 30}))

            local underpassEntry1 = UnderpassEntry:new{underpassModule = underpassModule}
            local underpassEntry2 = UnderpassEntry:new{underpassModule = underpassModule2}

            assert.is_true(underpassEntry2:isMainEntry())
            assert.is_false(underpassEntry1:isMainEntry())
        end)
    end)

    describe('getOppositeEntry/hasOppositeEntry', function ()
        it('returns nil when no opposite entry exists', function ()
            local station = Station:new{}
            station:initializeAndRegister(Slot.makeId({type = t.PLATFORM, gridX = 0, gridY = 0}))
            local underpassModule = station:initializeAndRegister(Slot.makeId({type = t.UNDERPASS, gridX = 0, gridY = 0, assetId = 25}))
            local underpassEntry1 = UnderpassEntry:new{underpassModule = underpassModule}

            assert.is_false(underpassEntry1:hasOppositeEntry())
            assert.is_nil(underpassEntry1:getOppositeEntry())
        end)

        it('returns opposite entry (screnario 1)', function ()
            local station = Station:new{}
            station:initializeAndRegister(Slot.makeId({type = t.PLATFORM, gridX = 0, gridY = 0}))
            local underpassModule = station:initializeAndRegister(Slot.makeId({type = t.UNDERPASS, gridX = 0, gridY = 0, assetId = 25}))
            local underpassModule2 = station:initializeAndRegister(Slot.makeId({type = t.UNDERPASS, gridX = 0, gridY = 0, assetId = 28}))

            local underpassEntry1 = UnderpassEntry:new{underpassModule = underpassModule}

            assert.is_true(underpassEntry1:hasOppositeEntry())
            assert.are.equal(underpassModule2, underpassEntry1:getOppositeEntry():getModule())
        end)

        it('returns opposite entry (screnario 2)', function ()
            local station = Station:new{}
            station:initializeAndRegister(Slot.makeId({type = t.PLATFORM, gridX = 0, gridY = 0}))
            local underpassModule = station:initializeAndRegister(Slot.makeId({type = t.UNDERPASS, gridX = 0, gridY = 0, assetId = 25}))
            local underpassModule2 = station:initializeAndRegister(Slot.makeId({type = t.UNDERPASS, gridX = 0, gridY = 0, assetId = 32}))

            local underpassEntry1 = UnderpassEntry:new{underpassModule = underpassModule}

            assert.is_true(underpassEntry1:hasOppositeEntry())
            assert.are.equal(underpassModule2, underpassEntry1:getOppositeEntry():getModule())
        end)

        it('returns opposite entry (screnario 3)', function ()
            local station = Station:new{}
            station:initializeAndRegister(Slot.makeId({type = t.PLATFORM, gridX = 0, gridY = 0}))
            local underpassModule = station:initializeAndRegister(Slot.makeId({type = t.UNDERPASS, gridX = 0, gridY = 0, assetId = 29}))
            local underpassModule2 = station:initializeAndRegister(Slot.makeId({type = t.UNDERPASS, gridX = 0, gridY = 0, assetId = 32}))

            local underpassEntry1 = UnderpassEntry:new{underpassModule = underpassModule}

            assert.is_true(underpassEntry1:hasOppositeEntry())
            assert.are.equal(underpassModule2, underpassEntry1:getOppositeEntry():getModule())
        end)

        it('returns opposite entry (screnario 4)', function ()
            local station = Station:new{}
            station:initializeAndRegister(Slot.makeId({type = t.PLATFORM, gridX = 0, gridY = 0}))
            local underpassModule = station:initializeAndRegister(Slot.makeId({type = t.UNDERPASS, gridX = 0, gridY = 0, assetId = 29}))
            local underpassModule2 = station:initializeAndRegister(Slot.makeId({type = t.UNDERPASS, gridX = 0, gridY = 0, assetId = 28}))

            local underpassEntry1 = UnderpassEntry:new{underpassModule = underpassModule}

            assert.is_true(underpassEntry1:hasOppositeEntry())
            assert.are.equal(underpassModule2, underpassEntry1:getOppositeEntry():getModule())
        end)

        it('returns opposite entry (screnario 5)', function ()
            local station = Station:new{}
            station:initializeAndRegister(Slot.makeId({type = t.PLATFORM, gridX = 0, gridY = 0}))
            station:initializeAndRegister(Slot.makeId({type = t.PLATFORM, gridX = -1, gridY = 0}))
            local underpassModule = station:initializeAndRegister(Slot.makeId({type = t.UNDERPASS, gridX = -1, gridY = 0, assetId = 31}))
            local underpassModule2 = station:initializeAndRegister(Slot.makeId({type = t.UNDERPASS, gridX = 0, gridY = 0, assetId = 30}))

            local underpassEntry1 = UnderpassEntry:new{underpassModule = underpassModule}

            assert.is_true(underpassEntry1:hasOppositeEntry())
            assert.are.equal(underpassModule2, underpassEntry1:getOppositeEntry():getModule())
        end)

        it('returns opposite entry (screnario 5)', function ()
            local station = Station:new{}
            station:initializeAndRegister(Slot.makeId({type = t.PLATFORM, gridX = 0, gridY = 0}))
            station:initializeAndRegister(Slot.makeId({type = t.PLATFORM, gridX = -1, gridY = 0}))
            local underpassModule = station:initializeAndRegister(Slot.makeId({type = t.UNDERPASS, gridX = -1, gridY = 0, assetId = 31}))
            local underpassModule2 = station:initializeAndRegister(Slot.makeId({type = t.UNDERPASS, gridX = 0, gridY = 0, assetId = 26}))

            local underpassEntry1 = UnderpassEntry:new{underpassModule = underpassModule}

            assert.is_true(underpassEntry1:hasOppositeEntry())
            assert.are.equal(underpassModule2, underpassEntry1:getOppositeEntry():getModule())
        end)
    end)

    describe('getLaneXPosition', function ()
        it('returns lane x position (scenario 1)', function ()
            local station = Station:new{}
            station:initializeAndRegister(Slot.makeId({type = t.PLATFORM, gridX = 0, gridY = 0}))
            local underpassModule = station:initializeAndRegister(Slot.makeId({type = t.UNDERPASS, gridX = 0, gridY = 0, assetId = 25}))

            local underpassEntry1 = UnderpassEntry:new{underpassModule = underpassModule}
            assert.are.equal(0, underpassEntry1:getLaneXPosition())
        end)

        it('returns lane x position (scenario 2)', function ()
            local station = Station:new{}
            station:initializeAndRegister(Slot.makeId({type = t.PLATFORM, gridX = 0, gridY = 0}))
            local underpassModule = station:initializeAndRegister(Slot.makeId({type = t.UNDERPASS, gridX = 0, gridY = 0, assetId = 26}))

            local underpassEntry1 = UnderpassEntry:new{underpassModule = underpassModule}
            assert.are.equal(-c.DEFAULT_HORIZONTAL_GRID_DISTANCE / 2, underpassEntry1:getLaneXPosition())
        end)

        it('returns lane x position (scenario 3)', function ()
            local station = Station:new{}
            station:initializeAndRegister(Slot.makeId({type = t.PLATFORM, gridX = 0, gridY = 0}))
            local underpassModule = station:initializeAndRegister(Slot.makeId({type = t.UNDERPASS, gridX = 0, gridY = 0, assetId = 27}))

            local underpassEntry1 = UnderpassEntry:new{underpassModule = underpassModule}
            assert.are.equal(c.DEFAULT_HORIZONTAL_GRID_DISTANCE / 2, underpassEntry1:getLaneXPosition())
        end)

        it('returns lane x position (scenario 4)', function ()
            local station = Station:new{}
            station:initializeAndRegister(Slot.makeId({type = t.PLATFORM, gridX = 0, gridY = 0}))
            local underpassModule = station:initializeAndRegister(Slot.makeId({type = t.UNDERPASS, gridX = 0, gridY = 0, assetId = 28}))

            local underpassEntry1 = UnderpassEntry:new{underpassModule = underpassModule}
            assert.are.equal(0, underpassEntry1:getLaneXPosition())
        end)
    end)

    describe('getLaneStartPoint', function ()
        it('returns lane start point (scenario 1)', function ()
            local station = Station:new{}
            local platform = station:initializeAndRegister(Slot.makeId({type = t.PLATFORM, gridX = 0, gridY = 0}))
            local underpassModule = station:initializeAndRegister(Slot.makeId({type = t.UNDERPASS, gridX = 0, gridY = 0, assetId = 31}))

            local underpassEntry1 = UnderpassEntry:new{underpassModule = underpassModule}

            assert.are.same({
                x = c.DEFAULT_HORIZONTAL_GRID_DISTANCE / 2,
                y = -c.DEFAULT_VERTICAL_GRID_DISTANCE / 2,
                z = platform:getAbsolutePlatformHeight()
            }, underpassEntry1:getLaneStartPoint())
        end)

        it('returns lane start point (scenario 2)', function ()
            local station = Station:new{}
            local platform = station:initializeAndRegister(Slot.makeId({type = t.PLATFORM, gridX = 0, gridY = 0}))
            local underpassModule = station:initializeAndRegister(Slot.makeId({type = t.UNDERPASS, gridX = 0, gridY = 0, assetId = 30}))

            local underpassEntry1 = UnderpassEntry:new{underpassModule = underpassModule}

            assert.are.same({
                x = -c.DEFAULT_HORIZONTAL_GRID_DISTANCE / 2,
                y = -c.DEFAULT_VERTICAL_GRID_DISTANCE / 2,
                z = platform:getAbsolutePlatformHeight()
            }, underpassEntry1:getLaneStartPoint())
        end)

        it('returns lane start point (scenario 3)', function ()
            local station = Station:new{}
            station:initializeAndRegister(Slot.makeId({type = t.PLATFORM, gridX = 0, gridY = 0}))
            station:initializeAndRegister(Slot.makeId({type = t.UNDERPASS, gridX = 0, gridY = 0, assetId = 29}))
            local underpassModule = station:initializeAndRegister(Slot.makeId({type = t.UNDERPASS, gridX = 0, gridY = 0, assetId = 32}))

            local underpassEntry1 = UnderpassEntry:new{underpassModule = underpassModule}

            assert.are.equal(-c.DEFAULT_VERTICAL_GRID_DISTANCE / 2, underpassEntry1:getLaneStartPoint().y)
        end)

        it('returns lane start point (scenario 4)', function ()
            local station = Station:new{}
            station:initializeAndRegister(Slot.makeId({type = t.PLATFORM, gridX = 0, gridY = 0}))
            station:initializeAndRegister(Slot.makeId({type = t.UNDERPASS, gridX = 0, gridY = 0, assetId = 25}))
            local underpassModule = station:initializeAndRegister(Slot.makeId({type = t.UNDERPASS, gridX = 0, gridY = 0, assetId = 32}))

            local underpassEntry1 = UnderpassEntry:new{underpassModule = underpassModule}

            assert.are.equal(0, underpassEntry1:getLaneStartPoint().y)
        end)

        it('returns lane start point (scenario 5)', function ()
            local station = Station:new{}
            station:initializeAndRegister(Slot.makeId({type = t.PLATFORM, gridX = 0, gridY = 0}))
            station:initializeAndRegister(Slot.makeId({type = t.UNDERPASS, gridX = 0, gridY = 0, assetId = 29}))
            local underpassModule = station:initializeAndRegister(Slot.makeId({type = t.UNDERPASS, gridX = 0, gridY = 0, assetId = 28}))

            local underpassEntry1 = UnderpassEntry:new{underpassModule = underpassModule}

            assert.are.equal(0, underpassEntry1:getLaneStartPoint().y)
        end)
    end)

    describe('getLaneEndPoint', function ()
        it('returns lane end point (scenario 1)', function ()
            local station = Station:new{}
            local platform = station:initializeAndRegister(Slot.makeId({type = t.PLATFORM, gridX = 0, gridY = 0}))
            local underpassModule = station:initializeAndRegister(Slot.makeId({type = t.UNDERPASS, gridX = 0, gridY = 0, assetId = 31}))

            local underpassEntry1 = UnderpassEntry:new{underpassModule = underpassModule}

            assert.are.same({
                x = c.DEFAULT_HORIZONTAL_GRID_DISTANCE / 2,
                y = -c.DEFAULT_VERTICAL_GRID_DISTANCE / 2,
                z = platform:getAbsolutePlatformHeight()
            }, underpassEntry1:getLaneEndPoint())
        end)

        it('returns lane end point (scenario 2)', function ()
            local station = Station:new{}
            local platform = station:initializeAndRegister(Slot.makeId({type = t.PLATFORM, gridX = 0, gridY = 0}))
            local underpassModule = station:initializeAndRegister(Slot.makeId({type = t.UNDERPASS, gridX = 0, gridY = 0, assetId = 30}))

            local underpassEntry1 = UnderpassEntry:new{underpassModule = underpassModule}

            assert.are.same({
                x = -c.DEFAULT_HORIZONTAL_GRID_DISTANCE / 2,
                y = -c.DEFAULT_VERTICAL_GRID_DISTANCE / 2,
                z = platform:getAbsolutePlatformHeight()
            }, underpassEntry1:getLaneEndPoint())
        end)

        it('returns lane end point (scenario 3)', function ()
            local station = Station:new{}
            station:initializeAndRegister(Slot.makeId({type = t.PLATFORM, gridX = 0, gridY = 0}))
            station:initializeAndRegister(Slot.makeId({type = t.UNDERPASS, gridX = 0, gridY = 0, assetId = 29}))
            local underpassModule = station:initializeAndRegister(Slot.makeId({type = t.UNDERPASS, gridX = 0, gridY = 0, assetId = 32}))

            local underpassEntry1 = UnderpassEntry:new{underpassModule = underpassModule}

            assert.are.equal(-c.DEFAULT_VERTICAL_GRID_DISTANCE / 2, underpassEntry1:getLaneEndPoint().y)
        end)

        it('returns lane end point (scenario 4)', function ()
            local station = Station:new{}
            station:initializeAndRegister(Slot.makeId({type = t.PLATFORM, gridX = 0, gridY = 0}))
            station:initializeAndRegister(Slot.makeId({type = t.UNDERPASS, gridX = 0, gridY = 0, assetId = 25}))
            local underpassModule = station:initializeAndRegister(Slot.makeId({type = t.UNDERPASS, gridX = 0, gridY = 0, assetId = 32}))

            local underpassEntry1 = UnderpassEntry:new{underpassModule = underpassModule}

            assert.are.equal(-c.DEFAULT_VERTICAL_GRID_DISTANCE / 2, underpassEntry1:getLaneEndPoint().y)
        end)

        it('returns lane end point (scenario 5)', function ()
            local station = Station:new{}
            station:initializeAndRegister(Slot.makeId({type = t.PLATFORM, gridX = 0, gridY = 0}))
            station:initializeAndRegister(Slot.makeId({type = t.UNDERPASS, gridX = 0, gridY = 0, assetId = 29}))
            local underpassModule = station:initializeAndRegister(Slot.makeId({type = t.UNDERPASS, gridX = 0, gridY = 0, assetId = 28}))

            local underpassEntry1 = UnderpassEntry:new{underpassModule = underpassModule}

            assert.are.equal(-c.DEFAULT_VERTICAL_GRID_DISTANCE / 2, underpassEntry1:getLaneEndPoint().y)
        end)

        it('returns lane end point (scenario 6)', function ()
            local station = Station:new{}
            station:initializeAndRegister(Slot.makeId({type = t.PLATFORM, gridX = 0, gridY = 0}))
            station:initializeAndRegister(Slot.makeId({type = t.UNDERPASS, gridX = 0, gridY = 0, assetId = 25}))
            local underpassModule = station:initializeAndRegister(Slot.makeId({type = t.UNDERPASS, gridX = 0, gridY = 0, assetId = 28}))

            local underpassEntry1 = UnderpassEntry:new{underpassModule = underpassModule}

            assert.are.equal(0, underpassEntry1:getLaneEndPoint().y)
        end)
    end)

    describe("addEntryConnectionLaneToModelsIfNecessary", function ()
        it('adds nothing when there is one entry only (scenario 1)', function ()
            local station = Station:new{}
            station:initializeAndRegister(Slot.makeId({type = t.PLATFORM, gridX = 0, gridY = 0}))
            local underpassModule = station:initializeAndRegister(Slot.makeId({type = t.UNDERPASS, gridX = 0, gridY = 0, assetId = 25}))

            local underpassEntry1 = UnderpassEntry:new{underpassModule = underpassModule}
            
            local models = {}
            underpassEntry1:addEntryConnectionLaneToModelsIfNecessary(models)
            assert.are.same({}, models)
        end)

        it('adds nothing when there is one entry only (scenario 2)', function ()
            local station = Station:new{}
            station:initializeAndRegister(Slot.makeId({type = t.PLATFORM, gridX = 0, gridY = 0}))
            local underpassModule = station:initializeAndRegister(Slot.makeId({type = t.UNDERPASS, gridX = 0, gridY = 0, assetId = 29}))

            local underpassEntry1 = UnderpassEntry:new{underpassModule = underpassModule}
            
            local models = {}
            underpassEntry1:addEntryConnectionLaneToModelsIfNecessary(models)
            assert.are.same({}, models)
        end)

        it ('adds nothing when both entries has same size (scenario 1)', function ()
            local station = Station:new{}
            station:initializeAndRegister(Slot.makeId({type = t.PLATFORM, gridX = 0, gridY = 0}))
            station:initializeAndRegister(Slot.makeId({type = t.UNDERPASS, gridX = 0, gridY = 0, assetId = 25}))
            local underpassModule = station:initializeAndRegister(Slot.makeId({type = t.UNDERPASS, gridX = 0, gridY = 0, assetId = 28}))

            local underpassEntry1 = UnderpassEntry:new{underpassModule = underpassModule}
            
            local models = {}
            underpassEntry1:addEntryConnectionLaneToModelsIfNecessary(models)
            assert.are.same({}, models)
        end)

        it ('adds nothing when both entries has same size (scenario 2)', function ()
            local station = Station:new{}
            station:initializeAndRegister(Slot.makeId({type = t.PLATFORM, gridX = 0, gridY = 0}))
            station:initializeAndRegister(Slot.makeId({type = t.UNDERPASS, gridX = 0, gridY = 0, assetId = 32}))
            local underpassModule = station:initializeAndRegister(Slot.makeId({type = t.UNDERPASS, gridX = 0, gridY = 0, assetId = 29}))

            local underpassEntry1 = UnderpassEntry:new{underpassModule = underpassModule}
            
            local models = {}
            underpassEntry1:addEntryConnectionLaneToModelsIfNecessary(models)
            assert.are.same({}, models)
        end)

        it ('adds connection path when entry size differs (scenario 1)', function ()
            local station = Station:new{}
            station:initializeAndRegister(Slot.makeId({type = t.PLATFORM, gridX = 0, gridY = 0}))
            station:initializeAndRegister(Slot.makeId({type = t.UNDERPASS, gridX = 0, gridY = 0, assetId = 25}))
            local underpassModule = station:initializeAndRegister(Slot.makeId({type = t.UNDERPASS, gridX = 0, gridY = 0, assetId = 32}))

            local underpassEntry1 = UnderpassEntry:new{underpassModule = underpassModule}
            
            local models = {}
            underpassEntry1:addEntryConnectionLaneToModelsIfNecessary(models)
            assert.are.same({
                PathUtils.makePassengerPathModel(underpassEntry1:getLaneEndPoint(), underpassEntry1:getLaneStartPoint())
            }, models)
        end)

        it ('adds connection path when entry size differs (scenario 2)', function ()
            local station = Station:new{}
            station:initializeAndRegister(Slot.makeId({type = t.PLATFORM, gridX = 0, gridY = 0}))
            station:initializeAndRegister(Slot.makeId({type = t.UNDERPASS, gridX = 0, gridY = 0, assetId = 29}))
            local underpassModule = station:initializeAndRegister(Slot.makeId({type = t.UNDERPASS, gridX = 0, gridY = 0, assetId = 28}))

            local underpassEntry1 = UnderpassEntry:new{underpassModule = underpassModule}
            
            local models = {}
            underpassEntry1:addEntryConnectionLaneToModelsIfNecessary(models)
            assert.are.same({
                PathUtils.makePassengerPathModel(underpassEntry1:getLaneEndPoint(), underpassEntry1:getLaneStartPoint())
            }, models)
        end)
    end)
end)