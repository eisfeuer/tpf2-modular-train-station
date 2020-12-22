local Blueprint = require('motras_blueprint')
local templateHelper = require("motras_templates.helpers")
local TemplateParams = require("motras_templates.template_params")
local t = require("motras_types")

local MiddlePlatformStation = {}

function MiddlePlatformStation:new(o)
    o = o or {}
    o.params = TemplateParams:new{params = o.params or {}}

    setmetatable(o, self)
    self.__index = self

    return o
end

function MiddlePlatformStation:placeDecoration(platformBlueprint)
    if self.params:getPlatformVerticalSize() > 1 and platformBlueprint:isIslandPlatform() then
        if platformBlueprint:hasIslandPlatformSlots() then
            if platformBlueprint:horizontalSizeIsEven() then
                if platformBlueprint:getGridX() == -1 then
                    platformBlueprint:addAsset(t.DECORATION, self.params:getTheme():get('benches_and_trashbin'), 41)
                    if self.params:getTheme():has('ticket_validator') then
                        platformBlueprint:addAsset(t.DECORATION, self.params:getTheme():get('ticket_validator'), 42)
                    end
                    if self.params:getTheme():has('ticket_mashine') then
                        platformBlueprint:addAsset(t.DECORATION, self.params:getTheme():get('ticket_mashine'), 44)
                    end
                elseif platformBlueprint:getGridX() == 0 then
                    platformBlueprint:addAsset(t.DECORATION, self.params:getTheme():get('benches_and_trashbin'), 44)
                    if self.params:getTheme():has('ticket_validator') then
                        platformBlueprint:addAsset(t.DECORATION, self.params:getTheme():get('ticket_validator'), 43)
                    end
                    if self.params:getTheme():has('infoboard_large') or self.params:getTheme():has('infoboard') then
                        platformBlueprint:addAsset(t.DECORATION, self.params:getTheme():getWithAlternative('infoboard_large', 'infoboard'), 41)
                    end
                else
                    platformBlueprint:addAsset(t.DECORATION, self.params:getTheme():get('benches_and_trashbin'), 42)
                    platformBlueprint:addAsset(t.DECORATION, self.params:getTheme():get('benches_and_trashbin'), 43)
                end
            elseif platformBlueprint:getGridX() ~= 0 then
                platformBlueprint:addAsset(t.DECORATION, self.params:getTheme():get('benches_and_trashbin'), 42)
                platformBlueprint:addAsset(t.DECORATION, self.params:getTheme():get('benches_and_trashbin'), 43)

                if self.params:getTheme():has('ticket_validator') then
                    if platformBlueprint:getGridX() == -1 then
                        platformBlueprint:addAsset(t.DECORATION, self.params:getTheme():get('ticket_validator'), 44)
                    end
                    if platformBlueprint:getGridX() == 1 then
                        platformBlueprint:addAsset(t.DECORATION, self.params:getTheme():get('ticket_validator'), 41)
                    end
                end
            else
                if self.params:getTheme():has('ticket_mashine') then
                    platformBlueprint:addAsset(t.DECORATION, self.params:getTheme():get('ticket_mashine'), 42)
                end
                if self.params:getTheme():has('infoboard_large') or self.params:getTheme():has('infoboard') then
                    platformBlueprint:addAsset(t.DECORATION, self.params:getTheme():getWithAlternative('infoboard_large', 'infoboard'), 43)
                end
            end
        end
    else
        if platformBlueprint:horizontalSizeIsEven() then
            if platformBlueprint:getGridX() == -1 then
                platformBlueprint:addAsset(t.DECORATION, self.params:getTheme():get('benches_and_trashbin'), 37)
                if self.params:getTheme():has('ticket_validator') then
                    platformBlueprint:addAsset(t.DECORATION, self.params:getTheme():get('ticket_validator'), 38)
                end
                if self.params:getTheme():has('ticket_mashine') then
                    platformBlueprint:addAsset(t.DECORATION, self.params:getTheme():get('ticket_mashine'), 40)
                end
            elseif platformBlueprint:getGridX() == 0 then
                platformBlueprint:addAsset(t.DECORATION, self.params:getTheme():get('benches_and_trashbin'), 40)
                if self.params:getTheme():has('ticket_validator') then
                    platformBlueprint:addAsset(t.DECORATION, self.params:getTheme():get('ticket_validator'), 39)
                end
                if self.params:getTheme():has('infoboard_large') or self.params:getTheme():has('infoboard') then
                    platformBlueprint:addAsset(t.DECORATION, self.params:getTheme():getWithAlternative('infoboard_large', 'infoboard'), 37)
                end
            else
                platformBlueprint:addAsset(t.DECORATION, self.params:getTheme():get('benches_and_trashbin'), 38)
                platformBlueprint:addAsset(t.DECORATION, self.params:getTheme():get('benches_and_trashbin'), 39)
            end
        elseif platformBlueprint:getGridX() ~= 0 then
            if self.params:getTheme():has('ticket_validator') then
                if platformBlueprint:getGridX() == -1 then
                    platformBlueprint:addAsset(t.DECORATION, self.params:getTheme():get('ticket_validator'), 40)
                end
                if platformBlueprint:getGridX() == 1 then
                    platformBlueprint:addAsset(t.DECORATION, self.params:getTheme():get('ticket_validator'), 37)
                end
            end
            platformBlueprint:addAsset(t.DECORATION, self.params:getTheme():get('benches_and_trashbin'), 38)
            platformBlueprint:addAsset(t.DECORATION, self.params:getTheme():get('benches_and_trashbin'), 39)
        else
            if self.params:getTheme():has('ticket_mashine') then
                platformBlueprint:addAsset(t.DECORATION, self.params:getTheme():get('ticket_mashine'), 38)
            end
            if self.params:getTheme():has('infoboard_large') or self.params:getTheme():has('infoboard') then
                platformBlueprint:addAsset(t.DECORATION, self.params:getTheme():getWithAlternative('infoboard_large', 'infoboard'), 39)
            end
        end
    end
end

function MiddlePlatformStation:placeBuilding(trackBlueprint)
    if self.params.params.motras_middle_platform_station_building > 0 and trackBlueprint:isSidePlatformTop() then
        if trackBlueprint:horizontalSizeIsOdd()  and trackBlueprint:getGridX() == 0 then
            trackBlueprint:addAsset(t.BUILDING, 'station/rail/modules/motras_side_building_underpass.module', 35)
        elseif trackBlueprint:horizontalSizeIsEven() and trackBlueprint:getGridX() == -1 then
            trackBlueprint:addAsset(t.BUILDING, 'station/rail/modules/motras_side_building_underpass.module', 49)
        end
    end
end

function MiddlePlatformStation:toTpf2Template()
    local blueprint = Blueprint:new{}:decorateEachPlatform(function(platformBlueprint)
        templateHelper.placeUnderpass(platformBlueprint, self.params)
        templateHelper.placeRoof(platformBlueprint, self.params)
        self:placeDecoration(platformBlueprint)
        templateHelper.placeFencesOnPlatform(platformBlueprint, self.params)
        templateHelper.placeOppositeEntranceOnPlatform(platformBlueprint, self.params)
    end):decorateEachTrack(function(trackBlueprint)
        self:placeBuilding(trackBlueprint)
       templateHelper.placeFencesOnTracks(trackBlueprint, self.params)
       templateHelper.placeOppositeEntranceOnTracks(trackBlueprint, self.params)
    end):createStation(templateHelper.getPattern(self.params, true))

    return blueprint:toTpf2Template()
end

return MiddlePlatformStation