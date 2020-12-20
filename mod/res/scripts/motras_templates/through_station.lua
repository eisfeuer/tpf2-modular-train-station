local t = require('motras_types')

local Blueprint = require('motras_blueprint')

local Theme = require('motras_theme')

local TallPlatformPattern = require('motras_blueprint_patterns.tall_platform_station')
local WidePlatformPattern = require('motras_blueprint_patterns.wide_platform_station')

local ThroughStation = {}

function ThroughStation:new(o)
    o = o or {}
    o.params = o.params or {}

    print(require("inspect")(o.params))

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

function ThroughStation:isFenceEnabled()
    return self.params.motras_fence_platform > 0
end

function ThroughStation:isTrackFencesEnabled()
    return self.params.motras_fence_track > 0
end

function ThroughStation:getFenceModule()
    local fences = {
        "station/rail/modules/motras_fence_metal_wall_era_c.module",
        "station/rail/modules/motras_fence_metal_railing_era_c.module",
        "station/rail/modules/motras_fence_metal_noise_barrier_era_c.module",
        "station/rail/modules/motras_fence_metal_mesh_wire_era_c.module",
    }

    return fences[self.params.motras_fence_platform]
end

function ThroughStation:getTrackFenceModule()
    local fences = {
        "station/rail/modules/motras_fence_metal_wall_era_c.module",
        "station/rail/modules/motras_fence_metal_railing_era_c.module",
        "station/rail/modules/motras_fence_metal_noise_barrier_era_c.module",
        "station/rail/modules/motras_fence_metal_mesh_wire_era_c.module",
    }

    return fences[self.params.motras_fence_track]
end

function ThroughStation:isOppositeEntranceEnabled()
    return self.params.motras_opposite_entrance > 0
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

-- Patterns

function ThroughStation:getPattern()
    local platformModules = {
        'station/rail/modules/motras_platform_270_era_c.module',
        'station/rail/modules/motras_platform_200_era_c.module',
        'station/rail/modules/motras_platform_250_era_c.module',
        'station/rail/modules/motras_platform_350_era_c.module',
        'station/rail/modules/motras_platform_380_era_c.module',
        'station/rail/modules/motras_platform_550_era_c.module',
        'station/rail/modules/motras_platform_580_era_c.module',
        'station/rail/modules/motras_platform_635_era_c.module',
        'station/rail/modules/motras_platform_680_era_c.module',
        'station/rail/modules/motras_platform_730_era_c.module',
        'station/rail/modules/motras_platform_760_era_c.module',
        'station/rail/modules/motras_platform_840_era_c.module',
        'station/rail/modules/motras_platform_900_era_c.module',
        'station/rail/modules/motras_platform_915_era_c.module',
        'station/rail/modules/motras_platform_920_era_c.module',
        'station/rail/modules/motras_platform_960_era_c.module',
        'station/rail/modules/motras_platform_1060_era_c.module',
        'station/rail/modules/motras_platform_1080_era_c.module',
        'station/rail/modules/motras_platform_1100_era_c.module',
        'station/rail/modules/motras_platform_1150_era_c.module',
        'station/rail/modules/motras_platform_1219_era_c.module',
        'station/rail/modules/motras_platform_1250_era_c.module',
    }

    local patternOptions = {
        platformModule =  platformModules[self.params.motras_platform_height + 1],
        trackModule = self:getTrackModule(self.params.trackType, self.params.catenary),
        trackCount = self:getTrackCount(),
        horizontalSize = self:getHorizontalSize()
    }

    if self.params.motras_platform_width > 0 then
        return WidePlatformPattern:new(patternOptions)
    end

    return TallPlatformPattern:new(patternOptions)
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


