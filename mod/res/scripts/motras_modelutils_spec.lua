local ModelUtils = require('motras_modelutils')

describe('ModelUtils', function ()
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
    end)
end)