local Station = require('motras_station')
local Slot = require('motras_slot')
local t = require('motras_types')
local c = require('motras_constants')
local Transf = require('transf')

local PlatformEdge = require('motras_platform_edge')

describe('PlatformEdge', function ()
    local ident = {
        1, 0, 0, 0,
        0, 1, 0, 0,
        0, 0, 1, 0,
        0, 0, 0, 1,
    }

    describe('addToModels', function ()
        it('adds platform edge models (repeat only)', function ()
            local station = Station:new()
            local platform = station:initializeAndRegister(Slot.makeId({type = t.PLATFORM, gridX = 0, gridY = 0}))

            local platformEdge = PlatformEdge:new{platform = platform, repeatingModel = 'rep.mdl', transformation = ident}
            local models = {}

            platformEdge:addToModels(models, false)

            assert.are.same({{
                id = 'rep.mdl',
                transf = Transf.transl({x = 0, y = -c.DEFAULT_VERTICAL_GRID_DISTANCE / 2, z = 0})
            }}, models)
        end)

        it('adds platform edge models (repeat only, flipped, with tag)', function ()
            local station = Station:new()
            local platform = station:initializeAndRegister(Slot.makeId({type = t.PLATFORM, gridX = 0, gridY = 0}))

            local platformEdge = PlatformEdge:new{platform = platform, repeatingModel = 'rep.mdl', transformation = ident, tag = 'katze'}
            local models = {}

            platformEdge:addToModels(models, true)

            assert.are.same({{
                id = 'rep.mdl',
                transf = Transf.rotZTransl(math.pi, {x = 0, y = -c.DEFAULT_VERTICAL_GRID_DISTANCE / 2, z = 0}),
                tag = 'katze'
            }}, models)
        end)

        it ('adds platform with end models but without connection models', function ()
            local station = Station:new()
            local platform = station:initializeAndRegister(Slot.makeId({type = t.PLATFORM, gridX = 0, gridY = 0}))

            local platformEdge = PlatformEdge:new{
                platform = platform,
                repeatingModel = 'rep.mdl',
                transformation = ident,
                leftEndModel = 'left_end.mdl',
                rightEndModel = 'right_end.mdl',
                leftConnectionModel = 'left_con.mdl',
                rightConnectionModel = 'right_con.mdl'
            }

            local models = {}

            platformEdge:addToModels(models, false)
            assert.are.same({{
                id = 'rep.mdl',
                transf = Transf.transl({x = 0, y = -c.DEFAULT_VERTICAL_GRID_DISTANCE / 2, z = 0}),
            }, {
                id = 'left_end.mdl',
                transf = Transf.transl({x = -c.DEFAULT_HORIZONTAL_GRID_DISTANCE / 2, y = -c.DEFAULT_VERTICAL_GRID_DISTANCE / 2, z = 0}),
            }, {
                id = 'right_end.mdl',
                transf = Transf.transl({x = c.DEFAULT_HORIZONTAL_GRID_DISTANCE / 2, y = -c.DEFAULT_VERTICAL_GRID_DISTANCE / 2, z = 0}),
            }}, models)
        end)

        it ('adds platform with connection models (without end models, flipped)', function ()
            local station = Station:new()
            local platform = station:initializeAndRegister(Slot.makeId({type = t.PLATFORM, gridX = 0, gridY = 0}))
            station:initializeAndRegister(Slot.makeId({type = t.PLATFORM, gridX = -1, gridY = 0}))
            station:initializeAndRegister(Slot.makeId({type = t.PLATFORM, gridX = 1, gridY = 0}))

            local platformEdge = PlatformEdge:new{
                platform = platform,
                repeatingModel = 'rep.mdl',
                transformation = ident,
                leftEndModel = 'left_end.mdl',
                rightEndModel = 'right_end.mdl',
                leftConnectionModel = 'left_con.mdl',
                rightConnectionModel = 'right_con.mdl'
            }

            local models = {}
            platformEdge:addToModels(models, true)

            assert.are.same({{
                id = 'rep.mdl',
                transf = Transf.rotZTransl(math.pi, {x = 0, y = -c.DEFAULT_VERTICAL_GRID_DISTANCE / 2, z = 0}),
            }, {
                id = 'right_con.mdl',
                transf = Transf.rotZTransl(math.pi, {x = c.DEFAULT_HORIZONTAL_GRID_DISTANCE / 2, y = -c.DEFAULT_VERTICAL_GRID_DISTANCE / 2, z = 0}),
            }, {
                id = 'left_con.mdl',
                transf = Transf.rotZTransl(math.pi, {x = -c.DEFAULT_HORIZONTAL_GRID_DISTANCE / 2, y = -c.DEFAULT_VERTICAL_GRID_DISTANCE / 2, z = 0}),
            }}, models)
        end)

        it ('adds platform with left end and right connection', function ()
            local station = Station:new()
            local platform = station:initializeAndRegister(Slot.makeId({type = t.PLATFORM, gridX = 0, gridY = 0}))
            station:initializeAndRegister(Slot.makeId({type = t.PLATFORM, gridX = 1, gridY = 0}))

            local platformEdge = PlatformEdge:new{
                platform = platform,
                repeatingModel = 'rep.mdl',
                transformation = ident,
                leftEndModel = 'left_end.mdl',
                rightEndModel = 'right_end.mdl',
                leftConnectionModel = 'left_con.mdl',
                rightConnectionModel = 'right_con.mdl'
            }

            local models = {}
            platformEdge:addToModels(models, true)

            assert.are.same({{
                id = 'rep.mdl',
                transf = Transf.rotZTransl(math.pi, {x = 0, y = -c.DEFAULT_VERTICAL_GRID_DISTANCE / 2, z = 0}),
            }, {
                id = 'right_end.mdl',
                transf = Transf.rotZTransl(math.pi, {x = c.DEFAULT_HORIZONTAL_GRID_DISTANCE / 2, y = -c.DEFAULT_VERTICAL_GRID_DISTANCE / 2, z = 0}),
            },  {
                id = 'left_con.mdl',
                transf = Transf.rotZTransl(math.pi, {x = -c.DEFAULT_HORIZONTAL_GRID_DISTANCE / 2, y = -c.DEFAULT_VERTICAL_GRID_DISTANCE / 2, z = 0}),
            }}, models)
        end)
    end)
end)