function ThroughStation:placeRoof(platformBlueprint)
    local hasDestinationDisplay = ((platformBlueprint:getGridX() >= 0) and (platformBlueprint:isInEveryNthSegmentFromCenter(2)))
        or ((platformBlueprint:getGridX() < 0) and (not platformBlueprint:isInEveryNthSegmentFromCenter(2)))
    print(platformBlueprint:getGridX())
    print(platformBlueprint:getRelativeHorizontalDistanceToCenter())
    print(hasDestinationDisplay)
    print()

    if platformBlueprint:getGridX() == 0 and self:getHorizontalSize() % 2 == 1 then
        if self:getHorizontalSize() > 4 then
            platformBlueprint:addAsset(t.ROOF, 'station/rail/modules/motras_roof_era_c_curved.module', 33, function(decorationBlueprint)
                decorationBlueprint:decorate(t.ASSET_DECORATION_TRUSS_MOUNTED, self:getTheme():get('station_name_sign_truss_mounted'), 2)
                decorationBlueprint:decorate(t.ASSET_DECORATION_TRUSS_MOUNTED, self:getTheme():get('station_name_sign_truss_mounted'), 4)
                decorationBlueprint:decorate(t.ASSET_DECORATION_TRUSS_MOUNTED, self:getTheme():get('platform_number_truss_mounted'), 3) 

                if self:getTheme():has('speakers_truss_mounted') then
                    decorationBlueprint:decorate(t.ASSET_DECORATION_TRUSS_MOUNTED, self:getTheme():get('speakers_truss_mounted'), 1)
                end
            end)
        else
            platformBlueprint:addAsset(t.ROOF, 'station/rail/modules/motras_roof_era_c.module', 33, function(decorationBlueprint)
                decorationBlueprint:decorate(t.ASSET_DECORATION_TRUSS_MOUNTED, self:getTheme():get('station_name_sign_truss_mounted'), 2)
                decorationBlueprint:decorate(t.ASSET_DECORATION_TRUSS_MOUNTED, self:getTheme():get('station_name_sign_truss_mounted'), 4)
                decorationBlueprint:decorate(t.ASSET_DECORATION_TRUSS_MOUNTED, self:getTheme():get('platform_number_truss_mounted'), 3) 

                if self:getTheme():has('speakers_truss_mounted') then
                    decorationBlueprint:decorate(t.ASSET_DECORATION_TRUSS_MOUNTED, self:getTheme():get('speakers_truss_mounted'), 1)
                    decorationBlueprint:decorate(t.ASSET_DECORATION_TRUSS_MOUNTED, self:getTheme():get('speakers_truss_mounted'), 5)
                end

                if not platformBlueprint:isSidePlatformTop() and (platformBlueprint:isSidePlatformBottom() or self:getPlatformVerticalSize() < 2 or platformBlueprint:hasIslandPlatformSlots()) then
                    decorationBlueprint:decorate(t.ASSET_DECORATION_CEILING_MOUNTED, self:getTheme():get('clock_ceiling_mounted'), 5)
                    if self:getTheme():get('camera_ceiling_mounted') then
                        decorationBlueprint:decorate(t.ASSET_DECORATION_CEILING_MOUNTED, self:getTheme():get('camera_ceiling_mounted'), 3)
                        decorationBlueprint:decorate(t.ASSET_DECORATION_CEILING_MOUNTED, self:getTheme():get('camera_ceiling_mounted'), 7)
                    end
                    if self:getTheme():get('destination_display_ceiling_mounted') then
                        decorationBlueprint:decorate(t.ASSET_DECORATION_CEILING_MOUNTED, self:getTheme():get('destination_display_ceiling_mounted'), 1)
                    end
                end
                if not platformBlueprint:isSidePlatformBottom() and (platformBlueprint:isSidePlatformTop() or self:getPlatformVerticalSize() < 2 or not platformBlueprint:hasIslandPlatformSlots()) then
                    decorationBlueprint:decorate(t.ASSET_DECORATION_CEILING_MOUNTED, self:getTheme():get('clock_ceiling_mounted'), 6)
                    if self:getTheme():get('camera_ceiling_mounted') then
                        decorationBlueprint:decorate(t.ASSET_DECORATION_CEILING_MOUNTED, self:getTheme():get('camera_ceiling_mounted'), 4)
                        decorationBlueprint:decorate(t.ASSET_DECORATION_CEILING_MOUNTED, self:getTheme():get('camera_ceiling_mounted'), 8)
                    end
                    if self:getHorizontalSize() > 1 and self:getTheme():has('destination_display_ceiling_mounted') then
                        decorationBlueprint:decorate(t.ASSET_DECORATION_CEILING_MOUNTED, self:getTheme():get('destination_display_ceiling_mounted'), 2)
                    end
                end
            end)
        end

        return
    end

    if self:getHorizontalSize() > 4 and platformBlueprint:getRelativeHorizontalDistanceToCenter() < self:getHorizontalSize() * 0.15 then
        platformBlueprint:addAsset(t.ROOF, 'station/rail/modules/motras_roof_era_c_curved.module', 33, function(decorationBlueprint)
            decorationBlueprint:decorate(t.ASSET_DECORATION_TRUSS_MOUNTED, self:getTheme():get('station_name_sign_truss_mounted'), 2)
            decorationBlueprint:decorate(t.ASSET_DECORATION_TRUSS_MOUNTED, self:getTheme():get('station_name_sign_truss_mounted'), 4)
            decorationBlueprint:decorate(t.ASSET_DECORATION_TRUSS_MOUNTED, self:getTheme():get('platform_number_and_clock_truss_mounted'), 3) 

            if self:getTheme():has('speakers_truss_mounted') then
                decorationBlueprint:decorate(t.ASSET_DECORATION_TRUSS_MOUNTED, self:getTheme():get('speakers_truss_mounted'), 1)
            end

            if hasDestinationDisplay and self:getTheme():has('destination_display_ceiling_mounted') then
                if not platformBlueprint:isSidePlatformTop() and (platformBlueprint:isSidePlatformBottom() or self:getPlatformVerticalSize() < 2 or platformBlueprint:hasIslandPlatformSlots()) then
                    decorationBlueprint:decorate(t.ASSET_DECORATION_CEILING_MOUNTED, self:getTheme():get('destination_display_ceiling_mounted'), 1)
                end
                if not platformBlueprint:isSidePlatformBottom() and (platformBlueprint:isSidePlatformTop() or self:getPlatformVerticalSize() < 2 or not platformBlueprint:hasIslandPlatformSlots()) then
                    decorationBlueprint:decorate(t.ASSET_DECORATION_CEILING_MOUNTED, self:getTheme():get('destination_display_ceiling_mounted'), 2)
                end
            end
        end)
        return
    end

    if platformBlueprint:getRelativeHorizontalDistanceToCenter() < self:getHorizontalSize() * 0.35 then
        local isEndOfRoof = platformBlueprint:getGridX() >= 0
            and platformBlueprint:getRelativeHorizontalDistanceToCenter() < self:getHorizontalSize() * 0.35
            and platformBlueprint:getRelativeHorizontalDistanceToCenter() + 1 > self:getHorizontalSize() * 0.35

        platformBlueprint:addAsset(t.ROOF, 'station/rail/modules/motras_roof_era_c.module', 33, function(decorationBlueprint)
            decorationBlueprint:decorate(t.ASSET_DECORATION_TRUSS_MOUNTED, self:getTheme():get('station_name_sign_truss_mounted'), 2)
            decorationBlueprint:decorate(t.ASSET_DECORATION_TRUSS_MOUNTED, self:getTheme():get('station_name_sign_truss_mounted'), 4)
            decorationBlueprint:decorate(t.ASSET_DECORATION_TRUSS_MOUNTED, self:getTheme():get('platform_number_truss_mounted'), 3) 

            if self:getTheme():has('speakers_truss_mounted') then
                decorationBlueprint:decorate(t.ASSET_DECORATION_TRUSS_MOUNTED, self:getTheme():get('speakers_truss_mounted'), 1)
                if isEndOfRoof then
                    decorationBlueprint:decorate(t.ASSET_DECORATION_TRUSS_MOUNTED, self:getTheme():get('speakers_truss_mounted'), 5)
                end
            end

            if not platformBlueprint:isSidePlatformTop() and (platformBlueprint:isSidePlatformBottom() or self:getPlatformVerticalSize() < 2 or platformBlueprint:hasIslandPlatformSlots()) then
                decorationBlueprint:decorate(t.ASSET_DECORATION_CEILING_MOUNTED, self:getTheme():get('clock_ceiling_mounted'), 5)
                if self:getTheme():get('camera_ceiling_mounted') then
                    decorationBlueprint:decorate(t.ASSET_DECORATION_CEILING_MOUNTED, self:getTheme():get('camera_ceiling_mounted'), 3)
                    decorationBlueprint:decorate(t.ASSET_DECORATION_CEILING_MOUNTED, self:getTheme():get('camera_ceiling_mounted'), 7)
                end

                if hasDestinationDisplay and self:getTheme():has('destination_display_ceiling_mounted') then
                    decorationBlueprint:decorate(t.ASSET_DECORATION_CEILING_MOUNTED, self:getTheme():get('destination_display_ceiling_mounted'), 1)
                end
                if self:getTheme():has('destination_display_ceiling_mounted') and isEndOfRoof and not platformBlueprint:isInEveryNthSegmentFromCenter(2) then
                    decorationBlueprint:decorate(t.ASSET_DECORATION_CEILING_MOUNTED, self:getTheme():get('destination_display_ceiling_mounted'), 9)
                end
            end
            if not platformBlueprint:isSidePlatformBottom() and (platformBlueprint:isSidePlatformTop() or self:getPlatformVerticalSize() < 2 or not platformBlueprint:hasIslandPlatformSlots()) then
                decorationBlueprint:decorate(t.ASSET_DECORATION_CEILING_MOUNTED, self:getTheme():get('clock_ceiling_mounted'), 6)
                if self:getTheme():get('camera_ceiling_mounted') then
                    decorationBlueprint:decorate(t.ASSET_DECORATION_CEILING_MOUNTED, self:getTheme():get('camera_ceiling_mounted'), 4)
                    decorationBlueprint:decorate(t.ASSET_DECORATION_CEILING_MOUNTED, self:getTheme():get('camera_ceiling_mounted'), 8)
                end

                if hasDestinationDisplay and self:getTheme():has('destination_display_ceiling_mounted') then
                    decorationBlueprint:decorate(t.ASSET_DECORATION_CEILING_MOUNTED, self:getTheme():get('destination_display_ceiling_mounted'), 2)
                end
                if self:getTheme():has('destination_display_ceiling_mounted') and isEndOfRoof and not platformBlueprint:isInEveryNthSegmentFromCenter(2) then
                    decorationBlueprint:decorate(t.ASSET_DECORATION_CEILING_MOUNTED, self:getTheme():get('destination_display_ceiling_mounted'), 10)
                end
            end
        end)
        return
    end

    if self:getPlatformVerticalSize() > 1 and platformBlueprint:isIslandPlatform() then
        if platformBlueprint:hasIslandPlatformSlots() then
            platformBlueprint:addAsset(t.DECORATION, self:getTheme():get('lamps'), 46, function(decorationBlueprint)
                decorationBlueprint:decorate(t.ASSET_DECORATION_TRUSS_MOUNTED, self:getTheme():get('platform_number_truss_mounted'), 3) 
            end)
        end
    else
        platformBlueprint:addAsset(t.DECORATION, self:getTheme():get('lamps'), 45, function(decorationBlueprint)
            decorationBlueprint:decorate(t.ASSET_DECORATION_TRUSS_MOUNTED, self:getTheme():get('platform_number_truss_mounted'), 3) 
        end)
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

