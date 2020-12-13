local TrackModuleUtils = require('motras_trackmoduleutils')
local ThemeRepository = require('motras_theme_repository')
local TrackRepository = require('motras_track_repository')

local function starts_with(str, start)
    return str:sub(1, #start) == start
end

local function addParamsTo(params, paramsToAdd)
	for _, param in pairs(paramsToAdd) do
		local newParam = api.type.ScriptParam.new()

		newParam.key = param.key
		newParam.name = param.name
		newParam.tooltip = param.tooltip
		newParam.values = param.values
		newParam.yearFrom = param.yearFrom
		newParam.yearTo = param.yearTo
		newParam.defaultIndex = param.defaultIndex
		newParam.uiType = 0

		params[#params+1] = newParam 
	end
end

function data()
    return {
        info = {
            minorVersion = 0,
            severityAdd = "NONE",
            severityRemove = "NONE",
            name = _("MOTRAS Base Kit"),
            description = _("motras_mod_desc"),
            tags = { "Train Station" },
            authors = {
                {
                    name = "EISFEUER",
                    role = 'CREATOR',
                },
            },
            params = {
                {
                    key = "motras_initial_platform_height",
                    uiType = "COMBOBOX",
                    name = _("initial_platform_height_in_mm"),
                    values = { _("default_platform_height"), _("200"), _("250"), _("350"), _("380"), _("550"), _("580"), _("635"), _("680"), _("730"), _("760"), _("840"), _("900"), _("915"), _("920"), _("960"), _("1060"), _("1080"), _("1100"), _("1150"), _("1219"), _("1250")},
                    defaultIndex = 0
                },
            },
        },
        postRunFn = function(settings, params)
            -- Create Track Repository
            local trackRepository = TrackRepository:new{}
            trackRepository:addTrack(api.res.moduleRep.get(api.res.moduleRep.find('station/rail/modules/motras_track_train_normal.module')), false)
            trackRepository:addTrack(api.res.moduleRep.get(api.res.moduleRep.find('station/rail/modules/motras_track_train_normal_catenary.module')), true)
            trackRepository:addTrack(api.res.moduleRep.get(api.res.moduleRep.find('station/rail/modules/motras_track_train_high_speed.module')), false)
            trackRepository:addTrack(api.res.moduleRep.get(api.res.moduleRep.find('station/rail/modules/motras_track_train_high_speed_catenary.module')), true)

            -- Create Track Modules
            local tracks = api.res.trackTypeRep.getAll()

            for sortIndex, trackFileName in ipairs(tracks) do
                local track = api.res.trackTypeRep.get(api.res.trackTypeRep.find(trackFileName))
                if trackFileName ~= "standard.lua" and trackFileName ~= "high_speed.lua" then 
                    for __, hasCatenary in pairs({false, true}) do
                        local trackModule = api.type.ModuleDesc.new()
                        TrackModuleUtils.assignTrackToModule(trackModule, track, trackFileName, hasCatenary, sortIndex)
                        api.res.moduleRep.add(trackModule.fileName, trackModule, true)
                        trackRepository:addTrack(trackModule, hasCatenary)
                    end
                end

                for __, hasCatenary in pairs({false, true}) do
                    local zigZagModule = api.type.ModuleDesc.new()
                    TrackModuleUtils.assignZigZagToModule(zigZagModule, track, trackFileName, hasCatenary, sortIndex)
                    api.res.moduleRep.add(zigZagModule.fileName, zigZagModule, true)
                end
            end

            -- Import Themes
            local modulesInGame = api.res.moduleRep.getAll()
            local themeRepository = ThemeRepository:new{defaultTheme = 'era_c', paramName = _("modutram_theme"), tooltip = _("modutram_theme_tooltip")}

            for _, moduleFileName in ipairs(modulesInGame) do
                local module = api.res.moduleRep.get(api.res.moduleRep.find(moduleFileName))
                if starts_with(module.type, "motras_") then
                    themeRepository:addModule(moduleFileName, module)
                end
            end

            -- Get Station
            local motrasStation = api.res.constructionRep.get(api.res.constructionRep.find('station/rail/motras.con'))
            

            -- Add Theme and Track Param
            local themeParams = themeRepository:getConstructionParams()
            local trackParams = trackRepository:getConstructionParams()

            for i, template in pairs(motrasStation.constructionTemplates) do
                local dynamicConstructionTemplate = api.type.DynamicConstructionTemplate.new()

                local originalParams = template.data.params
                local params = {}
                params[#params+1] = originalParams[1]

                addParamsTo(params, trackParams)

                for iParam = 3, #originalParams do
                    params[#params+1] = originalParams[iParam]
                end

                addParamsTo(params, themeParams)

                for iParam, param in pairs(params) do
                    dynamicConstructionTemplate.params[iParam] = param
                end
                motrasStation.constructionTemplates[i].data = dynamicConstructionTemplate 
            end

            -- Assign script files
            motrasStation.createTemplateScript.fileName = "construction/station/rail/motras.createTemplateFn"
            motrasStation.createTemplateScript.params = {themes = themeRepository:getRepositoryTable(), defaultTheme = themeRepository:getDefaultTheme() }
        end
    }
    end
    