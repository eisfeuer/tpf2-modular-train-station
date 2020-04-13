local ParamUtils = {}

local function clone(t)
    local result = {}
    for index, value in ipairs(t) do
        table.insert(result, value)
    end

    return result
end

function ParamUtils.addCommonApiTrackParams(params)
    if not ParamUtils.commonapiTrackSupportEnabled() then
        return {}
    end

    local trackEntries = commonapi.repos.track.getEntries()

    if #trackEntries == 0 then
        return {}
    end

    if #trackEntries == 1 then
        table.insert(params, {
            key = 'motras_track_commonapi_1',
            name = _('motras_track_commonapi_1'),
            values = { trackEntries[1].data.name },
            yearFrom = trackEntries[1].data.yearFrom,
            yearTo = trackEntries[1].data.yearTo,
            uiType = "COMBOBOX",
        })
        return {{trackEntries[1].filename}}
    end

    table.sort(trackEntries, function (a, b)
        if not a.data and a.data.yearFrom then
            return b
        end

        if not b.data and b.data.yearFrom then
            return a
        end

        return a.data.yearFrom < b.data.yearFrom
    end)

    local result = {}
    local values = {}

    for openapiTrackId = 1, 2 do
        result = {}
        values = {}

        for i = 1, #trackEntries do
            local track = trackEntries[i]
            if track.data.yearTo == 0 or track.data.yearTo >= 1850 then
                table.insert(result, track.filename)
                table.insert(values, track.data.name)
                if #result == 1 or params[#params].yearFrom < track.data.yearFrom then
                    table.insert(params, {
                        key = 'motras_track_commonapi_' .. openapiTrackId,
                        name = _('motras_track_commonapi_' .. openapiTrackId),
                        values = clone(values),
                        yearFrom = trackEntries[i].data.yearFrom,
                        yearTo = trackEntries[i + 1] and trackEntries[i + 1].data.yearFrom or 0,
                        --uiType = "COMBOBOX",
                    })
                else
                    params[#params].values = clone(values)
                    params[#params].yearTo = trackEntries[i + 1] and trackEntries[i + 1].data.yearFrom or 0
                end
            elseif #result > 0 then
                params[#params].yearTo = trackEntries[i + 1] and trackEntries[i + 1].data.yearFrom or 0
            end
        end
    end

    return result
end

function ParamUtils.commonapiTrackSupportEnabled()
    return commonapi and commonapi.repos and commonapi.repos.track and commonapi.repos.track.getEntries
end

return ParamUtils