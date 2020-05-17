local ModelUtils = {}

function ModelUtils.addLabeledModel(result, modelId, labels, transf)
    if not result.models then
        error("Result table has no models entry")
    end

    if not result.labelText then
        error("Result table has no lableText entry")
    end

    local labelTextModelId = #result.models

    result.labelText[labelTextModelId] = labels
    table.insert(result.models, {
        id = modelId,
        transf = transf
    })
end

return ModelUtils