describe("slot", function ()
    local natbomb = require('natbomb')
    local Slot = require('motras_slot')
    local t = require('motras_types')

    describe('makeId', function ()

        it('generates module id', function ()
            local id = Slot.makeId({
                type = t.TRACK,
                gridX = 3,
                gridY = 1,
                assetId = 2,
                assetDecorationId = 3
            })

            assert.are.equal(natbomb.implode({7, 7, 6, 4}, {t.TRACK, 3 +  64, 1 + 64, 2, 3}), id)
        end)
    end)

    describe('object', function ()
        local slotId = natbomb.implode({7, 7, 6, 4}, {t.TRACK, 3 +  64, 1 + 64, 2, 3})
        local slot = Slot:new{id = slotId}

        it('has id', function ()
            assert.are.equal(slotId, slot.id)
        end)

        it('has grid type', function ()
            assert.are.equal(t.GRID_TRACK, slot.gridType)
        end)

        it('has type', function ()
            assert.are.equal(t.TRACK, slot.type)
        end)

        it('has grid x position', function ()
            assert.are.equal(3, slot.gridX)
        end)

        it('has grid y position', function ()
            assert.are.equal(1, slot.gridY)
        end)

        it('has asset id', function ()
            assert.are.equal(2, slot.assetId)
        end)

        it('has asset decoration id', function ()
            assert.are.equal(3, slot.assetDecorationId)
        end)
    end)
end)