local RepositoryParam = require('motras_repository_param')
local TestUtils = require('motras_testutils')

describe('RepositoryParam', function ()
    TestUtils.mockTranslations()

    describe('getType', function ()
        it ('has BUTTON as default type', function ()
            local repoParam = RepositoryParam:new{key = 'repo_param'}
            assert.are.equal('BUTTON', repoParam:getType())
        end)

        it('change type of param', function ()
            local repoParam = RepositoryParam:new{key = 'repo_param', type = 'SLIDER'}
            assert.are.equal('SLIDER', repoParam:getType())
        end)
    end)

    describe('getName', function ()
        it('has key as name when no name is set', function ()
            local repoParam = RepositoryParam:new{key = 'repo_param'}
            assert.are.equal('repo_param', repoParam:getName())
        end)

        it('has custom name', function ()
            local repoParam = RepositoryParam:new{key = 'repo_param', name = 'translated_name'}
            assert.are.equal('translated_name', repoParam:getName())
        end)
    end)

    describe('getDefaultIndex', function ()
        it('has 0 as default index by default', function ()
            local repoParam = RepositoryParam:new{key = 'repo_param'}
            assert.are.equal(0, repoParam:getDefaultIndex())
        end)

        it('has custum default index', function ()
            local repoParam = RepositoryParam:new{key = 'repo_param', defaultIndex = 3}
            assert.are.equal(3, repoParam:getDefaultIndex())
        end)
    end)

    describe('addRepositoryItem / addToParams / getValues', function ()
        it('adds nothing to params when no value is added', function ()
            local repoParam = RepositoryParam:new{key = 'repo_param'}

            local params = {}
            repoParam:addToParams(params)

            assert.are.same({}, params)
            assert.are.same({'station/rail/modules/motras_track_train_normal.module'}, repoParam:getValues(1975))
        end)

        it('adds repository entry to param', function ()
            local repoParam = RepositoryParam:new{key = 'repo_param'}
            repoParam:addRepositoryItem("s_bahn_hamburg_catenary.lua", {
                name = 'S-Bahn Hamburg (Catenary)',
                yearFrom = 0,
                yearTo = 1939
            })
            repoParam:addRepositoryItem("s_bahn_hamburg_3rdrail.lua", {
                name = 'S-Bahn Hamburg (Third Rails)',
                yearFrom = 1939,
                yearTo = 0
            })

            local params = {}
            repoParam:addToParams(params)

            assert.are.same({{
                key = 'repo_param',
                name = 'repo_param',
                values = { 'S-Bahn Hamburg (Catenary)' },
                yearFrom = 0,
                yearTo = 1939,
                uiType = 'BUTTON',
                defaultIndex = 0
            }, {
                key = 'repo_param',
                name = 'repo_param',
                values = { 'S-Bahn Hamburg (Third Rails)' },
                yearFrom = 1939,
                yearTo = 0,
                uiType = 'BUTTON',
                defaultIndex = 0
            }}, params)

            assert.are.same({'s_bahn_hamburg_3rdrail.lua'}, repoParam:getValues(2020))
            assert.are.same({'s_bahn_hamburg_catenary.lua'}, repoParam:getValues(1920))
        end)

        it('adds and reorganizes categories', function ()
            local repoParam = RepositoryParam:new{key = 'repo_param'}
            repoParam:addRepositoryItem("s_bahn_hamburg_catenary.lua", {
                name = 'S-Bahn Hamburg (Catenary)',
                yearFrom = 0,
                yearTo = 1939
            })
            repoParam:addRepositoryItem("s_bahn_hamburg_3rdrail.lua", {
                name = 'S-Bahn Hamburg (Third Rails)',
                yearFrom = 1939,
                yearTo = 0
            })

            local params = {}
            repoParam:addToParams(params)

            assert.are.same({{
                key = 'repo_param',
                name = 'repo_param',
                values = { 'S-Bahn Hamburg (Catenary)' },
                yearFrom = 0,
                yearTo = 1939,
                uiType = 'BUTTON',
                defaultIndex = 0
            }, {
                key = 'repo_param',
                name = 'repo_param',
                values = { 'S-Bahn Hamburg (Third Rails)' },
                yearFrom = 1939,
                yearTo = 0,
                uiType = 'BUTTON',
                defaultIndex = 0
            }}, params)

            repoParam:addRepositoryItem("custom_track.lua", {
                name = 'Another custom Track',
                yearFrom = 1930,
                yearTo = 1950
            })

            params = {}
            repoParam:addToParams(params)

            assert.are.same({{
                key = 'repo_param',
                name = 'repo_param',
                values = { 'S-Bahn Hamburg (Catenary)' },
                yearFrom = 0,
                yearTo = 1930,
                uiType = 'BUTTON',
                defaultIndex = 0
            }, {
                key = 'repo_param',
                name = 'repo_param',
                values = { 'S-Bahn Hamburg (Catenary)', 'Another custom Track' },
                yearFrom = 1930,
                yearTo = 1939,
                uiType = 'BUTTON',
                defaultIndex = 0
            }, {
                key = 'repo_param',
                name = 'repo_param',
                values = { 'Another custom Track', 'S-Bahn Hamburg (Third Rails)' },
                yearFrom = 1939,
                yearTo = 1950,
                uiType = 'BUTTON',
                defaultIndex = 0
            }, {
                key = 'repo_param',
                name = 'repo_param',
                values = { 'S-Bahn Hamburg (Third Rails)' },
                yearFrom = 1950,
                yearTo = 0,
                uiType = 'BUTTON',
                defaultIndex = 0
            }}, params)

            assert.are.same({'s_bahn_hamburg_catenary.lua'}, repoParam:getValues(1920))
            assert.are.same({'s_bahn_hamburg_catenary.lua', 'custom_track.lua'}, repoParam:getValues(1931))
            assert.are.same({'custom_track.lua', 's_bahn_hamburg_3rdrail.lua'}, repoParam:getValues(1940))
            assert.are.same({'s_bahn_hamburg_3rdrail.lua'}, repoParam:getValues(1955))
        end)
    end)
end)