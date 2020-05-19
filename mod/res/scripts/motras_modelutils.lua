local ModelUtils = {}

function ModelUtils.makeTaggedModel(modelId, transf, tag)
    if tag then
        return {
            id = modelId,
            transf = transf,
            tag = tag
        }
    end
    return {
        id = modelId,
        transf = transf
    }
end

function ModelUtils.addLabeledModel(result, modelId, labels, transf, tag)
    if not result.models then
        error("Result table has no models entry")
    end

    if not result.labelText then
        error("Result table has no lableText entry")
    end

    local labelTextModelId = #result.models

    result.labelText[labelTextModelId] = labels
    if tag then
        table.insert(result.models, {
            id = modelId,
            transf = transf,
            tag = tag
        })
    else
        table.insert(result.models, {
            id = modelId,
            transf = transf
        })
    end
end

return ModelUtils