function ThroughStation:placeFencesOnPlatform(platformBlueprint)
    if not self:isFenceEnabled() then
        return
    end

    if platformBlueprint:isSidePlatformTop() then
        platformBlueprint:addAsset(t.DECORATION, self:getFenceModule(), 47)
    end
    if platformBlueprint:isSidePlatformBottom() then
        platformBlueprint:addAsset(t.DECORATION, self:getFenceModule(), 48)
    end
end

function ThroughStation:placeFencesOnTracks(trackBlueprint)
    if not self:isTrackFencesEnabled() then
        return
    end

    if trackBlueprint:isSidePlatformTop() then
        trackBlueprint:addAsset(t.DECORATION, self:getTrackFenceModule(), 47)
    end
    if trackBlueprint:isSidePlatformBottom() then
        trackBlueprint:addAsset(t.DECORATION, self:getTrackFenceModule(), 48)
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

function ThroughStation:placeOppositeEntranceOnPlatform(platformBlueprint)
    if self:isOppositeEntranceEnabled() and platformBlueprint:getGridX() == 0 and platformBlueprint:isSidePlatformBottom() then
        if platformBlueprint:horizontalSizeIsOdd() then
            platformBlueprint:addAsset(t.BUILDING, 'station/rail/modules/motras_side_building_stairs.module', 36)
        else
            platformBlueprint:addAsset(t.BUILDING, 'station/rail/modules/motras_side_building_stairs.module', 50)
        end
    end
