local Station = require('motras_station')
local Slot = require('motras_slot')
local t = require('motras_types')
local c = require('motras_constants')

local PlatformEdge = require('motras_platform_edge')
local PlatformSide = require('motras_platform_side')
local PlatformSurface = require('motras_platform_surface')

local PlatformBuilder = require('motras_platform_builder')

describe('PlatformBuilder', function ()
    local ident = {
        1, 0, 0, 0,
        0, 1, 0, 0,
        0, 0, 1, 0,
        0, 0, 0, 1,
    }

    describe('addPlatformToModels', function ()
        it('adds surface platform only', function ()
            local station = Station:new{}
            local platform = station:initializeAndRegister(Slot.makeId({type = t.PLATFORM, gridX = 0, gridY = 0}))

            local platformSurface = PlatformSurface:new{platform = platform, transformation = ident, mainPart = 'main_part.mdl'}
            local expectedModels = {}
            platformSurface:addToModels(expectedModels)

            local models = {}
            PlatformBuilder:new{platform = platform, surface = platformSurface}:addToModels(models)
            assert.are.same(expectedModels, models)
        end)

        it('adds adds surface and two platform edges', function ()
            local station = Station:new{}
            local platform = station:initializeAndRegister(Slot.makeId({type = t.PLATFORM, gridX = 0, gridY = 0}))

            local platformSurface = PlatformSurface:new{platform = platform, transformation = ident, mainPart = 'main_part.mdl'}
            local platformEdge = PlatformEdge:new{platform = platform, transformation = ident, repeatingModel = 'edge_rep.mdl'}

            local expectedModels = {}
            platformSurface:addToModels(expectedModels)
            platformEdge:addToModels(expectedModels, false)
            platformEdge:addToModels(expectedModels, true)

            local models = {}
            PlatformBuilder:new{platform = platform, surface = platformSurface, platformEdge = platformEdge}:addToModels(models)
            assert.are.same(expectedModels, models)
        end)

        it('adds different platform edges depending on tracks', function ()
            local station = Station:new{}
            local platform = station:initializeAndRegister(Slot.makeId({type = t.PLATFORM, gridX = 0, gridY = 0}))
            station:initializeAndRegister(Slot.makeId({type = t.TRACK, gridX = 0, gridY = 1}))

            local platformSurface = PlatformSurface:new{platform = platform, transformation = ident, mainPart = 'main_part.mdl'}
            local platformEdge = PlatformEdge:new{platform = platform, transformation = ident, repeatingModel = 'edge_rep.mdl'}
            local platformEdgeOnTrack = PlatformEdge:new{platform = platform, transformation = ident, repeatingModel = 'edge_rep_track.mdl'}

            local expectedModels = {}
            platformSurface:addToModels(expectedModels)
            platformEdge:addToModels(expectedModels, false)
            platformEdgeOnTrack:addToModels(expectedModels, true)

            local models = {}
            PlatformBuilder:new{platform = platform, surface = platformSurface, platformEdge = platformEdge, platformEdgeOnTrack = platformEdgeOnTrack}:addToModels(models)
            assert.are.same(expectedModels, models)
        end)

        it('adds platform with sides', function ()
            local station = Station:new{}
            local platform = station:initializeAndRegister(Slot.makeId({type = t.PLATFORM, gridX = 0, gridY = 0}))
            station:initializeAndRegister(Slot.makeId({type = t.PLATFORM, gridX = 0, gridY = 1}))
            station:initializeAndRegister(Slot.makeId({type = t.PLATFORM, gridX = 0, gridY = -1}))

            local platformSurface = PlatformSurface:new{platform = platform, transformation = ident, mainPart = 'main_part.mdl'}
            local platformEdge = PlatformEdge:new{platform = platform, transformation = ident, repeatingModel = 'edge_rep.mdl'}
            local platformSide = PlatformSide:new{platform = platform, transformation = ident, repeatingModel = 'edge_side.mdl'}

            local expectedModels = {}
            platformSurface:addToModels(expectedModels)
            platformSide:addToModels(expectedModels, false)
            platformSide:addToModels(expectedModels, true)

            local models = {}
            PlatformBuilder:new{platform = platform, surface = platformSurface, platformEdge = platformEdge, platformSide = platformSide}:addToModels(models)
            assert.are.same(expectedModels, models)
        end)

        it('adds no sites to occupied sides', function()
            local station = Station:new{}
            local platform = station:initializeAndRegister(Slot.makeId({type = t.PLATFORM, gridX = 0, gridY = 0}))
            station:initializeAndRegister(Slot.makeId({type = t.PLATFORM, gridX = 0, gridY = 1}))
            station:initializeAndRegister(Slot.makeId({type = t.PLATFORM, gridX = 0, gridY = -1}))
            station:initializeAndRegister(Slot.makeId({type = t.PLATFORM, gridX = 1, gridY = 0}))

            local platformSurface = PlatformSurface:new{platform = platform, transformation = ident, mainPart = 'main_part.mdl'}
            local platformEdge = PlatformEdge:new{platform = platform, transformation = ident, repeatingModel = 'edge_rep.mdl'}
            local platformSide = PlatformSide:new{platform = platform, transformation = ident, repeatingModel = 'edge_side.mdl'}

            local expectedModels = {}
            platformSurface:addToModels(expectedModels)
            platformSide:addToModels(expectedModels, false)

            local models = {}
            PlatformBuilder:new{platform = platform, surface = platformSurface, platformEdge = platformEdge, platformSide = platformSide}:addToModels(models)
            assert.are.same(expectedModels, models)
        end)
    end)
end)