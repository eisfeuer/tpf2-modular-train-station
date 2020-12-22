local TallPlatformPattern = require('motras_blueprint_patterns.tall_platform_station')
local WidePlatformPattern = require('motras_blueprint_patterns.wide_platform_station')
local t = require("motras_types")

local Helper = {}

function Helper.getPattern(params, preferIslandPlatforms)
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
        preferIslandPlatforms = preferIslandPlatforms or false,
        platformModule =  platformModules[params.params.motras_platform_height + 1],
        trackModule = params:getTrackModule(params.params.trackType, params.params.catenary),
        trackCount = params:getTrackCount(),
        horizontalSize = params:getHorizontalSize()
    }

    if params.params.motras_platform_width > 0 then
        return WidePlatformPattern:new(patternOptions)
    end

    return TallPlatformPattern:new(patternOptions)
end

function Helper.placeUnderpass(platformBlueprint, params)
    if params:getHorizontalSize() < 3 then
        if platformBlueprint:getGridX() == 0 then
            if params:isWidePlatform() and platformBlueprint:isIslandPlatform() then
                if platformBlueprint:hasIslandPlatformSlots() then
                    platformBlueprint:addAsset(t.UNDERPASS, 'station/rail/modules/motras_underpass_large.module', 31)
                end
            else
                platformBlueprint:addAsset(t.UNDERPASS, 'station/rail/modules/motras_underpass_small.module', 27)
            end
        end
        return
    end

    if params:getHorizontalSize() % 2 == 0 then
        if platformBlueprint:getGridX() == 0 then
            if params:isWidePlatform() and platformBlueprint:isIslandPlatform() then
                if platformBlueprint:hasIslandPlatformSlots() then
                    platformBlueprint:addAsset(t.UNDERPASS, 'station/rail/modules/motras_underpass_large.module', 30)
                end
            else
                platformBlueprint:addAsset(t.UNDERPASS, 'station/rail/modules/motras_underpass_small.module', 26)
            end
        end

        if platformBlueprint:getGridX() == -1 then
            if params:isWidePlatform() and platformBlueprint:isIslandPlatform() then
                if platformBlueprint:hasIslandPlatformSlots() then
                    platformBlueprint:addAsset(t.UNDERPASS, 'station/rail/modules/motras_underpass_large.module', 31)
                end
            else
                platformBlueprint:addAsset(t.UNDERPASS, 'station/rail/modules/motras_underpass_small.module', 27)
            end
        end
    else
        if platformBlueprint:getGridX() == 0 then
            if params:isWidePlatform() and platformBlueprint:isIslandPlatform() then
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

