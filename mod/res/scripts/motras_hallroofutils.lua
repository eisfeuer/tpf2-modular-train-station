local HallRoofUtils = {}

local function hasMatchingHallRoofAtSlot(slot, gridElement, asset)
    if not gridElement:hasAsset(slot) then
        return false
    end

    local foreignAsset = gridElement:getAsset(slot)

    if asset:getSlotId() == foreignAsset:getSlotId() then
        return false
    end

    return foreignAsset:getOption('hallRoofGroup', 'noGroup') == asset:getOption('hallRoofGroup', 'noGroup')
end

function HallRoofUtils.buildHallRoof(asset, buildFunc)
    if asset:getId() == 53 then
        buildFunc(false, 0)
    elseif asset:getId() == 54 then
        local grid = asset:getGrid()
        for iY = asset:getGridX(), grid:getActiveGridBounds().bottom, -1 do
            local currentGridElement = grid:get(asset:getGridX(), iY)

            if hasMatchingHallRoofAtSlot(53, currentGridElement, asset) then
                buildFunc(true, (asset:getGridY() - iY + 1) * grid:getVerticalDistance())
                return
            elseif hasMatchingHallRoofAtSlot(54, currentGridElement, asset) then
                buildFunc(true, (asset:getGridY() - iY) * grid:getVerticalDistance())
                return
            end
        end

        buildFunc(false, 0)
    else
        error('hall roofes must be placed on hall roof slots')
    end
end

return HallRoofUtils