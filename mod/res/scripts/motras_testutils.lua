local env = require('env')
local TestUtils = {}

function TestUtils.mockCommonApi(options)
    commonapi = {}

    if options then
        if options.tracks then
            commonapi['repos'] = {
                track = {
                    getEntries = function ()
                        return options.tracks
                    end
                }
            }
        end
    end
end

function TestUtils.loadTpf2Libs()
    package.path = package.path .. ';' .. env.transportFever2Path .. '/?.lua'
end

function TestUtils.mockTranslations()
    _ = function (translation)
        return translation
    end
end

return TestUtils