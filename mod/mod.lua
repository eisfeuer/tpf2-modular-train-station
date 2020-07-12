local TrackModuleUtils = require('motras_trackmoduleutils')

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
        -- runFn = function (settings, globalParams)
        --     local modParams = globalParams[getCurrentModId()]
        --     if modParams.motras_initial_platform_height and modParams.motras_initial_platform_height > 0 then
        --         addModifier("loadConstruction", function (fileName, data)
        --             if fileName == "res/construction/station/rail/motras.con" then
        --                 for _, template in ipairs(data.constructionTemplates) do
        --                     if template.data and template.data.params then
        --                         for _, param in ipairs(template.data.params) do
        --                             if param.key == "motras_platform_height" then
        --                                 param.defaultIndex = modParams.motras_initial_platform_height
        --                             end
        --                         end
        --                     end
        --                 end
        --                 print(require('inspect')(data))
        --             end

        --             return data
        --         end)
        --     end
        -- end,
        postRunFn = function(settings, params)
            local tracks = api.res.trackTypeRep.getAll()
            
            for sortIndex, trackFileName in ipairs(tracks) do
                if trackFileName ~= "standard.lua" and trackFileName ~= "high_speed.lua" then 
                    local track = api.res.trackTypeRep.get(api.res.trackTypeRep.find(trackFileName))

                    for __, hasCatenary in pairs({false, true}) do
                        local trackModule = api.type.ModuleDesc.new()
                        TrackModuleUtils.assignTrackToModule(trackModule, track, trackFileName, hasCatenary, sortIndex)
                        api.res.moduleRep.add(trackModule.fileName, trackModule, true)
                    end
                end
            end
        end
    }
    end
    