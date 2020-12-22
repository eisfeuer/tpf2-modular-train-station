local t = require('motras_types')

local Blueprint = require('motras_blueprint')

local Theme = require('motras_theme')

local templateHelper = require("motras_templates.helpers")
local TemplateParams = require("motras_templates.template_params")
local ThroughStation = {}

function ThroughStation:new(o)
    o = o or {}
    o.params = o.params or {}

    setmetatable(o, self)
    self.__index = self

    return o
end

-- Param values

function ThroughStation:getTrackCount()
    return self.params.motras_tracks + 1
end

function ThroughStation:needsUnterpass()
    return self:getTrackCount() > 1
end

function ThroughStation:getHorizontalSize()
    return self.params.motras_length + 1
end

function ThroughStation:getPlatformVerticalSize()
    return self.params.motras_platform_width + 1
end

function ThroughStation:isWidePlatform()
    return self:getPlatformVerticalSize() > 1
end

function ThroughStation:getBuildingSize()
    local upgrade = 0
    local trackCount = self:getTrackCount()
    local horizontalSize = self:getHorizontalSize()

    if trackCount >= 6 then
        upgrade = upgrade + 2
    elseif trackCount >= 4 then
        upgrade = upgrade + 1
    end

    if horizontalSize < 2 then
        return 1
    end
    if horizontalSize < 4 then
        return 1 + upgrade
    end
    if horizontalSize < 6 then
        return 2 + upgrade
    end
    if horizontalSize < 8 then
        return 3 + upgrade
    end

    return 4 + upgrade
end

-- Themes
function ThroughStation:getDefaultThemeComponents()
    if self.params.capturedParams.defaultTheme then
        return self.params.capturedParams.defaultTheme
    end

    return {
        benches_and_trashbin = 'station/rail/modules/motras_decoration_benches_and_trashbin_era_c.module',
        clock_ceiling_mounted = 'station/rail/modules/motras_clock_era_c_ceiling_mounted.module',
        platform_number_truss_mounted = 'station/rail/modules/motras_platform_number_era_c_truss_mounted_1.module',
        platform_number_and_clock_truss_mounted = 'station/rail/modules/motras_platform_number_and_clock_era_c_truss_mounted.module',
        lamps = 'station/rail/modules/motras_platform_lamps_era_c.module',
        station_name_sign_truss_mounted = 'station/rail/modules/motras_station_sign_era_c.module',
        clock_wall_mounted = 'station/rail/modules/motras_clock_small_era_c_wall_mounted.module',
    }
end

function ThroughStation:getComponents()
    local themes = self.params.capturedParams.themes
    if not themes then
        return {}
    end

    return themes[self.params.motras_theme] or {}
end

function ThroughStation:getTheme()
    if not self.theme then
        self.theme = Theme:new{
            theme = self:getComponents(),
            defaultTheme = self:getDefaultThemeComponents()
        }
    end
    
    return self.theme
end

-- Tracks

function ThroughStation:getTrackModule(trackType, catenary)
    local trackModules = self.params.capturedParams.tracks

    if catenary then
        if trackModules and trackModules[0] and trackModules[1][trackType + 1] then
            return trackModules[1] and trackModules[1][trackType + 1]
        end
        return 'station/rail/modules/motras_track_train_normal_catenary.module'
    end

    if trackModules and trackModules[0] and trackModules[0][trackType + 1] then
        return trackModules[0] and trackModules[0][trackType + 1]
    end

    return 'station/rail/modules/motras_track_train_normal.module'
end

-- Construction helper functions

function ThroughStation:blocksNotStationEntrance(platformBlueprint)
    if not platformBlueprint:isSidePlatformTop() then
        return true
    end

    if self:getBuildingSize() < 5 then
        return true
    end

    local additionalSize = platformBlueprint:horizontalSizeIsEven() and 1 or 0

    if self:getBuildingSize() == 5 then
        return platformBlueprint:getRelativeHorizontalDistanceToCenter() > 1 + additionalSize
    end

    return platformBlueprint:getRelativeHorizontalDistanceToCenter() > 2 + additionalSize
end