function Helper.placeRoof(platformBlueprint, params)
    local hasDestinationDisplay = ((platformBlueprint:getGridX() >= 0) and (platformBlueprint:isInEveryNthSegmentFromCenter(2)))
        or ((platformBlueprint:getGridX() < 0) and (not platformBlueprint:isInEveryNthSegmentFromCenter(2)))
    print(platformBlueprint:getGridX())
    print(platformBlueprint:getRelativeHorizontalDistanceToCenter())
    print(hasDestinationDisplay)
    print()

    if platformBlueprint:getGridX() == 0 and params:getHorizontalSize() % 2 == 1 then
        if params:getHorizontalSize() > 4 then
            platformBlueprint:addAsset(t.ROOF, 'station/rail/modules/motras_roof_era_c_curved.module', 33, function(decorationBlueprint)
                decorationBlueprint:decorate(t.ASSET_DECORATION_TRUSS_MOUNTED, params:getTheme():get('station_name_sign_truss_mounted'), 2)
                decorationBlueprint:decorate(t.ASSET_DECORATION_TRUSS_MOUNTED, params:getTheme():get('station_name_sign_truss_mounted'), 4)
                decorationBlueprint:decorate(t.ASSET_DECORATION_TRUSS_MOUNTED, params:getTheme():get('platform_number_truss_mounted'), 3) 

                if params:getTheme():has('speakers_truss_mounted') then
                    decorationBlueprint:decorate(t.ASSET_DECORATION_TRUSS_MOUNTED, params:getTheme():get('speakers_truss_mounted'), 1)
                end
            end)
        else
            platformBlueprint:addAsset(t.ROOF, 'station/rail/modules/motras_roof_era_c.module', 33, function(decorationBlueprint)
                decorationBlueprint:decorate(t.ASSET_DECORATION_TRUSS_MOUNTED, params:getTheme():get('station_name_sign_truss_mounted'), 2)
                decorationBlueprint:decorate(t.ASSET_DECORATION_TRUSS_MOUNTED, params:getTheme():get('station_name_sign_truss_mounted'), 4)
                decorationBlueprint:decorate(t.ASSET_DECORATION_TRUSS_MOUNTED, params:getTheme():get('platform_number_truss_mounted'), 3) 

                if params:getTheme():has('speakers_truss_mounted') then
                    decorationBlueprint:decorate(t.ASSET_DECORATION_TRUSS_MOUNTED, params:getTheme():get('speakers_truss_mounted'), 1)
                    decorationBlueprint:decorate(t.ASSET_DECORATION_TRUSS_MOUNTED, params:getTheme():get('speakers_truss_mounted'), 5)
                end

                if not platformBlueprint:isSidePlatformTop() and (platformBlueprint:isSidePlatformBottom() or params:getPlatformVerticalSize() < 2 or platformBlueprint:hasIslandPlatformSlots()) then
                    decorationBlueprint:decorate(t.ASSET_DECORATION_CEILING_MOUNTED, params:getTheme():get('clock_ceiling_mounted'), 5)
                    if params:getTheme():get('camera_ceiling_mounted') then
                        decorationBlueprint:decorate(t.ASSET_DECORATION_CEILING_MOUNTED, params:getTheme():get('camera_ceiling_mounted'), 3)
                        decorationBlueprint:decorate(t.ASSET_DECORATION_CEILING_MOUNTED, params:getTheme():get('camera_ceiling_mounted'), 7)
                    end
                    if params:getTheme():get('destination_display_ceiling_mounted') then
                        decorationBlueprint:decorate(t.ASSET_DECORATION_CEILING_MOUNTED, params:getTheme():get('destination_display_ceiling_mounted'), 1)
                    end
                end
                if not platformBlueprint:isSidePlatformBottom() and (platformBlueprint:isSidePlatformTop() or params:getPlatformVerticalSize() < 2 or not platformBlueprint:hasIslandPlatformSlots()) then
                    decorationBlueprint:decorate(t.ASSET_DECORATION_CEILING_MOUNTED, params:getTheme():get('clock_ceiling_mounted'), 6)
                    if params:getTheme():get('camera_ceiling_mounted') then
                        decorationBlueprint:decorate(t.ASSET_DECORATION_CEILING_MOUNTED, params:getTheme():get('camera_ceiling_mounted'), 4)
                        decorationBlueprint:decorate(t.ASSET_DECORATION_CEILING_MOUNTED, params:getTheme():get('camera_ceiling_mounted'), 8)
                    end
                    if params:getHorizontalSize() > 1 and params:getTheme():has('destination_display_ceiling_mounted') then
                        decorationBlueprint:decorate(t.ASSET_DECORATION_CEILING_MOUNTED, params:getTheme():get('destination_display_ceiling_mounted'), 2)
                    end
                end
            end)
        end

        return
    end

    if params:getHorizontalSize() > 4 and platformBlueprint:getRelativeHorizontalDistanceToCenter() < params:getHorizontalSize() * 0.15 then
        platformBlueprint:addAsset(t.ROOF, 'station/rail/modules/motras_roof_era_c_curved.module', 33, function(decorationBlueprint)
            decorationBlueprint:decorate(t.ASSET_DECORATION_TRUSS_MOUNTED, params:getTheme():get('station_name_sign_truss_mounted'), 2)
            decorationBlueprint:decorate(t.ASSET_DECORATION_TRUSS_MOUNTED, params:getTheme():get('station_name_sign_truss_mounted'), 4)
            decorationBlueprint:decorate(t.ASSET_DECORATION_TRUSS_MOUNTED, params:getTheme():get('platform_number_and_clock_truss_mounted'), 3) 

            if params:getTheme():has('speakers_truss_mounted') then
                decorationBlueprint:decorate(t.ASSET_DECORATION_TRUSS_MOUNTED, params:getTheme():get('speakers_truss_mounted'), 1)
            end

            if hasDestinationDisplay and params:getTheme():has('destination_display_ceiling_mounted') then
                if not platformBlueprint:isSidePlatformTop() and (platformBlueprint:isSidePlatformBottom() or params:getPlatformVerticalSize() < 2 or platformBlueprint:hasIslandPlatformSlots()) then
                    decorationBlueprint:decorate(t.ASSET_DECORATION_CEILING_MOUNTED, params:getTheme():get('destination_display_ceiling_mounted'), 1)
                end
                if not platformBlueprint:isSidePlatformBottom() and (platformBlueprint:isSidePlatformTop() or params:getPlatformVerticalSize() < 2 or not platformBlueprint:hasIslandPlatformSlots()) then
                    decorationBlueprint:decorate(t.ASSET_DECORATION_CEILING_MOUNTED, params:getTheme():get('destination_display_ceiling_mounted'), 2)
                end
            end
        end)
        return
    end

    if platformBlueprint:getRelativeHorizontalDistanceToCenter() < params:getHorizontalSize() * 0.35 then
        local isEndOfRoof = platformBlueprint:getGridX() >= 0
            and platformBlueprint:getRelativeHorizontalDistanceToCenter() < params:getHorizontalSize() * 0.35
            and platformBlueprint:getRelativeHorizontalDistanceToCenter() + 1 > params:getHorizontalSize() * 0.35

        platformBlueprint:addAsset(t.ROOF, 'station/rail/modules/motras_roof_era_c.module', 33, function(decorationBlueprint)
            decorationBlueprint:decorate(t.ASSET_DECORATION_TRUSS_MOUNTED, params:getTheme():get('station_name_sign_truss_mounted'), 2)
            decorationBlueprint:decorate(t.ASSET_DECORATION_TRUSS_MOUNTED, params:getTheme():get('station_name_sign_truss_mounted'), 4)
            decorationBlueprint:decorate(t.ASSET_DECORATION_TRUSS_MOUNTED, params:getTheme():get('platform_number_truss_mounted'), 3) 

            if params:getTheme():has('speakers_truss_mounted') then
                decorationBlueprint:decorate(t.ASSET_DECORATION_TRUSS_MOUNTED, params:getTheme():get('speakers_truss_mounted'), 1)
                if isEndOfRoof then
                    decorationBlueprint:decorate(t.ASSET_DECORATION_TRUSS_MOUNTED, params:getTheme():get('speakers_truss_mounted'), 5)
                end
            end

            if not platformBlueprint:isSidePlatformTop() and (platformBlueprint:isSidePlatformBottom() or params:getPlatformVerticalSize() < 2 or platformBlueprint:hasIslandPlatformSlots()) then
                decorationBlueprint:decorate(t.ASSET_DECORATION_CEILING_MOUNTED, params:getTheme():get('clock_ceiling_mounted'), 5)
                if params:getTheme():get('camera_ceiling_mounted') then
                    decorationBlueprint:decorate(t.ASSET_DECORATION_CEILING_MOUNTED, params:getTheme():get('camera_ceiling_mounted'), 3)
                    decorationBlueprint:decorate(t.ASSET_DECORATION_CEILING_MOUNTED, params:getTheme():get('camera_ceiling_mounted'), 7)
                end

                if hasDestinationDisplay and params:getTheme():has('destination_display_ceiling_mounted') then
                    decorationBlueprint:decorate(t.ASSET_DECORATION_CEILING_MOUNTED, params:getTheme():get('destination_display_ceiling_mounted'), 1)
                end
                if params:getTheme():has('destination_display_ceiling_mounted') and isEndOfRoof and not platformBlueprint:isInEveryNthSegmentFromCenter(2) then
                    decorationBlueprint:decorate(t.ASSET_DECORATION_CEILING_MOUNTED, params:getTheme():get('destination_display_ceiling_mounted'), 9)
                end
            end
            if not platformBlueprint:isSidePlatformBottom() and (platformBlueprint:isSidePlatformTop() or params:getPlatformVerticalSize() < 2 or not platformBlueprint:hasIslandPlatformSlots()) then
                decorationBlueprint:decorate(t.ASSET_DECORATION_CEILING_MOUNTED, params:getTheme():get('clock_ceiling_mounted'), 6)
                if params:getTheme():get('camera_ceiling_mounted') then
                    decorationBlueprint:decorate(t.ASSET_DECORATION_CEILING_MOUNTED, params:getTheme():get('camera_ceiling_mounted'), 4)
                    decorationBlueprint:decorate(t.ASSET_DECORATION_CEILING_MOUNTED, params:getTheme():get('camera_ceiling_mounted'), 8)
                end

                if hasDestinationDisplay and params:getTheme():has('destination_display_ceiling_mounted') then
                    decorationBlueprint:decorate(t.ASSET_DECORATION_CEILING_MOUNTED, params:getTheme():get('destination_display_ceiling_mounted'), 2)
                end
                if params:getTheme():has('destination_display_ceiling_mounted') and isEndOfRoof and not platformBlueprint:isInEveryNthSegmentFromCenter(2) then
                    decorationBlueprint:decorate(t.ASSET_DECORATION_CEILING_MOUNTED, params:getTheme():get('destination_display_ceiling_mounted'), 10)
                end
            end
        end)
        return
    end

    if params:getPlatformVerticalSize() > 1 and platformBlueprint:isIslandPlatform() then
        if platformBlueprint:hasIslandPlatformSlots() then
            platformBlueprint:addAsset(t.DECORATION, params:getTheme():get('lighting'), 46, function(decorationBlueprint)
                decorationBlueprint:decorate(t.ASSET_DECORATION_TRUSS_MOUNTED, params:getTheme():get('platform_number_truss_mounted'), 3) 
            end)
        end
    else
        platformBlueprint:addAsset(t.DECORATION, params:getTheme():get('lighting'), 45, function(decorationBlueprint)
            decorationBlueprint:decorate(t.ASSET_DECORATION_TRUSS_MOUNTED, params:getTheme():get('platform_number_truss_mounted'), 3) 
        end)
    end
