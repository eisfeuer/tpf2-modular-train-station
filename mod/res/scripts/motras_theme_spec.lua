local Theme = require('motras_theme')

describe('Theme', function ()
    describe('getModuleForComponent', function ()
        it ('returns theme component', function ()
            local theme = Theme:new{
                components = {clock = "a_station_clock.mdl"},
                defaultComponents = {clock = "default_station_clock.mdl"}
            }

            assert.are.equal("a_station_clock.mdl", theme:getModuleForComponent('clock'))
        end)

        it('returns default theme component', function ()
            local theme = Theme:new{
                components = {},
                defaultComponents = {clock = "default_station_clock.mdl"}
            }

            assert.are.equal("default_station_clock.mdl", theme:getModuleForComponent('clock'))
        end)

        it('returns alternative', function ()
            local theme = Theme:new{
                components = {clock = "a_station_clock.mdl"},
                defaultComponents = {clock = "default_station_clock.mdl", destination_display = "destination_display.mdl"}
            }

            assert.are.equal("a_station_clock.mdl", theme:getModuleForComponentOrAlternative('destination_display', 'clock', false))
            assert.are.equal("destination_display.mdl", theme:getModuleForComponentOrAlternative('destination_display', 'clock', true))
        end)

        it('checks whether current theme has component', function ()
            local theme = Theme:new{
                components = {clock = "a_station_clock.mdl"},
                defaultComponents = {clock = "default_station_clock.mdl", destination_display = "destination_display.mdl"}
            }

            assert.is_true(theme:hasComponent('clock'))
            assert.is_false(theme:hasComponent('destination_display'))

            assert.is_true(theme:hasComponent('destination_display', true))
        end)
        
    end)
end)