function ThroughStation:getBuildingPlacementPattern()
    local oddBuildingPlacement = {
        {
            { gridX = 0, slot = 7, module = 'station/rail/modules/motras_main_building_small_era_c.module', decoration = "logo_small"},
        }, {
            { gridX = 0, slot = 7, module = 'station/rail/modules/motras_main_building_small_era_c.module', decoration = "logo_small"},
            { gridX = 0, slot = 1, module = 'station/rail/modules/motras_side_building_small_era_c.module'},
            { gridX = 0, slot = 4, module = 'station/rail/modules/motras_side_building_small_era_c.module'},
        }, {
            { gridX = 0, slot = 7, module = 'station/rail/modules/motras_main_building_small_era_c.module', decoration = "logo_small"},
            { gridX = 0, slot = 1, module = 'station/rail/modules/motras_side_building_small_era_c.module'},
            { gridX = 0, slot = 4, module = 'station/rail/modules/motras_side_building_small_era_c.module'},
            { gridX = -1, slot = 4, module = 'station/rail/modules/motras_side_building_small_era_c.module'},
            { gridX = 1, slot = 1, module = 'station/rail/modules/motras_side_building_small_era_c.module'},
        }, {
            { gridX = 0, slot = 5, module = 'station/rail/modules/motras_side_building_medium_era_c.module'},
            { gridX = 0, slot = 7, module = 'station/rail/modules/motras_main_building_medium_era_c.module', decoration = "logo_small"},
            { gridX = 1, slot = 5, module = 'station/rail/modules/motras_side_building_medium_era_c.module'},
        }, {
            { gridX = -1, slot = 11, module = 'station/rail/modules/motras_side_building_large_era_c.module', decoration = "clock_large"},
            { gridX = 0, slot = 11, module = 'station/rail/modules/motras_main_building_large_era_c.module', decoration = "central_station"},
            { gridX = 1, slot = 11, module = 'station/rail/modules/motras_side_building_large_era_c.module', decoration = "clock_large"},
        }, {
            { gridX = -2, slot = 6, module = 'station/rail/modules/motras_side_building_medium_era_c.module', decoration = "logo_small"},
            { gridX = -2, slot = 8, module = 'station/rail/modules/motras_side_building_medium_era_c.module'},
            { gridX = -1, slot = 11, module = 'station/rail/modules/motras_side_building_large_era_c.module', decoration = "clock_large"},
            { gridX = 0, slot = 11, module = 'station/rail/modules/motras_main_building_large_era_c.module', decoration = "central_station"},
            { gridX = 1, slot = 11, module = 'station/rail/modules/motras_side_building_large_era_c.module', decoration = "clock_large"},
            { gridX = 2, slot = 6, module = 'station/rail/modules/motras_side_building_medium_era_c.module'},
            { gridX = 2, slot = 8, module = 'station/rail/modules/motras_side_building_medium_era_c.module', decoration = "logo_small"},
        }
    }
    
    local evenBuildingPlacement = {
        {
            { gridX = 0, slot = 5, module = 'station/rail/modules/motras_main_building_small_era_c.module', decoration = "logo_small"}
        }, {
            { gridX = 0, slot = 5, module = 'station/rail/modules/motras_main_building_small_era_c.module', decoration = "logo_small"},
            { gridX = -1, slot = 3, module = 'station/rail/modules/motras_side_building_small_era_c.module'},
            { gridX = 0, slot = 2, module = 'station/rail/modules/motras_side_building_small_era_c.module'},
        }, {
            { gridX = 0, slot = 5, module = 'station/rail/modules/motras_main_building_small_era_c.module', decoration = "logo_small"},
            { gridX = -1, slot = 3, module = 'station/rail/modules/motras_side_building_small_era_c.module'},
            { gridX = 0, slot = 2, module = 'station/rail/modules/motras_side_building_small_era_c.module'},
            { gridX = -1, slot = 2, module = 'station/rail/modules/motras_side_building_small_era_c.module'},
            { gridX = 0, slot = 3, module = 'station/rail/modules/motras_side_building_small_era_c.module'},
        }, {
            { gridX = -1, slot = 7, module = 'station/rail/modules/motras_side_building_medium_era_c.module'},
            { gridX = 0, slot = 5, module = 'station/rail/modules/motras_main_building_medium_era_c.module', decoration = "logo_small"},
            { gridX = 0, slot = 7, module = 'station/rail/modules/motras_side_building_medium_era_c.module'},
        }, {
            { gridX = -1, slot = 9, module = 'station/rail/modules/motras_side_building_large_era_c.module', decoration = "clock_large"},
            { gridX = 0, slot = 9, module = 'station/rail/modules/motras_main_building_large_era_c.module', decoration = "central_station"},
            { gridX = 1, slot = 9, module = 'station/rail/modules/motras_side_building_large_era_c.module', decoration = "clock_large"},
        }, {
            { gridX = -3, slot = 8, module = 'station/rail/modules/motras_side_building_medium_era_c.module', decoration = "logo_small"},
            { gridX = -2, slot = 6, module = 'station/rail/modules/motras_side_building_medium_era_c.module'},
            { gridX = -1, slot = 9, module = 'station/rail/modules/motras_side_building_large_era_c.module', decoration = "clock_large"},
            { gridX = 0, slot = 9, module = 'station/rail/modules/motras_main_building_large_era_c.module', decoration = "central_station"},
            { gridX = 1, slot = 9, module = 'station/rail/modules/motras_side_building_large_era_c.module', decoration = "clock_large"},
            { gridX = 1, slot = 8, module = 'station/rail/modules/motras_side_building_medium_era_c.module'},
            { gridX = 2, slot = 6, module = 'station/rail/modules/motras_side_building_medium_era_c.module', decoration = "logo_small"},
        }
    }

    if self:getHorizontalSize() % 2 == 0 then
        return evenBuildingPlacement
    end

    return oddBuildingPlacement
