local Slot = require("motras_slot")
local t = require("motras_types")

local TrackUpgdateUtils = {}

function TrackUpgdateUtils.upgradeFromParams(params)
    if not (params.modules and params.slotId) then
        return {}
    end

    if not (params.modules[params.slotId] and params.modules[params.slotId].metadata) then
        return {}
    end

    local affectedModules = TrackUpgdateUtils.filterAffectedModules(params.modules, params.slotId)

    if params.catenaryToggle == 1 and type(params.modules[params.slotId].metadata.motras_electrified) == 'boolean' then
        return TrackUpgdateUtils.toggleElectrification(affectedModules, not params.modules[params.slotId].metadata.motras_electrified)
    end

    if params.trackTypeToggle == 1 and type(params.modules[params.slotId].metadata.motras_highspeed) == 'boolean' then
        return TrackUpgdateUtils.toggleHighspeed(affectedModules, not params.modules[params.slotId].metadata.motras_highspeed)
    end

    return {}
end

function TrackUpgdateUtils.filterAffectedModules(modules, slotId)
    local trackInterruptionLeft = nil
    local trackInterruptionRight = nil
    local matchingModules = {}
    local slot = Slot:new{id = slotId}

    for moduleSlotId, module in pairs(modules) do
        local moduleSlot = Slot:new{id = moduleSlotId}
        if moduleSlot.gridY == slot.gridY then
            if moduleSlot.gridType == t.GRID_TRACK then
                matchingModules[moduleSlotId] = module
            else
                if moduleSlot.gridX < slot.gridX and ((not trackInterruptionLeft) or moduleSlot.gridX > trackInterruptionLeft) then
                    trackInterruptionLeft = moduleSlot.gridX
                end
                if moduleSlot.gridX > slot.gridX and ((not trackInterruptionRight) or moduleSlot.gridX < trackInterruptionRight) then
                    trackInterruptionRight = moduleSlot.gridX
                end
            end
        end
    end

    local finalMatchingModules = {}
    for moduleSlotId, module in pairs(matchingModules) do
        local moduleSlot = Slot:new{id = moduleSlotId}
        if ((not trackInterruptionLeft) or moduleSlot.gridX > trackInterruptionLeft) and ((not trackInterruptionRight) or moduleSlot.gridX < trackInterruptionRight) then
            finalMatchingModules[moduleSlotId] = module
        end
    end

    return finalMatchingModules
end

function TrackUpgdateUtils.toggleElectrification(modules, shouldElectrify)
    local moduleChanges = {}

    for slotId, trackModule in pairs(modules) do
        if trackModule.metadata
            and trackModule.metadata.motras_toggleElectrificationTo
            and trackModule.metadata.motras_electrified == not shouldElectrify
        then
            table.insert(moduleChanges, {slotId, trackModule.metadata.motras_toggleElectrificationTo})
        end
    end

    return moduleChanges
end

function TrackUpgdateUtils.toggleHighspeed(modules, shouldLevelUp)
    local moduleChanges = {}

    for slotId, trackModule in pairs(modules) do
        if trackModule.metadata
            and trackModule.metadata.motras_toggleHighspeedTo
            and trackModule.metadata.motras_highspeed == not shouldLevelUp
        then
            table.insert(moduleChanges, {slotId, trackModule.metadata.motras_toggleHighspeedTo})
        end
    end

    return moduleChanges
end

return TrackUpgdateUtils