local PathUtils = require('motras_pathutils')

local UnderpassUtils = {}

function UnderpassUtils.addUnderpassLaneGridToModels(grid, models)
    grid:eachActivePosition(function (gridElement, iX)
        if iX == grid:getActiveGridBounds().left then
            table.insert(models, {
                id = grid:getUnderpassStartModel(),
                transf = {
                    1, 0, 0, 0,
                    0, 1, 0, 0,
                    0, 0, 1, 0,
                    gridElement:getAbsoluteX(), gridElement:getAbsoluteY(), grid:getUnderpassZ(), 1
                }
            })
        end

        table.insert(models, {
            id = grid:getUnderpassRepeatModel(),
            transf = {
                1, 0, 0, 0,
                0, 1, 0, 0,
                0, 0, 1, 0,
                gridElement:getAbsoluteX(), gridElement:getAbsoluteY(), grid:getUnderpassZ(), 1
            }
        })
    end)
end

return UnderpassUtils