end

-- Construction functions

function ThroughStation:placeUnderpass(platformBlueprint)
    if not self:needsUnterpass() then
        return
    end

    if self:getHorizontalSize() < 3 then
        if platformBlueprint:getGridX() == 0 then
            if self:isWidePlatform() and platformBlueprint:isIslandPlatform() then
                if platformBlueprint:hasIslandPlatformSlots() then
                    platformBlueprint:addAsset(t.UNDERPASS, 'station/rail/modules/motras_underpass_large.module', 31)
                end
            else
                platformBlueprint:addAsset(t.UNDERPASS, 'station/rail/modules/motras_underpass_small.module', 27)
            end
        end
        return
    end

    if self:getHorizontalSize() % 2 == 0 then
        if platformBlueprint:getGridX() == 0 then
            if self:isWidePlatform() and platformBlueprint:isIslandPlatform() then
                if platformBlueprint:hasIslandPlatformSlots() then
                    platformBlueprint:addAsset(t.UNDERPASS, 'station/rail/modules/motras_underpass_large.module', 30)
                end
            else
                platformBlueprint:addAsset(t.UNDERPASS, 'station/rail/modules/motras_underpass_small.module', 26)
            end
        end

        if platformBlueprint:getGridX() == -1 then
            if self:isWidePlatform() and platformBlueprint:isIslandPlatform() then
                if platformBlueprint:hasIslandPlatformSlots() then
                    platformBlueprint:addAsset(t.UNDERPASS, 'station/rail/modules/motras_underpass_large.module', 31)
                end
            else
                platformBlueprint:addAsset(t.UNDERPASS, 'station/rail/modules/motras_underpass_small.module', 27)
            end
        end
    else
        if platformBlueprint:getGridX() == 0 then
            if self:isWidePlatform() and platformBlueprint:isIslandPlatform() then
                if platformBlueprint:hasIslandPlatformSlots() then
                    platformBlueprint:addAsset(t.UNDERPASS, 'station/rail/modules/motras_underpass_large.module', 29)
                    platformBlueprint:addAsset(t.UNDERPASS, 'station/rail/modules/motras_underpass_large.module', 32)
                end
            else
                platformBlueprint:addAsset(t.UNDERPASS, 'station/rail/modules/motras_underpass_small.module', 25)
                platformBlueprint:addAsset(t.UNDERPASS, 'station/rail/modules/motras_underpass_small.module', 28)
            end
        end
    end
end

