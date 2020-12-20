local Theme = require("motras_theme")

describe("Theme", function ()
    local theme = Theme:new{
        theme = {
            platformLeft = {
                moduleName = "hamburg_platform_left.module",
            },
            metadata = {
                excludes = { "shelter" }
            },
            billboard = {
                moduleName = "billboard.module"
            }
        },
        defaultTheme = {
            platformLeft = {
                moduleName = "platform_left.module",
            },
            platformRight = {
                moduleName = "platform_right.module",
            },
            shelter = {
                moduleName = "shelter.module",
            },
            schedule = {
                moduleName = "schedule.module"
            },
            metadata = {}
        }
    }

    describe("get", function ()
        it ("returns theme module", function ()
            assert.are.equal("hamburg_platform_left.module", theme:get("platformLeft"))
        end)    

        it ("returns default when module is not available in given theme", function ()
            assert.are.equal("platform_right.module", theme:get("platformRight"))
        end)
    end)

    describe("has", function ()
        it ("checks whether there is a module for given theme type", function ()
            assert.is_true(theme:has("platformLeft"))
            assert.is_false(theme:has("platformIsland"))
        end)

        it ("returns false when given theme type is excluded", function ()
            assert.is_false(theme:has("shelter"))
        end)
    end)

    describe("getWithAlternative", function ()
        it ("returns module", function ()
            assert.are.equal("billboard.module", theme:getWithAlternative("billboard", "schedule"))
        end)

        it ("returns alternative module", function ()
            assert.are.equal("billboard.module", theme:getWithAlternative("schedule", "billboard"))
        end)

        it ("returns alternative default", function ()
            assert.are.equal("schedule.module", theme:getWithAlternative("infoboard", "schedule"))
        end)
    end)
end)