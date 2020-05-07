local Station = require('motras_station')
local Slot = require('motras_slot')
local t = require('motras_types')
local c = require('motras_constants')

local PlatformModuleUtils = require('motras_platformmoduleutils')

describe('PlatformModuleUtils', function ()
    describe('makePlatform', function ()
        local absolutePlatformHeight = c.DEFAULT_PLATFORM_HEIGHT + c.DEFAULT_BASE_TRACK_HEIGHT

        local platformModuleSlotId = Slot.makeId({type = t.PLATFORM, gridX = 0, gridY = 0})
        local topTrackModuleSlotId = Slot.makeId({type = t.TRACK, gridX = 0, gridY = 1})
        local topLeftTrackModuleSlotId = Slot.makeId({type = t.TRACK, gridX = -1, gridY = 1})
        local topRightTrackModuleSlotId = Slot.makeId({type = t.TRACK, gridX = 1, gridY = 1})
        local bottomTrackModuleSlotId = Slot.makeId({type = t.TRACK, gridX = 0, gridY = -1})
        local bottomLeftTrackModuleSlotId = Slot.makeId({type = t.TRACK, gridX = 1, gridY = -1})
        local bottomRightTrackModuleSlotId = Slot.makeId({type = t.TRACK, gridX = -1, gridY = -1})
        local leftNeighborPlatformSlotId = Slot.makeId({type = t.PLATFORM, gridX = -1, gridY = 0})
        local rightNeightbotPlatformSlotId = Slot.makeId({type = t.PLATFORM, gridX = 1, gridY = 0})
        local topNeighborPlatformSlotId = Slot.makeId({type = t.PLATFORM, gridX = 0, gridY = 1})
        local bottomNeighborPlatformSlotId = Slot.makeId({type = t.PLATFORM, gridX = 0, gridY = -1})
        local leftNeighborPlaceSlotId = Slot.makeId({type = t.PLACE, gridX = -1, gridY = 0})
        local rightNeightbotPlaceSlotId = Slot.makeId({type = t.PLACE, gridX = 1, gridY = 0})
        local topNeighborPlaceSlotId = Slot.makeId({type = t.PLACE, gridX = 0, gridY = 1})
        local bottomNeighborPlaceSlotId = Slot.makeId({type = t.PLACE, gridX = 0, gridY = -1})

        local platformRepModel = 'platform_rep.mdl'
        local platformEdgeRepModel = 'platform_edge_rep.mdl'
        local platformBackRepModel = 'platform_back_rep.mdl'
        local platformSideModel = 'platform_side.mdl'
        local platformEdgeSideLeftModel = 'platform_edge_side_left.mdl'
        local platformEdgeSideRightModel = 'platform_edge_side_right.mdl'
        local platformBackSideLeftModel = 'platform_back_side_left.mdl'
        local platformBackSideRightModel = 'platform_back_side_right.mdl'

        local transfCenter = { 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, 0, 0, absolutePlatformHeight, 1 }
        local transfTop = { 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, 0, c.DEFAULT_VERTICAL_GRID_DISTANCE / 2, absolutePlatformHeight, 1 }
        local transfTopLeft = { 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, -c.DEFAULT_HORIZONTAL_GRID_DISTANCE / 2, c.DEFAULT_VERTICAL_GRID_DISTANCE / 2, absolutePlatformHeight, 1 }
        local transfTopRight = { 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, c.DEFAULT_HORIZONTAL_GRID_DISTANCE / 2, c.DEFAULT_VERTICAL_GRID_DISTANCE / 2, absolutePlatformHeight, 1 }
        local transfLeft = { 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, -c.DEFAULT_HORIZONTAL_GRID_DISTANCE / 2, 0, absolutePlatformHeight, 1 }
        local transfRightFlipped = { -1, 0, 0, 0, 0, -1, 0, 0, 0, 0, 1, 0, c.DEFAULT_HORIZONTAL_GRID_DISTANCE / 2, 0, absolutePlatformHeight, 1 }
        local transfBottomFlipped = { -1, 0, 0, 0, 0, -1, 0, 0, 0, 0, 1, 0, 0, -c.DEFAULT_VERTICAL_GRID_DISTANCE / 2, absolutePlatformHeight, 1 }
        local transfBottomLeftFlipped = { -1, 0, 0, 0, 0, -1, 0, 0, 0, 0, 1, 0, -c.DEFAULT_HORIZONTAL_GRID_DISTANCE / 2, -c.DEFAULT_VERTICAL_GRID_DISTANCE / 2, absolutePlatformHeight, 1 }
        local transfBottomRightFlipped = { -1, 0, 0, 0, 0, -1, 0, 0, 0, 0, 1, 0, c.DEFAULT_HORIZONTAL_GRID_DISTANCE / 2, -c.DEFAULT_VERTICAL_GRID_DISTANCE / 2, absolutePlatformHeight, 1 }

        it('makes platform with 1 param (UG Platform)', function ()
            local station1 = Station:new{}
            local platform = station1:initializeAndRegister(platformModuleSlotId)

            local models = {}
            PlatformModuleUtils.makePlatform(platform, models, platformRepModel)

            assert.are.same({{
                id = platformRepModel,
                transf = transfCenter
            }}, models)

            station1:initializeAndRegister(topTrackModuleSlotId)
            models = {}
            PlatformModuleUtils.makePlatform(platform, models, platformRepModel)

            assert.are.same({{
                id = platformRepModel,
                transf = transfCenter
            }}, models)

            station1:initializeAndRegister(bottomTrackModuleSlotId)
            models = {}
            PlatformModuleUtils.makePlatform(platform, models, platformRepModel)

            assert.are.same({{
                id = platformRepModel,
                transf = transfCenter
            }}, models)

            station1:initializeAndRegister(leftNeighborPlatformSlotId)
            models = {}
            PlatformModuleUtils.makePlatform(platform, models, platformRepModel)

            assert.are.same({{
                id = platformRepModel,
                transf = transfCenter
            }}, models)

            station1:initializeAndRegister(leftNeighborPlatformSlotId)
            models = {}
            PlatformModuleUtils.makePlatform(platform, models, platformRepModel)

            assert.are.same({{
                id = platformRepModel,
                transf = transfCenter
            }}, models)
        end)

        it('handles platform surface', function ()
            local station1 = Station:new{}
            local platform = station1:initializeAndRegister(platformModuleSlotId)
            local platformSerface = PlatformModuleUtils.makePlatformSurfaceWithUnderpathHoles(platform, transfCenter, 'mainModel.mdl')

            local models = {}
            PlatformModuleUtils.makePlatform(platform, models, platformSerface)

            assert.are.same({{
                id = 'mainModel.mdl',
                transf = transfCenter
            }}, models)

        end)

        describe('makes platform with 2 params', function ()
            local station1 = Station:new{}

            it('szenario 1', function ()
                local platform = station1:initializeAndRegister(platformModuleSlotId)

                local models = {}
                PlatformModuleUtils.makePlatform(platform, models, platformRepModel, platformEdgeRepModel)

                assert.are.same({{
                    id = platformRepModel,
                    transf = transfCenter
                }}, models)

                station1:initializeAndRegister(topTrackModuleSlotId)
                models = {}
                PlatformModuleUtils.makePlatform(platform, models, platformRepModel, platformEdgeRepModel)

                assert.are.same({{
                    id = platformRepModel,
                    transf = transfCenter
                }, {
                    id = platformEdgeRepModel,
                    transf = transfTop
                }}, models)

                station1:initializeAndRegister(bottomTrackModuleSlotId)
                models = {}
                PlatformModuleUtils.makePlatform(platform, models, platformRepModel, platformEdgeRepModel)

                assert.are.same({{
                    id = platformRepModel,
                    transf = transfCenter
                }, {
                    id = platformEdgeRepModel,
                    transf = transfTop
                }, {
                    id = platformEdgeRepModel,
                    transf = transfBottomFlipped
                }}, models)

                station1:initializeAndRegister(leftNeighborPlatformSlotId)
                models = {}
                PlatformModuleUtils.makePlatform(platform, models, platformRepModel, platformEdgeRepModel)

                assert.are.same({{
                    id = platformRepModel,
                    transf = transfCenter
                }, {
                    id = platformEdgeRepModel,
                    transf = transfTop
                }, {
                    id = platformEdgeRepModel,
                    transf = transfBottomFlipped
                }}, models)

            end)
        end)

        describe('makes platform with 3 params', function ()
            local station1 = Station:new{}

            it('szenario 1', function ()
                local platform = station1:initializeAndRegister(platformModuleSlotId)

                local models = {}
                PlatformModuleUtils.makePlatform(platform, models, platformRepModel, platformEdgeRepModel, platformBackRepModel)

                assert.are.same({{
                    id = platformRepModel,
                    transf = transfCenter
                }, {
                    id = platformBackRepModel,
                    transf = transfTop
                }, {
                    id = platformBackRepModel,
                    transf = transfBottomFlipped
                }}, models)

                station1:initializeAndRegister(topTrackModuleSlotId)
                models = {}
                PlatformModuleUtils.makePlatform(platform, models, platformRepModel, platformEdgeRepModel, platformBackRepModel)

                assert.are.same({{
                    id = platformRepModel,
                    transf = transfCenter
                }, {
                    id = platformEdgeRepModel,
                    transf = transfTop
                }, {
                    id = platformBackRepModel,
                    transf = transfBottomFlipped
                }}, models)

                station1:initializeAndRegister(bottomTrackModuleSlotId)
                models = {}
                PlatformModuleUtils.makePlatform(platform, models, platformRepModel, platformEdgeRepModel, platformBackRepModel)

                assert.are.same({{
                    id = platformRepModel,
                    transf = transfCenter
                }, {
                    id = platformEdgeRepModel,
                    transf = transfTop
                }, {
                    id = platformEdgeRepModel,
                    transf = transfBottomFlipped
                }}, models)

                station1:initializeAndRegister(leftNeighborPlatformSlotId)
                models = {}
                PlatformModuleUtils.makePlatform(platform, models, platformRepModel, platformEdgeRepModel, platformBackRepModel)

                assert.are.same({{
                    id = platformRepModel,
                    transf = transfCenter
                }, {
                    id = platformEdgeRepModel,
                    transf = transfTop
                }, {
                    id = platformEdgeRepModel,
                    transf = transfBottomFlipped
                }}, models)

            end)
        end)

        describe('makes platform with 6 params', function ()
            local station1 = Station:new{}
            local station2 = Station:new{}

            it('szenario 1', function ()
                local platform = station1:initializeAndRegister(platformModuleSlotId)

                local models = {}
                PlatformModuleUtils.makePlatform(platform, models, platformRepModel, platformEdgeRepModel, platformBackRepModel, platformSideModel, platformEdgeSideLeftModel, platformEdgeSideRightModel)

                assert.are.same({{
                    id = platformRepModel,
                    transf = transfCenter
                }, {
                    id = platformBackRepModel,
                    transf = transfTop
                }, {
                    id = platformBackRepModel,
                    transf = transfBottomFlipped
                }, {
                    id = platformSideModel,
                    transf = transfLeft
                }, {
                    id = platformSideModel,
                    transf = transfRightFlipped
                }}, models)

                station1:initializeAndRegister(topTrackModuleSlotId)
                station1:initializeAndRegister(topLeftTrackModuleSlotId)
                station1:initializeAndRegister(topRightTrackModuleSlotId)
                models = {}
                PlatformModuleUtils.makePlatform(platform, models, platformRepModel, platformEdgeRepModel, platformBackRepModel, platformSideModel, platformEdgeSideLeftModel, platformEdgeSideRightModel)

                assert.are.same({{
                    id = platformRepModel,
                    transf = transfCenter
                }, {
                    id = platformEdgeRepModel,
                    transf = transfTop
                }, {
                    id = platformBackRepModel,
                    transf = transfBottomFlipped
                }, {
                    id = platformSideModel,
                    transf = transfLeft
                }, {
                    id = platformSideModel,
                    transf = transfRightFlipped
                }, {
                    id = platformEdgeSideLeftModel,
                    transf = transfTopLeft
                }, {
                    id = platformEdgeSideRightModel,
                    transf = transfTopRight
                }}, models)

                station1:initializeAndRegister(bottomTrackModuleSlotId)
                station1:initializeAndRegister(bottomLeftTrackModuleSlotId)
                station1:initializeAndRegister(bottomRightTrackModuleSlotId)
                models = {}
                PlatformModuleUtils.makePlatform(platform, models, platformRepModel, platformEdgeRepModel, platformBackRepModel, platformSideModel, platformEdgeSideLeftModel, platformEdgeSideRightModel)

                assert.are.same({{
                    id = platformRepModel,
                    transf = transfCenter
                }, {
                    id = platformEdgeRepModel,
                    transf = transfTop
                }, {
                    id = platformEdgeRepModel,
                    transf = transfBottomFlipped
                }, {
                    id = platformSideModel,
                    transf = transfLeft
                }, {
                    id = platformSideModel,
                    transf = transfRightFlipped
                }, {
                    id = platformEdgeSideLeftModel,
                    transf = transfTopLeft
                }, {
                    id = platformEdgeSideRightModel,
                    transf = transfTopRight
                }, {
                    id = platformEdgeSideLeftModel,
                    transf = transfBottomRightFlipped
                }, {
                    id = platformEdgeSideRightModel,
                    transf = transfBottomLeftFlipped
                }}, models)

                station1:initializeAndRegister(leftNeighborPlatformSlotId)
                models = {}
                PlatformModuleUtils.makePlatform(platform, models, platformRepModel, platformEdgeRepModel, platformBackRepModel, platformSideModel, platformEdgeSideLeftModel, platformEdgeSideRightModel)

                assert.are.same({{
                    id = platformRepModel,
                    transf = transfCenter
                }, {
                    id = platformEdgeRepModel,
                    transf = transfTop
                }, {
                    id = platformEdgeRepModel,
                    transf = transfBottomFlipped
                }, {
                    id = platformSideModel,
                    transf = transfRightFlipped
                }, {
                    id = platformEdgeSideRightModel,
                    transf = transfTopRight
                }, {
                    id = platformEdgeSideLeftModel,
                    transf = transfBottomRightFlipped
                }}, models)
            end)

            it('scenario 2', function ()
                local platform = station2:initializeAndRegister(platformModuleSlotId)
                station2:initializeAndRegister(leftNeighborPlaceSlotId)

                local models = {}
                PlatformModuleUtils.makePlatform(platform, models, platformRepModel, platformEdgeRepModel, platformBackRepModel, platformSideModel, platformEdgeSideLeftModel, platformEdgeSideRightModel)

                assert.are.same({{
                    id = platformRepModel,
                    transf = transfCenter
                }, {
                    id = platformBackRepModel,
                    transf = transfTop
                }, {
                    id = platformBackRepModel,
                    transf = transfBottomFlipped
                }, {
                    id = platformSideModel,
                    transf = transfRightFlipped
                }}, models)

                station2:initializeAndRegister(rightNeightbotPlatformSlotId)

                models = {}
                PlatformModuleUtils.makePlatform(platform, models, platformRepModel, platformEdgeRepModel, platformBackRepModel, platformSideModel, platformEdgeSideLeftModel, platformEdgeSideRightModel)

                assert.are.same({{
                    id = platformRepModel,
                    transf = transfCenter
                }, {
                    id = platformBackRepModel,
                    transf = transfTop
                }, {
                    id = platformBackRepModel,
                    transf = transfBottomFlipped
                }}, models)

                station2:initializeAndRegister(topNeighborPlatformSlotId)

                models = {}
                PlatformModuleUtils.makePlatform(platform, models, platformRepModel, platformEdgeRepModel, platformBackRepModel, platformSideModel, platformEdgeSideLeftModel, platformEdgeSideRightModel)

                assert.are.same({{
                    id = platformRepModel,
                    transf = transfCenter
                }, {
                    id = platformBackRepModel,
                    transf = transfBottomFlipped
                }}, models)

                station2:initializeAndRegister(bottomNeighborPlaceSlotId)

                models = {}
                PlatformModuleUtils.makePlatform(platform, models, platformRepModel, platformEdgeRepModel, platformBackRepModel, platformSideModel, platformEdgeSideLeftModel, platformEdgeSideRightModel)

                assert.are.same({{
                    id = platformRepModel,
                    transf = transfCenter
                }}, models)
            end)
        end)

        describe('makes platform with 8 params', function ()
            local station1 = Station:new{}
            local station2 = Station:new{}

            it('szenario 1', function ()
                local platform = station1:initializeAndRegister(platformModuleSlotId)

                local models = {}
                PlatformModuleUtils.makePlatform(
                    platform, models, platformRepModel, platformEdgeRepModel, platformBackRepModel,
                    platformSideModel, platformEdgeSideLeftModel, platformEdgeSideRightModel,
                    platformBackSideLeftModel, platformBackSideRightModel)

                assert.are.same({{
                    id = platformRepModel,
                    transf = transfCenter
                }, {
                    id = platformBackRepModel,
                    transf = transfTop
                }, {
                    id = platformBackRepModel,
                    transf = transfBottomFlipped
                }, {
                    id = platformSideModel,
                    transf = transfLeft
                }, {
                    id = platformSideModel,
                    transf = transfRightFlipped
                }, {
                    id = platformBackSideLeftModel,
                    transf = transfTopLeft
                }, {
                    id = platformBackSideRightModel,
                    transf = transfTopRight
                }, {
                    id = platformBackSideLeftModel,
                    transf = transfBottomRightFlipped
                }, {
                    id = platformBackSideRightModel,
                    transf = transfBottomLeftFlipped
                }}, models)

                station1:initializeAndRegister(topTrackModuleSlotId)
                station1:initializeAndRegister(topLeftTrackModuleSlotId)
                station1:initializeAndRegister(topRightTrackModuleSlotId)
                models = {}
                PlatformModuleUtils.makePlatform(
                    platform, models, platformRepModel, platformEdgeRepModel, platformBackRepModel,
                    platformSideModel, platformEdgeSideLeftModel, platformEdgeSideRightModel,
                    platformBackSideLeftModel, platformBackSideRightModel)

                assert.are.same({{
                    id = platformRepModel,
                    transf = transfCenter
                }, {
                    id = platformEdgeRepModel,
                    transf = transfTop
                }, {
                    id = platformBackRepModel,
                    transf = transfBottomFlipped
                }, {
                    id = platformSideModel,
                    transf = transfLeft
                }, {
                    id = platformSideModel,
                    transf = transfRightFlipped
                }, {
                    id = platformEdgeSideLeftModel,
                    transf = transfTopLeft
                }, {
                    id = platformEdgeSideRightModel,
                    transf = transfTopRight
                }, {
                    id = platformBackSideLeftModel,
                    transf = transfBottomRightFlipped
                }, {
                    id = platformBackSideRightModel,
                    transf = transfBottomLeftFlipped
                }}, models)

                station1:initializeAndRegister(bottomTrackModuleSlotId)
                station1:initializeAndRegister(bottomLeftTrackModuleSlotId)
                station1:initializeAndRegister(bottomRightTrackModuleSlotId)
                models = {}
                PlatformModuleUtils.makePlatform(
                    platform, models, platformRepModel, platformEdgeRepModel, platformBackRepModel,
                    platformSideModel, platformEdgeSideLeftModel, platformEdgeSideRightModel,
                    platformBackSideLeftModel, platformBackSideRightModel)

                assert.are.same({{
                    id = platformRepModel,
                    transf = transfCenter
                }, {
                    id = platformEdgeRepModel,
                    transf = transfTop
                }, {
                    id = platformEdgeRepModel,
                    transf = transfBottomFlipped
                }, {
                    id = platformSideModel,
                    transf = transfLeft
                }, {
                    id = platformSideModel,
                    transf = transfRightFlipped
                }, {
                    id = platformEdgeSideLeftModel,
                    transf = transfTopLeft
                }, {
                    id = platformEdgeSideRightModel,
                    transf = transfTopRight
                }, {
                    id = platformEdgeSideLeftModel,
                    transf = transfBottomRightFlipped
                }, {
                    id = platformEdgeSideRightModel,
                    transf = transfBottomLeftFlipped
                }}, models)

                station1:initializeAndRegister(leftNeighborPlatformSlotId)
                models = {}
                PlatformModuleUtils.makePlatform(
                    platform, models, platformRepModel, platformEdgeRepModel, platformBackRepModel,
                    platformSideModel, platformEdgeSideLeftModel, platformEdgeSideRightModel,
                    platformBackSideLeftModel, platformBackSideRightModel)

                assert.are.same({{
                    id = platformRepModel,
                    transf = transfCenter
                }, {
                    id = platformEdgeRepModel,
                    transf = transfTop
                }, {
                    id = platformEdgeRepModel,
                    transf = transfBottomFlipped
                }, {
                    id = platformSideModel,
                    transf = transfRightFlipped
                }, {
                    id = platformEdgeSideRightModel,
                    transf = transfTopRight
                }, {
                    id = platformEdgeSideLeftModel,
                    transf = transfBottomRightFlipped
                }}, models)
            end)

            it('scenario 2  #huhn', function ()
                local platform = station2:initializeAndRegister(platformModuleSlotId)
                station2:initializeAndRegister(leftNeighborPlaceSlotId)

                local models = {}
                PlatformModuleUtils.makePlatform(
                    platform, models, platformRepModel, platformEdgeRepModel, platformBackRepModel,
                    platformSideModel, platformEdgeSideLeftModel, platformEdgeSideRightModel,
                    platformBackSideLeftModel, platformBackSideRightModel)

                assert.are.same({{
                    id = platformRepModel,
                    transf = transfCenter
                }, {
                    id = platformBackRepModel,
                    transf = transfTop
                }, {
                    id = platformBackRepModel,
                    transf = transfBottomFlipped
                }, {
                    id = platformSideModel,
                    transf = transfRightFlipped
                }, {
                    id = platformBackSideRightModel,
                    transf = transfTopRight
                }, {
                    id = platformBackSideLeftModel,
                    transf = transfBottomRightFlipped
                }}, models)

                station2:initializeAndRegister(rightNeightbotPlatformSlotId)

                models = {}
                PlatformModuleUtils.makePlatform(
                    platform, models, platformRepModel, platformEdgeRepModel, platformBackRepModel,
                    platformSideModel, platformEdgeSideLeftModel, platformEdgeSideRightModel,
                    platformBackSideLeftModel, platformBackSideRightModel)

                assert.are.same({{
                    id = platformRepModel,
                    transf = transfCenter
                }, {
                    id = platformBackRepModel,
                    transf = transfTop
                }, {
                    id = platformBackRepModel,
                    transf = transfBottomFlipped
                }}, models)

                station2:initializeAndRegister(topNeighborPlatformSlotId)

                models = {}
                PlatformModuleUtils.makePlatform(
                    platform, models, platformRepModel, platformEdgeRepModel, platformBackRepModel,
                    platformSideModel, platformEdgeSideLeftModel, platformEdgeSideRightModel,
                    platformBackSideLeftModel, platformBackSideRightModel)

                assert.are.same({{
                    id = platformRepModel,
                    transf = transfCenter
                }, {
                    id = platformBackRepModel,
                    transf = transfBottomFlipped
                }}, models)

                station2:initializeAndRegister(bottomNeighborPlaceSlotId)

                models = {}
                PlatformModuleUtils.makePlatform(
                    platform, models, platformRepModel, platformEdgeRepModel, platformBackRepModel,
                    platformSideModel, platformEdgeSideLeftModel, platformEdgeSideRightModel,
                    platformBackSideLeftModel, platformBackSideRightModel)

                assert.are.same({{
                    id = platformRepModel,
                    transf = transfCenter
                }}, models)
            end)
        end)

        describe('makes platform with 8 params (add_back_edges_on_connect)', function ()
            local station2 = Station:new{}

            it('scenario 2', function ()
                local platform = station2:initializeAndRegister(platformModuleSlotId)
                station2:initializeAndRegister(leftNeighborPlaceSlotId)

                local models = {}
                PlatformModuleUtils.makePlatform(
                    platform, models, platformRepModel, platformEdgeRepModel, platformBackRepModel,
                    platformSideModel, platformEdgeSideLeftModel, platformEdgeSideRightModel,
                    platformBackSideLeftModel, platformBackSideRightModel)

                assert.are.same({{
                    id = platformRepModel,
                    transf = transfCenter
                }, {
                    id = platformBackRepModel,
                    transf = transfTop
                }, {
                    id = platformBackRepModel,
                    transf = transfBottomFlipped
                }, {
                    id = platformSideModel,
                    transf = transfRightFlipped
                }, {
                    id = platformBackSideRightModel,
                    transf = transfTopRight
                }, {
                    id = platformBackSideLeftModel,
                    transf = transfBottomRightFlipped
                }}, models)

                station2:initializeAndRegister(rightNeightbotPlatformSlotId)

                models = {}
                PlatformModuleUtils.makePlatform(
                    platform, models, platformRepModel, platformEdgeRepModel, platformBackRepModel,
                    platformSideModel, platformEdgeSideLeftModel, platformEdgeSideRightModel,
                    platformBackSideLeftModel, platformBackSideRightModel)

                assert.are.same({{
                    id = platformRepModel,
                    transf = transfCenter
                }, {
                    id = platformBackRepModel,
                    transf = transfTop
                }, {
                    id = platformBackRepModel,
                    transf = transfBottomFlipped
                }}, models)

                station2:initializeAndRegister(topNeighborPlatformSlotId)

                models = {}
                PlatformModuleUtils.makePlatform(
                    platform, models, platformRepModel, platformEdgeRepModel, platformBackRepModel,
                    platformSideModel, platformEdgeSideLeftModel, platformEdgeSideRightModel,
                    platformBackSideLeftModel, platformBackSideRightModel)

                assert.are.same({{
                    id = platformRepModel,
                    transf = transfCenter
                }, {
                    id = platformBackRepModel,
                    transf = transfBottomFlipped
                }}, models)

                station2:initializeAndRegister(bottomNeighborPlaceSlotId)

                models = {}
                PlatformModuleUtils.makePlatform(
                    platform, models, platformRepModel, platformEdgeRepModel, platformBackRepModel,
                    platformSideModel, platformEdgeSideLeftModel, platformEdgeSideRightModel,
                    platformBackSideLeftModel, platformBackSideRightModel)

                assert.are.same({{
                    id = platformRepModel,
                    transf = transfCenter
                }}, models)
            end)
        end)
    end)

    describe('addBuildingSlotsFor40mPlatform', function ()
        it('adds no slots when platform is occupied', function ()
            local slots = {}

            local station = Station:new()
            local platform = station:initializeAndRegister(Slot.makeId({type = t.PLATFORM, gridX = 0, gridY = 0}))
            station:initializeAndRegister(Slot.makeId({type = t.PLATFORM, gridX = 0, gridY = 1}))
            station:initializeAndRegister(Slot.makeId({type = t.PLATFORM, gridX = 0, gridY = -1}))

            PlatformModuleUtils.addBuildingSlotsFor40mPlatform(platform, slots)

            assert.are.same({}, slots)
        end)

        it('adds building slots', function ()
            local slots = {}
            local expectedSlots = {}

            local station = Station:new()
            local platform = station:initializeAndRegister(Slot.makeId({type = t.PLATFORM, gridX = 0, gridY = 0}))

            PlatformModuleUtils.addBuildingSlotsFor40mPlatform(platform, slots)

            platform:addAssetSlot(expectedSlots, 1, {
                assetType = t.BUILDING,
                slotType = 'motras_building_platform40m_small',
                position = {-15, 10, 0},
                rotation = 180,
                spacing = c.BUILDING_PLATFORM40M_SMALL_SPACING
            })
            platform:addAssetSlot(expectedSlots, 2, {
                assetType = t.BUILDING,
                slotType = 'motras_building_platform40m_small',
                position = {-5, 10, 0},
                rotation = 180,
                spacing = c.BUILDING_PLATFORM40M_SMALL_SPACING
            })
            platform:addAssetSlot(expectedSlots, 3, {
                assetType = t.BUILDING,
                slotType = 'motras_building_platform40m_small',
                position = {5, 10, 0},
                rotation = 180,
                spacing = c.BUILDING_PLATFORM40M_SMALL_SPACING
            })
            platform:addAssetSlot(expectedSlots, 4, {
                assetType = t.BUILDING,
                slotType = 'motras_building_platform40m_small',
                position = {15, 10, 0},
                rotation = 180,
                spacing = c.BUILDING_PLATFORM40M_SMALL_SPACING
            })

            platform:addAssetSlot(expectedSlots, 5, {
                assetType = t.BUILDING,
                slotType = 'motras_building_platform40m_medium',
                position = {-20, 10, 0},
                rotation = 180,
                spacing = c.BUILDING_PLATFORM40M_MEDIUM_SPACING
            })
            platform:addAssetSlot(expectedSlots, 6, {
                assetType = t.BUILDING,
                slotType = 'motras_building_platform40m_medium',
                position = {-10, 10, 0},
                rotation = 180,
                spacing = c.BUILDING_PLATFORM40M_MEDIUM_SPACING
            })
            platform:addAssetSlot(expectedSlots, 7, {
                assetType = t.BUILDING,
                slotType = 'motras_building_platform40m_medium',
                position = {0, 10, 0},
                rotation = 180,
                spacing = c.BUILDING_PLATFORM40M_MEDIUM_SPACING
            })
            platform:addAssetSlot(expectedSlots, 8, {
                assetType = t.BUILDING,
                slotType = 'motras_building_platform40m_medium',
                position = {10, 10, 0},
                rotation = 180,
                spacing = c.BUILDING_PLATFORM40M_MEDIUM_SPACING
            })

            platform:addAssetSlot(expectedSlots, 9, {
                assetType = t.BUILDING,
                slotType = 'motras_building_platform40m_large',
                position = {-20, 10, 0},
                rotation = 180,
                spacing = c.BUILDING_PLATFORM40M_LARGE_SPACING
            })
            platform:addAssetSlot(expectedSlots, 10, {
                assetType = t.BUILDING,
                slotType = 'motras_building_platform40m_large',
                position = {-10, 10, 0},
                rotation = 180,
                spacing = c.BUILDING_PLATFORM40M_LARGE_SPACING
            })
            platform:addAssetSlot(expectedSlots, 11, {
                assetType = t.BUILDING,
                slotType = 'motras_building_platform40m_large',
                position = {0, 10, 0},
                rotation = 180,
                spacing = c.BUILDING_PLATFORM40M_LARGE_SPACING
            })
            platform:addAssetSlot(expectedSlots, 12, {
                assetType = t.BUILDING,
                slotType = 'motras_building_platform40m_large',
                position = {10, 10, 0},
                rotation = 180,
                spacing = c.BUILDING_PLATFORM40M_LARGE_SPACING
            })

            platform:addAssetSlot(expectedSlots, 35, {
                assetType = t.BUILDING,
                slotType = 'motras_building_platform40m_access',
                position = {0, 10, 0},
                rotation = 180,
                spacing = c.BUILDING_PLATFORM40M_SMALL_SPACING
            })

            platform:addAssetSlot(expectedSlots, 13, {
                assetType = t.BUILDING,
                slotType = 'motras_building_platform40m_small',
                position = {15, -10, 0},
                rotation = 0,
                spacing = c.BUILDING_PLATFORM40M_SMALL_SPACING
            })
            platform:addAssetSlot(expectedSlots, 14, {
                assetType = t.BUILDING,
                slotType = 'motras_building_platform40m_small',
                position = {5, -10, 0},
                rotation = 0,
                spacing = c.BUILDING_PLATFORM40M_SMALL_SPACING
            })
            platform:addAssetSlot(expectedSlots, 15, {
                assetType = t.BUILDING,
                slotType = 'motras_building_platform40m_small',
                position = {-5, -10, 0},
                rotation = 0,
                spacing = c.BUILDING_PLATFORM40M_SMALL_SPACING
            })
            platform:addAssetSlot(expectedSlots, 16, {
                assetType = t.BUILDING,
                slotType = 'motras_building_platform40m_small',
                position = {-15, -10, 0},
                rotation = 0,
                spacing = c.BUILDING_PLATFORM40M_SMALL_SPACING
            })

            platform:addAssetSlot(expectedSlots, 17, {
                assetType = t.BUILDING,
                slotType = 'motras_building_platform40m_medium',
                position = {20, -10, 0},
                rotation = 0,
                spacing = c.BUILDING_PLATFORM40M_MEDIUM_SPACING
            })
            platform:addAssetSlot(expectedSlots, 18, {
                assetType = t.BUILDING,
                slotType = 'motras_building_platform40m_medium',
                position = {10, -10, 0},
                rotation = 0,
                spacing = c.BUILDING_PLATFORM40M_MEDIUM_SPACING
            })
            platform:addAssetSlot(expectedSlots, 19, {
                assetType = t.BUILDING,
                slotType = 'motras_building_platform40m_medium',
                position = {0, -10, 0},
                rotation = 0,
                spacing = c.BUILDING_PLATFORM40M_MEDIUM_SPACING
            })
            platform:addAssetSlot(expectedSlots, 20, {
                assetType = t.BUILDING,
                slotType = 'motras_building_platform40m_medium',
                position = {-10, -10, 0},
                rotation = 0,
                spacing = c.BUILDING_PLATFORM40M_MEDIUM_SPACING
            })

            platform:addAssetSlot(expectedSlots, 21, {
                assetType = t.BUILDING,
                slotType = 'motras_building_platform40m_large',
                position = {20, -10, 0},
                rotation = 0,
                spacing = c.BUILDING_PLATFORM40M_LARGE_SPACING
            })
            platform:addAssetSlot(expectedSlots, 22, {
                assetType = t.BUILDING,
                slotType = 'motras_building_platform40m_large',
                position = {10, -10, 0},
                rotation = 0,
                spacing = c.BUILDING_PLATFORM40M_LARGE_SPACING
            })
            platform:addAssetSlot(expectedSlots, 23, {
                assetType = t.BUILDING,
                slotType = 'motras_building_platform40m_large',
                position = {0, -10, 0},
                rotation = 0,
                spacing = c.BUILDING_PLATFORM40M_LARGE_SPACING
            })
            platform:addAssetSlot(expectedSlots, 24, {
                assetType = t.BUILDING,
                slotType = 'motras_building_platform40m_large',
                position = {-10, -10, 0},
                rotation = 0,
                spacing = c.BUILDING_PLATFORM40M_LARGE_SPACING
            })

            platform:addAssetSlot(expectedSlots, 36, {
                assetType = t.BUILDING,
                slotType = 'motras_building_platform40m_access',
                position = {0, -10, 0},
                rotation = 0,
                spacing = c.BUILDING_PLATFORM40M_SMALL_SPACING
            })

            assert.are.same(expectedSlots, slots)
        end)
    end)

    describe('makePlatformSurfaceWithUnderpathHoles', function ()
        it ('creates platform surface model', function ()
            local station = Station:new()
            local platform = station:initializeAndRegister(Slot.makeId({type = t.PLATFORM, gridX = 0, gridY = 0}))
            local transformation = {
                1, 0, 0, 0,
                0, 1, 0, 0,
                0, 0, 1, 0,
                0, 0, 0, 1
            }

            local platformSurface = PlatformModuleUtils.makePlatformSurfaceWithUnderpathHoles(platform, transformation, 'main_models.mdl')

            assert.are.equal(platform, platformSurface.platform)
            assert.are.equal(transformation, platformSurface.transformation)
            assert.are.equal('main_models.mdl', platformSurface.mainPart)
            assert.are.equal(c.PLATFORM_40M_SMALL_UNDERPATH_SLOT_IDS, platformSurface.smallUnderpassAssetIds)
            assert.are.equal(c.PLATFORM_40M_LARGE_UNDERPATH_SLOT_IDS, platformSurface.largeUnderpassAssetIds)
        end)
    end)

    describe('makeUnderpassSlots', function ()
        it ('adds slots for small underpath when platform has no neighbor platform', function ()
            local expectedSlots = {}
            local slots = {}

            local station = Station:new()
            local platform = station:initializeAndRegister(Slot.makeId({type = t.PLATFORM, gridX = 0, gridY = 0}))

            platform:addAssetSlot(expectedSlots, 25, {
                assetType = t.BUILDING,
                slotType = 'motras_underpath_small',
                position = {-10, -10, 0},
                rotation = 0,
                shape = 3
                --spacing = c.UNDERPASS_SMALL_SPACING
            })
            platform:addAssetSlot(expectedSlots, 26, {
                assetType = t.BUILDING,
                slotType = 'motras_underpath_small',
                position = {-10, -10, 0},
                rotation = 0,
                shape = 3
                --spacing = c.UNDERPASS_SMALL_SPACING
            })
            platform:addAssetSlot(expectedSlots, 27, {
                assetType = t.BUILDING,
                slotType = 'motras_underpath_small',
                position = {-10, -10, 0},
                rotation = 0,
                shape = 3
                --spacing = c.UNDERPASS_SMALL_SPACING
            })
            platform:addAssetSlot(expectedSlots, 28, {
                assetType = t.BUILDING,
                slotType = 'motras_underpath_small',
                position = {-10, -10, 0},
                rotation = 0,
                shape = 3
                --spacing = c.UNDERPASS_SMALL_SPACING
            })

            
        end)
    end)
end)