function ThroughStation:placeDecoration(platformBlueprint)
    if self:getPlatformVerticalSize() > 1 and platformBlueprint:isIslandPlatform() then
        if platformBlueprint:hasIslandPlatformSlots() then
            if platformBlueprint:horizontalSizeIsEven() then
                if platformBlueprint:getGridX() == -1 then
                    platformBlueprint:addAsset(t.DECORATION, self:getTheme():get('benches_and_trashbin'), 41)
                    if self:getTheme():has('ticket_validator') then
                        platformBlueprint:addAsset(t.DECORATION, self:getTheme():get('ticket_validator'), 42)
                    end
                    if self:getTheme():has('ticket_mashine') then
                        platformBlueprint:addAsset(t.DECORATION, self:getTheme():get('ticket_mashine'), 44)
                    end
                elseif platformBlueprint:getGridX() == 0 then
                    platformBlueprint:addAsset(t.DECORATION, self:getTheme():get('benches_and_trashbin'), 44)
                    if self:getTheme():has('ticket_validator') then
                        platformBlueprint:addAsset(t.DECORATION, self:getTheme():get('ticket_validator'), 43)
                    end
                    if self:getTheme():has('infoboard_large') or self:getTheme():has('infoboard') then
                        platformBlueprint:addAsset(t.DECORATION, self:getTheme():getWithAlternative('infoboard_large', 'infoboard'), 41)
                    end
                else
                    platformBlueprint:addAsset(t.DECORATION, self:getTheme():get('benches_and_trashbin'), 42)
                    platformBlueprint:addAsset(t.DECORATION, self:getTheme():get('benches_and_trashbin'), 43)
                end
            elseif platformBlueprint:getGridX() ~= 0 then
                platformBlueprint:addAsset(t.DECORATION, self:getTheme():get('benches_and_trashbin'), 42)
                platformBlueprint:addAsset(t.DECORATION, self:getTheme():get('benches_and_trashbin'), 43)

                if self:getTheme():has('ticket_validator') then
                    if platformBlueprint:getGridX() == -1 then
                        platformBlueprint:addAsset(t.DECORATION, self:getTheme():get('ticket_validator'), 44)
                    end
                    if platformBlueprint:getGridX() == 1 then
                        platformBlueprint:addAsset(t.DECORATION, self:getTheme():get('ticket_validator'), 41)
                    end
                end
            else
                if self:getTheme():has('ticket_mashine') then
                    platformBlueprint:addAsset(t.DECORATION, self:getTheme():get('ticket_mashine'), 42)
                end
                if self:getTheme():has('infoboard_large') or self:getTheme():has('infoboard') then
                    platformBlueprint:addAsset(t.DECORATION, self:getTheme():getWithAlternative('infoboard_large', 'infoboard'), 43)
                end
            end
        end
    else
        if self:blocksNotStationEntrance(platformBlueprint) then
            if platformBlueprint:horizontalSizeIsEven() then
                if platformBlueprint:getGridX() == -1 then
                    platformBlueprint:addAsset(t.DECORATION, self:getTheme():get('benches_and_trashbin'), 37)
                    if self:getTheme():has('ticket_validator') then
                        platformBlueprint:addAsset(t.DECORATION, self:getTheme():get('ticket_validator'), 38)
                    end
                    if self:getTheme():has('ticket_mashine') then
                        platformBlueprint:addAsset(t.DECORATION, self:getTheme():get('ticket_mashine'), 40)
                    end
                elseif platformBlueprint:getGridX() == 0 then
                    platformBlueprint:addAsset(t.DECORATION, self:getTheme():get('benches_and_trashbin'), 40)
                    if self:getTheme():has('ticket_validator') then
                        platformBlueprint:addAsset(t.DECORATION, self:getTheme():get('ticket_validator'), 39)
                    end
                    if self:getTheme():has('infoboard_large') or self:getTheme():has('infoboard') then
                        platformBlueprint:addAsset(t.DECORATION, self:getTheme():getWithAlternative('infoboard_large', 'infoboard'), 37)
                    end
                else
                    platformBlueprint:addAsset(t.DECORATION, self:getTheme():get('benches_and_trashbin'), 38)
                    platformBlueprint:addAsset(t.DECORATION, self:getTheme():get('benches_and_trashbin'), 39)
                end
            elseif platformBlueprint:getGridX() ~= 0 then
                if self:getTheme():has('ticket_validator') then
                    if platformBlueprint:getGridX() == -1 then
                        platformBlueprint:addAsset(t.DECORATION, self:getTheme():get('ticket_validator'), 40)
                    end
                    if platformBlueprint:getGridX() == 1 then
                        platformBlueprint:addAsset(t.DECORATION, self:getTheme():get('ticket_validator'), 37)
                    end
                end
                platformBlueprint:addAsset(t.DECORATION, self:getTheme():get('benches_and_trashbin'), 38)
                platformBlueprint:addAsset(t.DECORATION, self:getTheme():get('benches_and_trashbin'), 39)
            else
                if self:getTheme():has('ticket_mashine') then
                    platformBlueprint:addAsset(t.DECORATION, self:getTheme():get('ticket_mashine'), 38)
                end
                if self:getTheme():has('infoboard_large') or self:getTheme():has('infoboard') then
                    platformBlueprint:addAsset(t.DECORATION, self:getTheme():getWithAlternative('infoboard_large', 'infoboard'), 39)
                end
            end
        end
    end