end

function Helper.placeFencesOnPlatform(platformBlueprint, params)
    if not params:isFenceEnabled() then
        return
    end

    if platformBlueprint:isSidePlatformTop() then
        platformBlueprint:addAsset(t.DECORATION, params:getFenceModule(), 47)
    end
    if platformBlueprint:isSidePlatformBottom() then
        platformBlueprint:addAsset(t.DECORATION, params:getFenceModule(), 48)
    end
end

function Helper.placeFencesOnTracks(trackBlueprint, params)
    if not params:isTrackFencesEnabled() then
        return
    end

    if trackBlueprint:isSidePlatformTop() then
        trackBlueprint:addAsset(t.DECORATION, params:getTrackFenceModule(), 47)
    end
    if trackBlueprint:isSidePlatformBottom() then
        trackBlueprint:addAsset(t.DECORATION, params:getTrackFenceModule(), 48)
    end
end

function Helper.placeOppositeEntranceOnPlatform(platformBlueprint, params)
    if params:isOppositeEntranceEnabled() and platformBlueprint:getGridX() == 0 and platformBlueprint:isSidePlatformBottom() then
        if platformBlueprint:horizontalSizeIsOdd() then
            platformBlueprint:addAsset(t.BUILDING, 'station/rail/modules/motras_side_building_stairs.module', 36)
        else
            platformBlueprint:addAsset(t.BUILDING, 'station/rail/modules/motras_side_building_stairs.module', 50)
        end
    end
end

function Helper.placeOppositeEntranceOnTracks(trackBlueprint, params)
    if params:isOppositeEntranceEnabled() and trackBlueprint:getGridX() == 0 and trackBlueprint:isSidePlatformBottom() then
        if trackBlueprint:horizontalSizeIsOdd() then
            trackBlueprint:addAsset(t.BUILDING, 'station/rail/modules/motras_side_building_underpass.module', 36)
        else
            trackBlueprint:addAsset(t.BUILDING, 'station/rail/modules/motras_side_building_underpass.module', 50)
        end
    end
end

return Helper