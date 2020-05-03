local Station = require('motras_station')
local Slot = require('motras_slot')
local t = require('motras_types')

local PlatformSurface = require('motras_platform_surface')

describe('PlatformSurface', function ()
    local transformation = {
        1, 0, 0, 0,
        0, 1, 0, 0,
        0, 0, 1, 0,
        0, 0, 0, 1
    }

    describe('addStairsSegment', function ()
        it('add all 4 parts when no stairs a set', function ()
            local station = Station:new{}
            local platform1 = station:initializeAndRegister(Slot.makeId({type = t.TRACK, gridX = 0, gridY = 0}))
            local platform2 = station:initializeAndRegister(Slot.makeId({type = t.TRACK, gridX = 0, gridY = 1}))

            local platformSurface = PlatformSurface:new{platform = platform1, transformation = transformation, mainPart = 'main_part.mdl'}

            local models = {}
            platformSurface:addStairsSegment(25, 29, 'part1.mdl', 'part2.mdl', 'part3.mdl', 'part4.mdl')
            platformSurface:addToModels(models)

            assert.are.same({
                { id = 'main_part.mdl', transf = transformation},
                { id = 'part1.mdl', transf = transformation},
                { id = 'part2.mdl', transf = transformation},
                { id = 'part3.mdl', transf = transformation},
                { id = 'part4.mdl', transf = transformation},
            }, models)
        end)

        it('has no inner parts when small stairs are set', function ()
            local station = Station:new{}
            local platform1 = station:initializeAndRegister(Slot.makeId({type = t.TRACK, gridX = 0, gridY = 0}))
            local platform2 = station:initializeAndRegister(Slot.makeId({type = t.TRACK, gridX = 0, gridY = 1}))
            station:initializeAndRegister(Slot.makeId({type = t.UNDERPASS, gridX = 0, gridY = 0, assetId = 25}))

            local platformSurface = PlatformSurface:new{platform = platform1, transformation = transformation, mainPart = 'main_part.mdl'}

            local models = {}
            platformSurface:addStairsSegment(25, 29, 'part1.mdl', 'part2.mdl', 'part3.mdl', 'part4.mdl')
            platformSurface:addToModels(models)

            assert.are.same({
                { id = 'main_part.mdl', transf = transformation},
                { id = 'part1.mdl', transf = transformation},
                { id = 'part4.mdl', transf = transformation},
            }, models)
        end)

        it('has no bottom parts when big stairs are set', function ()
            local station = Station:new{}
            local platform1 = station:initializeAndRegister(Slot.makeId({type = t.TRACK, gridX = 0, gridY = 0}))
            local platform2 = station:initializeAndRegister(Slot.makeId({type = t.TRACK, gridX = 0, gridY = 1}))
            station:initializeAndRegister(Slot.makeId({type = t.UNDERPASS, gridX = 0, gridY = 0, assetId = 29}))

            local platformSurface = PlatformSurface:new{platform = platform1, transformation = transformation, mainPart = 'main_part.mdl'}

            local models = {}
            platformSurface:addStairsSegment(25, 29, 'part1.mdl', 'part2.mdl', 'part3.mdl', 'part4.mdl')
            platformSurface:addToModels(models)

            assert.are.same({
                { id = 'main_part.mdl', transf = transformation},
                { id = 'part1.mdl', transf = transformation},
                { id = 'part2.mdl', transf = transformation},
            }, models)
        end)

        it('has not not parts when top neighbor platform has big stairs', function ()
            local station = Station:new{}
            local platform1 = station:initializeAndRegister(Slot.makeId({type = t.TRACK, gridX = 0, gridY = 0}))
            local platform2 = station:initializeAndRegister(Slot.makeId({type = t.TRACK, gridX = 0, gridY = 1}))

            local platformSurface = PlatformSurface:new{
                platform = platform1,
                transformation = transformation,
                mainPart = 'main_part.mdl'
            }

            local models = {}
            platformSurface:addStairsSegment(25, 29, 'part1.mdl', 'part2.mdl', 'part3.mdl', 'part4.mdl')
            platformSurface:addToModels(models)

            assert.are.same({
                { id = 'main_part.mdl', transf = transformation},
                { id = 'part1.mdl', transf = transformation},
                { id = 'part2.mdl', transf = transformation},
                { id = 'part3.mdl', transf = transformation},
                { id = 'part4.mdl', transf = transformation},
            }, models)
        end)

        it('has adds outer left platform parts (small stairs)', function ()
            local station = Station:new{}
            local platform1 = station:initializeAndRegister(Slot.makeId({type = t.TRACK, gridX = 0, gridY = 0}))
            local platform2 = station:initializeAndRegister(Slot.makeId({type = t.TRACK, gridX = 0, gridY = 1}))
            station:initializeAndRegister(Slot.makeId({type = t.UNDERPASS, gridX = 0, gridY = 0, assetId = 25}))

            local platformSurface = PlatformSurface:new{
                platform = platform1,
                transformation = transformation,
                mainPart = 'main_part.mdl',
                smallUnderpassAssetIds = {25, 26, 27, 28},
                largeUnderpassAssetIds = {29, 30, 31, 32}
            }

            local models = {}
            platformSurface:addOuterLeftSegment('part1.mdl', 'part2.mdl', 'part3.mdl', 'part4.mdl')
            platformSurface:addToModels(models)

            assert.are.same({
                { id = 'main_part.mdl', transf = transformation},
                { id = 'part1.mdl', transf = transformation},
                { id = 'part4.mdl', transf = transformation},
            }, models)
        end)

        it('has adds outer left platform parts (big stairs)', function ()
            local station = Station:new{}
            local platform1 = station:initializeAndRegister(Slot.makeId({type = t.TRACK, gridX = 0, gridY = 0}))
            local platform2 = station:initializeAndRegister(Slot.makeId({type = t.TRACK, gridX = 0, gridY = 1}))
            station:initializeAndRegister(Slot.makeId({type = t.UNDERPASS, gridX = 0, gridY = 0, assetId = 29}))

            local platformSurface = PlatformSurface:new{
                platform = platform1,
                transformation = transformation,
                mainPart = 'main_part.mdl',
                smallUnderpassAssetIds = {25, 26, 27, 28},
                largeUnderpassAssetIds = {29, 30, 31, 32}
            }

            local models = {}
            platformSurface:addOuterLeftSegment('part1.mdl', 'part2.mdl', 'part3.mdl', 'part4.mdl')
            platformSurface:addToModels(models)

            assert.are.same({
                { id = 'main_part.mdl', transf = transformation},
                { id = 'part1.mdl', transf = transformation},
                { id = 'part2.mdl', transf = transformation},
            }, models)
        end)

        it('has adds inner left platform parts (small stairs)', function ()
            local station = Station:new{}
            local platform1 = station:initializeAndRegister(Slot.makeId({type = t.TRACK, gridX = 0, gridY = 0}))
            local platform2 = station:initializeAndRegister(Slot.makeId({type = t.TRACK, gridX = 0, gridY = 1}))
            station:initializeAndRegister(Slot.makeId({type = t.UNDERPASS, gridX = 0, gridY = 0, assetId = 26}))

            local platformSurface = PlatformSurface:new{
                platform = platform1,
                transformation = transformation,
                mainPart = 'main_part.mdl',
                smallUnderpassAssetIds = {25, 26, 27, 28},
                largeUnderpassAssetIds = {29, 30, 31, 32}
            }

            local models = {}
            platformSurface:addInnerLeftSegment('part1.mdl', 'part2.mdl', 'part3.mdl', 'part4.mdl')
            platformSurface:addToModels(models)

            assert.are.same({
                { id = 'main_part.mdl', transf = transformation},
                { id = 'part1.mdl', transf = transformation},
                { id = 'part4.mdl', transf = transformation},
            }, models)
        end)

        it('has adds inner left platform parts (big stairs)', function ()
            local station = Station:new{}
            local platform1 = station:initializeAndRegister(Slot.makeId({type = t.TRACK, gridX = 0, gridY = 0}))
            local platform2 = station:initializeAndRegister(Slot.makeId({type = t.TRACK, gridX = 0, gridY = 1}))
            station:initializeAndRegister(Slot.makeId({type = t.UNDERPASS, gridX = 0, gridY = 0, assetId = 30}))

            local platformSurface = PlatformSurface:new{
                platform = platform1,
                transformation = transformation,
                mainPart = 'main_part.mdl',
                smallUnderpassAssetIds = {25, 26, 27, 28},
                largeUnderpassAssetIds = {29, 30, 31, 32}
            }

            local models = {}
            platformSurface:addInnerLeftSegment('part1.mdl', 'part2.mdl', 'part3.mdl', 'part4.mdl')
            platformSurface:addToModels(models)

            assert.are.same({
                { id = 'main_part.mdl', transf = transformation},
                { id = 'part1.mdl', transf = transformation},
                { id = 'part2.mdl', transf = transformation},
            }, models)
        end)

        it('has adds inner right platform parts (small stairs)', function ()
            local station = Station:new{}
            local platform1 = station:initializeAndRegister(Slot.makeId({type = t.TRACK, gridX = 0, gridY = 0}))
            local platform2 = station:initializeAndRegister(Slot.makeId({type = t.TRACK, gridX = 0, gridY = 1}))
            station:initializeAndRegister(Slot.makeId({type = t.UNDERPASS, gridX = 0, gridY = 0, assetId = 27}))

            local platformSurface = PlatformSurface:new{
                platform = platform1,
                transformation = transformation,
                mainPart = 'main_part.mdl',
                smallUnderpassAssetIds = {25, 26, 27, 28},
                largeUnderpassAssetIds = {29, 30, 31, 32}
            }

            local models = {}
            platformSurface:addInnerRightSegment('part1.mdl', 'part2.mdl', 'part3.mdl', 'part4.mdl')
            platformSurface:addToModels(models)

            assert.are.same({
                { id = 'main_part.mdl', transf = transformation},
                { id = 'part1.mdl', transf = transformation},
                { id = 'part4.mdl', transf = transformation},
            }, models)
        end)

        it('has adds inner right platform parts (big stairs)', function ()
            local station = Station:new{}
            local platform1 = station:initializeAndRegister(Slot.makeId({type = t.TRACK, gridX = 0, gridY = 0}))
            local platform2 = station:initializeAndRegister(Slot.makeId({type = t.TRACK, gridX = 0, gridY = 1}))
            station:initializeAndRegister(Slot.makeId({type = t.UNDERPASS, gridX = 0, gridY = 0, assetId = 31}))

            local platformSurface = PlatformSurface:new{
                platform = platform1,
                transformation = transformation,
                mainPart = 'main_part.mdl',
                smallUnderpassAssetIds = {25, 26, 27, 28},
                largeUnderpassAssetIds = {29, 30, 31, 32}
            }

            local models = {}
            platformSurface:addInnerRightSegment('part1.mdl', 'part2.mdl', 'part3.mdl', 'part4.mdl')
            platformSurface:addToModels(models)

            assert.are.same({
                { id = 'main_part.mdl', transf = transformation},
                { id = 'part1.mdl', transf = transformation},
                { id = 'part2.mdl', transf = transformation},
            }, models)
        end)

        it('has adds outer right platform parts (small stairs)', function ()
            local station = Station:new{}
            local platform1 = station:initializeAndRegister(Slot.makeId({type = t.TRACK, gridX = 0, gridY = 0}))
            local platform2 = station:initializeAndRegister(Slot.makeId({type = t.TRACK, gridX = 0, gridY = 1}))
            station:initializeAndRegister(Slot.makeId({type = t.UNDERPASS, gridX = 0, gridY = 0, assetId = 28}))

            local platformSurface = PlatformSurface:new{
                platform = platform1,
                transformation = transformation,
                mainPart = 'main_part.mdl',
                smallUnderpassAssetIds = {25, 26, 27, 28},
                largeUnderpassAssetIds = {29, 30, 31, 32}
            }

            local models = {}
            platformSurface:addOuterRightSegment('part1.mdl', 'part2.mdl', 'part3.mdl', 'part4.mdl')
            platformSurface:addToModels(models)

            assert.are.same({
                { id = 'main_part.mdl', transf = transformation},
                { id = 'part1.mdl', transf = transformation},
                { id = 'part4.mdl', transf = transformation},
            }, models)
        end)

        it('has adds outer right platform parts (big stairs)', function ()
            local station = Station:new{}
            local platform1 = station:initializeAndRegister(Slot.makeId({type = t.TRACK, gridX = 0, gridY = 0}))
            local platform2 = station:initializeAndRegister(Slot.makeId({type = t.TRACK, gridX = 0, gridY = 1}))
            station:initializeAndRegister(Slot.makeId({type = t.UNDERPASS, gridX = 0, gridY = 0, assetId = 32}))

            local platformSurface = PlatformSurface:new{
                platform = platform1,
                transformation = transformation,
                mainPart = 'main_part.mdl',
                smallUnderpassAssetIds = {25, 26, 27, 28},
                largeUnderpassAssetIds = {29, 30, 31, 32}
            }

            local models = {}
            platformSurface:addOuterRightSegment('part1.mdl', 'part2.mdl', 'part3.mdl', 'part4.mdl')
            platformSurface:addToModels(models)

            assert.are.same({
                { id = 'main_part.mdl', transf = transformation},
                { id = 'part1.mdl', transf = transformation},
                { id = 'part2.mdl', transf = transformation},
            }, models)
        end)
    end)
end)