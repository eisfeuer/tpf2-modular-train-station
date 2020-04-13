local TestUtils = require('motras_testutils')
local ParamUtils = require('motras_paramutils')

describe('ParamUtils', function ()
    describe('addCommonApiTrackParams', function ()
        
        it('adds nothing when commonapi is not installed', function ()
            local params = {}
            
            ParamUtils.addCommonApiTrackParams(params)

            assert.are.same({}, params)
        end)

        it('adds tracks from commonapi', function ()
            TestUtils.mockTranslations()
            TestUtils.mockCommonApi({
                tracks = {{
                    data = {
                        name = 'S-Bahn Hamburg (Catenary)',
                        yearFrom = 0,
                        yearTo = 1939
                    },
                    filename = "s_bahn_hamburg_catenary.lua"
                }, {
                    data = {
                        name = 'S-Bahn Hamburg (Third Rails)',
                        yearFrom = 1939,
                        yearTo = 0
                    },
                    filename = "s_bahn_hamburg_3rdrail.lua"
                }, {
                    data = {
                        name = 'Transrapid',
                        yearFrom = 1983,
                        yearTo = 0
                    },
                    filename = "transrapid.lua"
                }, {
                    data = {
                        name = 'Transrapid 2',
                        yearFrom = 1983,
                        yearTo = 0
                    },
                    filename = "transrapid_2.lua"
                },  {
                    data = {
                        name = 'Hidden Track',
                        yearFrom = 1000,
                        yearTo = 1500
                    },
                    filename = "hidden_track.lua"
                }, {
                    data = {
                        name = 'Wuppertaler Schwebebahn',
                        yearFrom = 1901,
                        yearTo = 0
                    },
                    filename = "wuppertaler_schwebebahn.lua"
                }, {
                    data = {
                        name = 'Liverpool Overhead',
                        yearFrom = 1893,
                        yearTo = 1953
                    },
                    filename = "liverpool_overhead.lua"
                }}
            })

            local params = {}

            local values = ParamUtils.addCommonApiTrackParams(params)

            assert.are.same(
                {'s_bahn_hamburg_catenary.lua', "liverpool_overhead.lua", "wuppertaler_schwebebahn.lua", "s_bahn_hamburg_3rdrail.lua", "transrapid.lua", "transrapid_2.lua"},
                values
            )

            assert.are.same({{
                key = 'motras_track_commonapi_1',
                name = 'motras_track_commonapi_1',
                values = { 'S-Bahn Hamburg (Catenary)' },
                yearFrom = 0,
                yearTo = 1893,
                -- uiType = 'COMBOBOX'
            },{
                key = 'motras_track_commonapi_1',
                name = 'motras_track_commonapi_1',
                values = { 'S-Bahn Hamburg (Catenary)', 'Liverpool Overhead' },
                yearFrom = 1893,
                yearTo = 1901,
                -- uiType = 'COMBOBOX'
            }, {
                key = 'motras_track_commonapi_1',
                name = 'motras_track_commonapi_1',
                values = { 'S-Bahn Hamburg (Catenary)', 'Liverpool Overhead', 'Wuppertaler Schwebebahn' },
                yearFrom = 1901,
                yearTo = 1939,
                -- uiType = 'COMBOBOX'
            }, {
                key = 'motras_track_commonapi_1',
                name = 'motras_track_commonapi_1',
                values = { 'S-Bahn Hamburg (Catenary)', 'Liverpool Overhead', 'Wuppertaler Schwebebahn', 'S-Bahn Hamburg (Third Rails)' },
                yearFrom = 1939,
                yearTo = 1983,
                -- uiType = 'COMBOBOX'
            }, {
                key = 'motras_track_commonapi_1',
                name = 'motras_track_commonapi_1',
                values = { 'S-Bahn Hamburg (Catenary)', 'Liverpool Overhead', 'Wuppertaler Schwebebahn', 'S-Bahn Hamburg (Third Rails)', 'Transrapid', 'Transrapid 2' },
                yearFrom = 1983,
                yearTo = 0,
                -- uiType = 'COMBOBOX'
            }, {
                key = 'motras_track_commonapi_2',
                name = 'motras_track_commonapi_2',
                values = { 'S-Bahn Hamburg (Catenary)' },
                yearFrom = 0,
                yearTo = 1893,
                -- uiType = 'COMBOBOX'
            },{
                key = 'motras_track_commonapi_2',
                name = 'motras_track_commonapi_2',
                values = { 'S-Bahn Hamburg (Catenary)', 'Liverpool Overhead' },
                yearFrom = 1893,
                yearTo = 1901,
                -- uiType = 'COMBOBOX'
            }, {
                key = 'motras_track_commonapi_2',
                name = 'motras_track_commonapi_2',
                values = { 'S-Bahn Hamburg (Catenary)', 'Liverpool Overhead', 'Wuppertaler Schwebebahn' },
                yearFrom = 1901,
                yearTo = 1939,
                -- uiType = 'COMBOBOX'
            }, {
                key = 'motras_track_commonapi_2',
                name = 'motras_track_commonapi_2',
                values = { 'S-Bahn Hamburg (Catenary)', 'Liverpool Overhead', 'Wuppertaler Schwebebahn', 'S-Bahn Hamburg (Third Rails)' },
                yearFrom = 1939,
                yearTo = 1983,
                -- uiType = 'COMBOBOX'
            }, {
                key = 'motras_track_commonapi_2',
                name = 'motras_track_commonapi_2',
                values = { 'S-Bahn Hamburg (Catenary)', 'Liverpool Overhead', 'Wuppertaler Schwebebahn', 'S-Bahn Hamburg (Third Rails)', 'Transrapid', 'Transrapid 2' },
                yearFrom = 1983,
                yearTo = 0,
                -- uiType = 'COMBOBOX'
            }}, params)
        end)

    end)
end)