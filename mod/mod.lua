local TrackModuleUtils = require('motras_trackmoduleutils')
local Stylelist = require('motras_gamescript.stylelist')

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
            local tracks = api.res.trackTypeRep.getAll()
            
            for sortIndex, trackFileName in ipairs(tracks) do
                local track = api.res.trackTypeRep.get(api.res.trackTypeRep.find(trackFileName))

                if trackFileName ~= "standard.lua" and trackFileName ~= "high_speed.lua" then 
                    for __, hasCatenary in pairs({false, true}) do
                        local trackModule = api.type.ModuleDesc.new()
                        TrackModuleUtils.assignTrackToModule(trackModule, track, trackFileName, hasCatenary, sortIndex)
                        api.res.moduleRep.add(trackModule.fileName, trackModule, true)
                    end
                end

                for __, hasCatenary in pairs({false, true}) do
                    local zigZagModule = api.type.ModuleDesc.new()
                    TrackModuleUtils.assignZigZagToModule(zigZagModule, track, trackFileName, hasCatenary, sortIndex)
                    api.res.moduleRep.add(zigZagModule.fileName, zigZagModule, true)
                end
            end

            local stylelist = Stylelist:new()
            stylelist:collectFromModules()

            local motrasStation = api.res.constructionRep.get(api.res.constructionRep.find('station/rail/motras.con'))
            motrasStation.createTemplateScript.fileName = "construction/station/rail/motras.createTemplateFn"
            motrasStation.createTemplateScript.params = {themes = stylelist:get()}
        end
    }
    end
    