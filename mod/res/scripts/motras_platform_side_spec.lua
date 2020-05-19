local Station = require('motras_station')
local Slot = require('motras_slot')
local t = require('motras_types')
local c = require('motras_constants')
local Transf = require('transf')

local PlatformSide = require('motras_platform_side')

describe('platformSide', function ()
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

            local platformSide = PlatformSide:new{platform = platform, repeatingModel = 'rep.mdl', transformation = ident}
            local models = {}

            platformSide:addToModels(models, false)

            assert.are.same({{
                id = 'rep.mdl',
                transf = Transf.transl({x = -c.DEFAULT_HORIZONTAL_GRID_DISTANCE / 2, y = 0, z = 0})
            }}, models)
        end)

        it('adds platform edge models (repeat only, flipped, with tag)', function ()
            local station = Station:new()
            local platform = station:initializeAndRegister(Slot.makeId({type = t.PLATFORM, gridX = 0, gridY = 0}))

            local platformSide = PlatformSide:new{platform = platform, repeatingModel = 'rep.mdl', transformation = ident, tag = 'katze'}
            local models = {}

            platformSide:addToModels(models, true)

            assert.are.same({{
                id = 'rep.mdl',
                transf = Transf.rotZTransl(math.pi, {x = -c.DEFAULT_HORIZONTAL_GRID_DISTANCE / 2, y = 0, z = 0}),
                tag = 'katze'
            }}, models)
        end)

        it ('adds platform with end models but without connection models', function ()
            local station = Station:new()
            local platform = station:initializeAndRegister(Slot.makeId({type = t.PLATFORM, gridX = 0, gridY = 0}))

            local platformSide = PlatformSide:new{
                platform = platform,
                repeatingModel = 'rep.mdl',
                transformation = ident,
                topEndModel = 'top_end.mdl',
                bottomEndModel = 'bottom_end.mdl',
                topConnectionModel = 'top_con.mdl',
                bottomConnectionModel = 'bottom_con.mdl'
            }

            local models = {}

            platformSide:addToModels(models, false)
            assert.are.same({{
                id = 'rep.mdl',
                transf = Transf.transl({x = -c.DEFAULT_HORIZONTAL_GRID_DISTANCE / 2, y = 0, z = 0}),
            }, {
                id = 'top_end.mdl',
                transf = Transf.transl({x = -c.DEFAULT_HORIZONTAL_GRID_DISTANCE / 2, y = c.DEFAULT_VERTICAL_GRID_DISTANCE / 2, z = 0}),
            }, {
                id = 'bottom_end.mdl',
                transf = Transf.transl({x = -c.DEFAULT_HORIZONTAL_GRID_DISTANCE / 2, y = -c.DEFAULT_VERTICAL_GRID_DISTANCE / 2, z = 0}),
            }}, models)
        end)

        it ('adds platform with connection models (without end models, flipped)', function ()
            local station = Station:new()
            local platform = station:initializeAndRegister(Slot.makeId({type = t.PLATFORM, gridX = 0, gridY = 0}))
            station:initializeAndRegister(Slot.makeId({type = t.PLATFORM, gridX = 0, gridY = -1}))
            station:initializeAndRegister(Slot.makeId({type = t.PLATFORM, gridX = 0, gridY = 1}))

            local platformSide = PlatformSide:new{
                platform = platform,
                repeatingModel = 'rep.mdl',
                transformation = ident,
                topEndModel = 'top_end.mdl',
                bottomEndModel = 'bottom_end.mdl',
                topConnectionModel = 'top_con.mdl',
                bottomConnectionModel = 'bottom_con.mdl'
            }

            local models = {}
            platformSide:addToModels(models, true)

            assert.are.same({{
                id = 'rep.mdl',
                transf = Transf.rotZTransl(math.pi, {x = -c.DEFAULT_HORIZONTAL_GRID_DISTANCE / 2, y = 0, z = 0}),
            },{
                id = 'bottom_con.mdl',
                transf = Transf.rotZTransl(math.pi, {x = -c.DEFAULT_HORIZONTAL_GRID_DISTANCE / 2, y = -c.DEFAULT_VERTICAL_GRID_DISTANCE / 2, z = 0}),
            }, {
                id = 'top_con.mdl',
                transf = Transf.rotZTransl(math.pi, {x = -c.DEFAULT_HORIZONTAL_GRID_DISTANCE / 2, y = c.DEFAULT_VERTICAL_GRID_DISTANCE / 2, z = 0}),
            }}, models)
        end)

        it ('adds platform with top end and bottom connection', function ()
            local station = Station:new()
            local platform = station:initializeAndRegister(Slot.makeId({type = t.PLATFORM, gridX = 0, gridY = 0}))
            station:initializeAndRegister(Slot.makeId({type = t.PLATFORM, gridX = 0, gridY = 1}))

            local platformSide = PlatformSide:new{
                platform = platform,
                repeatingModel = 'rep.mdl',
                transformation = ident,
                topEndModel = 'top_end.mdl',
                bottomEndModel = 'bottom_end.mdl',
                topConnectionModel = 'top_con.mdl',
                bottomConnectionModel = 'bottom_con.mdl'
            }

            local models = {}
            platformSide:addToModels(models, true)

            assert.are.same({{
                id = 'rep.mdl',
                transf = Transf.rotZTransl(math.pi, {x = -c.DEFAULT_HORIZONTAL_GRID_DISTANCE / 2, y = 0, z = 0}),
            }, {
                id = 'bottom_con.mdl',
                transf = Transf.rotZTransl(math.pi, {x = -c.DEFAULT_HORIZONTAL_GRID_DISTANCE / 2, y = -c.DEFAULT_VERTICAL_GRID_DISTANCE / 2, z = 0}),
            }, {
                id = 'top_end.mdl',
                transf = Transf.rotZTransl(math.pi, {x = -c.DEFAULT_HORIZONTAL_GRID_DISTANCE / 2, y = c.DEFAULT_VERTICAL_GRID_DISTANCE / 2, z = 0}),
            }}, models)
        end)
    end)
end)