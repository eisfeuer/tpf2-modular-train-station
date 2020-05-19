local ModelUtils = require('motras_modelutils')

describe('ModelUtils', function ()
    describe('makeTaggedModel', function ()
        local transf = {
            1, 0, 0, 0,
            0, 1, 0, 0,
            0, 0, 1, 0,
            0, 0, 0, 1,
        }
        it ('makes tagged model', function ()
            assert.are.same({
                id = 'model.mdl',
                transf = transf,
                tag = 'katze'
            }, ModelUtils.makeTaggedModel('model.mdl', transf, 'katze'))
        end)

        it ('makes untagged model', function ()
            assert.are.same({
                id = 'model.mdl',
                transf = transf,
            }, ModelUtils.makeTaggedModel('model.mdl', transf, nil))
        end)
    end)

    describe('addLabeledModel', function ()
        it ('add labeled model to results', function ()
            local result = {
                labelText = {},
                models = {{
                    id = 'a_model.mdl',
                    transf = {
                        1, 0, 0, 0,
                        0, 1, 0, 0,
                        0, 0, 1, 0,
                        0, 0, 0, 1,
                    }
                }}
            }

            ModelUtils.addLabeledModel(result, 'labeled_model.mdl', {"Katze"}, {
                1, 0, 0, 0,
                0, 1, 0, 0,
                0, 0, 1, 0,
                0, 0, 0, 1,
            })

            assert.are.same({
                labelText = {
                    [1] = {"Katze"}
                },
                models = {{
                    id = 'a_model.mdl',
                    transf = {
                        1, 0, 0, 0,
                        0, 1, 0, 0,
                        0, 0, 1, 0,
                        0, 0, 0, 1,
                    }
                }, {
                    id = 'labeled_model.mdl',
                    transf = {
                        1, 0, 0, 0,
                        0, 1, 0, 0,
                        0, 0, 1, 0,
                        0, 0, 0, 1,
                    }
                }}
            }, result)
        end)

        it ('add labeled model with tag to results', function ()
            local result = {
                labelText = {},
                models = {{
                    id = 'a_model.mdl',
                    transf = {
                        1, 0, 0, 0,
                        0, 1, 0, 0,
                        0, 0, 1, 0,
                        0, 0, 0, 1,
                    }
                }}
            }

            ModelUtils.addLabeledModel(result, 'labeled_model.mdl', {"Katze"},  {
                1, 0, 0, 0,
                0, 1, 0, 0,
                0, 0, 1, 0,
                0, 0, 0, 1,
            }, 'katze')

            assert.are.same({
                labelText = {
                    [1] = {"Katze"}
                },
                models = {{
                    id = 'a_model.mdl',
                    transf = {
                        1, 0, 0, 0,
                        0, 1, 0, 0,
                        0, 0, 1, 0,
                        0, 0, 0, 1,
                    }
                }, {
                    id = 'labeled_model.mdl',
                    transf = {
                        1, 0, 0, 0,
                        0, 1, 0, 0,
                        0, 0, 1, 0,
                        0, 0, 0, 1,
                    },
                    tag = 'katze'
                }}
            }, result)
        end)
    end)
end)