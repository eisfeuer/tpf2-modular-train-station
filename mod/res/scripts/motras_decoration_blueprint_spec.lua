local Blueprint = require('motras_blueprint')
local AssetBlueprint = require('motras_asset_blueprint')
local Slot = require('motras_slot')
local t = require('motras_types')

local DecorationBlueprint = require('motras_decoration_blueprint')

describe('DecorationBlueprint', function ()
    describe('decorate', function ()
        it('adds asset decoration to template', function ()
            local blueprint = Blueprint:new{}

            local assetBlueprint = AssetBlueprint:new{
                blueprint = blueprint,
                gridX = 2,
                gridY = -1
            }

            local decorationBlueprint = DecorationBlueprint:new{
                assetBlueprint = assetBlueprint,
                assetId = 2
            }

            decorationBlueprint:decorate(t.ASSET_DECORATION, 'clock.module', 3)

            assert.are.same({
                [Slot.makeId({type = t.ASSET_DECORATION, gridX = 2, gridY = -1, assetId = 2, assetDecorationId = 3})] = 'clock.module'
            }, blueprint:toTpf2Template())
        end)
    end)
end)