end

function ThroughStation:placeOppositeEntranceOnTracks(trackBlueprint)
    if self:isOppositeEntranceEnabled() and trackBlueprint:getGridX() == 0 and trackBlueprint:isSidePlatformBottom() then
        if trackBlueprint:horizontalSizeIsOdd() then
            trackBlueprint:addAsset(t.BUILDING, 'station/rail/modules/motras_side_building_underpass.module', 36)
        else
            trackBlueprint:addAsset(t.BUILDING, 'station/rail/modules/motras_side_building_underpass.module', 50)
        end
    end
end

-- Main function

function ThroughStation:toTpf2Template()
    local blueprint = Blueprint:new{}:decorateEachPlatform(function(platformBlueprint)
        self:placeUnderpass(platformBlueprint)
        self:placeRoof(platformBlueprint)
        self:placeDecoration(platformBlueprint)
        self:placeBuilding(platformBlueprint)
        self:placeOppositeEntranceOnPlatform(platformBlueprint)
        self:placeFencesOnPlatform(platformBlueprint)
    end):decorateEachTrack(function(trackBlueprint)
        self:placeOppositeEntranceOnTracks(trackBlueprint)
        self:placeFencesOnTracks(trackBlueprint)
    end):createStation(self:getPattern())

    return blueprint:toTpf2Template()
end

return ThroughStation