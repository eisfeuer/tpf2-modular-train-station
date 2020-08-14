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
                if trackFileName ~= "standard.lua" and trackFileName ~= "high_speed.lua" then 
                    local track = api.res.trackTypeRep.get(api.res.trackTypeRep.find(trackFileName))

                    for __, hasCatenary in pairs({false, true}) do
                        local trackModule = api.type.ModuleDesc.new()
                        TrackModuleUtils.assignTrackToModule(trackModule, track, trackFileName, hasCatenary, sortIndex)
                        api.res.moduleRep.add(trackModule.fileName, trackModule, true)
                    end
                end
            end

            -- local styleList = {}

            -- local findStyle = function (styleList, styleName)
            --     for pos, style in ipairs(styleList) do
            --         if styleName == style.metadata.name then
            --             return style
            --         end
            --     end

            --     local style = {
            --         metadata = {
            --             name = styleName
            --         }
            --     }
            --     table.insert(styleList, style)

            --     return style
            -- end

            -- for _, moduleFile in pairs(api.res.moduleRep.getAll()) do
            --     local conModule = api.res.moduleRep.get(api.res.moduleRep.find(moduleFile))
            --     if conModule.metadata and conModule.metadata.motras_style_group and conModule.metadata.motras_style_type then
            --         local style = findStyle(styleList, conModule.metadata.motras_style_group)
            --         style[conModule.metadata.motras_style_type] = moduleFile
            --     end
            -- end

            local stylelist = Stylelist:new()
            stylelist:collectFromModules()

            local motrasStation = api.res.constructionRep.get(api.res.constructionRep.find('station/rail/motras.con'))
            motrasStation.createTemplateScript.fileName = "construction/station/rail/motras.createTemplateFn"
            motrasStation.createTemplateScript.params = {themes = stylelist:get()}
        end
    }
    end
    