end

function ThroughStation:placeBuilding(platformBlueprint)
    local buildingSize = self:getBuildingSize()

    if buildingSize == 0 then
        return
    end

    if platformBlueprint:isSidePlatformTop() then
        for _, building in ipairs(self:getBuildingPlacementPattern()[buildingSize]) do
            if platformBlueprint:getGridX() == building.gridX then
                platformBlueprint:addAsset(t.BUILDING, building.module, building.slot, function (decorationBlueprint)
                    if building.decoration == 'logo_small' then
                        if self:getTheme():has('logo_small_wall_mounted') then
                            decorationBlueprint:decorate(t.ASSET_DECORATION_WALL_MOUNTED, self:getTheme():get('logo_small_wall_mounted'), 1)
                            return
                        end

                        if self:getTheme():has('logo_wall_mounted') then
                            decorationBlueprint:decorate(t.ASSET_DECORATION_WALL_MOUNTED, self:getTheme():get('logo_wall_mounted'), 1)
                            return
                        end

                        decorationBlueprint:decorate(t.ASSET_DECORATION_WALL_MOUNTED, self:getTheme():getWithAlternative('clock_small_wall_mounted', 'clock_wall_mounted'), 1)
                        return
                    end

                    if building.decoration == 'clock_large' then
                        if self:getTheme():has('central_station_sign_wall_mounted') then
                            decorationBlueprint:decorate(t.ASSET_DECORATION_WALL_MOUNTED, self:getTheme():getWithAlternative('clock_large_wall_mounted', 'clock_wall_mounted'), 1)
                        end
                        return
                    end

                    if building.decoration == 'central_station' then
                        if self:getTheme():has('central_station_sign_wall_mounted') then
                            decorationBlueprint:decorate(t.ASSET_DECORATION_WALL_MOUNTED, self:getTheme():get('central_station_sign_wall_mounted'), 1)
                            return
                        end
                        decorationBlueprint:decorate(t.ASSET_DECORATION_WALL_MOUNTED, self:getTheme():getWithAlternative('clock_large_wall_mounted', 'clock_wall_mounted'), 1)
                    end
                end)
            end
        end
    end
end

-- Main function

function ThroughStation:toTpf2Template()
    local templateParams = TemplateParams:new{params = self.params}

    local blueprint = Blueprint:new{}:decorateEachPlatform(function(platformBlueprint)
        self:placeUnderpass(platformBlueprint)
        templateHelper.placeRoof(platformBlueprint, templateParams)
        self:placeDecoration(platformBlueprint)
        self:placeBuilding(platformBlueprint)
        templateHelper.placeOppositeEntranceOnPlatform(platformBlueprint, templateParams)
        templateHelper.placeFencesOnPlatform(platformBlueprint, templateParams)
    end):decorateEachTrack(function(trackBlueprint)
        templateHelper.placeOppositeEntranceOnTracks(trackBlueprint, templateParams)
        templateHelper.placeFencesOnTracks(trackBlueprint, templateParams)
    end):createStation(templateHelper.getPattern(templateParams))

    return blueprint:toTpf2Template()
end

return ThroughStation