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
                -- {
                -- key = "motras_tracks",
                -- name = _("Tracks"),
                -- values = { _("1"), _("2"), _("3"), _("4"), _("5"), _("6"), _("7"), _("8"),  _("9"), _("10"), _("11"), _("12") },
                -- defaultIndex = 0,
                -- }
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
        end
    }
    end
    