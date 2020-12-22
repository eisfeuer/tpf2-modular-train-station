local Theme = require('motras_theme')

local TemplateParams = {}

function TemplateParams:new(o)
    o = o or {}
    o.params = o.params or {}

    setmetatable(o, self)
    self.__index = self

    return o
end

function TemplateParams:getCapturedParams()
    return self.params.capturedParams or {}
end

function TemplateParams:getTrackCount()
    return self.params.motras_tracks + 1
end

function TemplateParams:getHorizontalSize()
    return self.params.motras_length + 1
end

function TemplateParams:getPlatformVerticalSize()
    return self.params.motras_platform_width + 1
end

function TemplateParams:isWidePlatform()
    return self:getPlatformVerticalSize() > 1
end

function TemplateParams:getDefaultThemeComponents()
    if self:getCapturedParams().defaultTheme then
        return self:getCapturedParams().defaultTheme
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

function TemplateParams:getComponents()
    local themes = self:getCapturedParams().themes
    if not themes then
        return {}
    end

    return themes[self.params.motras_theme] or {}
end

function TemplateParams:getTheme()
    if not self.theme then
        self.theme = Theme:new{
            theme = self:getComponents(),
            defaultTheme = self:getDefaultThemeComponents()
        }
    end
    
    return self.theme
end

function TemplateParams:getTrackModule(trackType, catenary)
    local trackModules = self:getCapturedParams().tracks

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

function TemplateParams:isFenceEnabled()
    return self.params.motras_fence_platform > 0
end

function TemplateParams:isTrackFencesEnabled()
    return self.params.motras_fence_track > 0
end

function TemplateParams:getFenceModule()
    local fences = {
        "station/rail/modules/motras_fence_metal_wall_era_c.module",
        "station/rail/modules/motras_fence_metal_railing_era_c.module",
        "station/rail/modules/motras_fence_metal_noise_barrier_era_c.module",
        "station/rail/modules/motras_fence_metal_mesh_wire_era_c.module",
    }

    return fences[self.params.motras_fence_platform]
end

function TemplateParams:getTrackFenceModule()
    local fences = {
        "station/rail/modules/motras_fence_metal_wall_era_c.module",
        "station/rail/modules/motras_fence_metal_railing_era_c.module",
        "station/rail/modules/motras_fence_metal_noise_barrier_era_c.module",
        "station/rail/modules/motras_fence_metal_mesh_wire_era_c.module",
    }

    return fences[self.params.motras_fence_track]
end

function TemplateParams:isOppositeEntranceEnabled()
    return self.params.motras_opposite_entrance > 0
end

return TemplateParams