local t = require('motras_types')
local c = require('motras_constants')
local NatBomb = require('natbomb')

local DIGIT_SPACES = {7, 7, 6, 4}

local Slot = {}

local function toSignedId(unsigned_id)
    if unsigned_id then
        return unsigned_id - 64
    end
    return 0
end

function Slot:new (o)
    if not (o and o.id) then
        error("Required Property Id is missing")
    end

    local ids = NatBomb.explode(DIGIT_SPACES, o.id or 0)

    o.type = ids[1] or t.UNKNOWN
    o.gridType = Slot.getGridTypeFromSlotType(o.type)
    o.gridX = toSignedId(ids[2])
    o.gridY = toSignedId(ids[3])
    o.assetId = ids[4] or 0
    o.assetDecorationId = ids[5] or 0

    setmetatable(o, self)
    self.__index = self
    return o
end

function Slot.makeId(options)
    return NatBomb.implode(DIGIT_SPACES, {
        options.type or t.UNKNOWN,
        (options.gridX or 0) + 64,
        (options.gridY or 0) + 64,
        options.assetId or 0,
        options.assetDecorationId or 0
    })
end

function Slot.getGridElementSpacing(grid)
    return {
        grid:getHorizontalDistance() / 2 - 0.01,
        grid:getHorizontalDistance() / 2 - 0.01,
        grid:getVerticalDistance() / 2 - 0.01,
        grid:getVerticalDistance() / 2 - 0.01,
    }
end

function Slot.getGridTypeFromSlotType(slotType)
    return math.floor(slotType / 16)
end

function Slot.addGridSlotsToCollection(slotCollection, grid, slotPlacementClass)
    grid:eachActiveSlotPosition(function(grid, iX, iY) 
        local slotPlacementInstance = slotPlacementClass:new{grid = grid, gridX = iX, gridY = iY}
        if slotPlacementInstance:isPassingPlacementRule() then
            table.insert(slotCollection, slotPlacementInstance:getSlot())
        end
    end)
end

function Slot:getModuleData()
    return self.moduleData or {}
end

function Slot:getOptions()
    local options = {}
    local moduleData = self:getModuleData()

    if moduleData.name then
        options.moduleName = moduleData.name
    end

    if moduleData.metadata then
        for key, value in pairs(moduleData.metadata) do
            if key == 'motras' then
                for k, v in pairs(value) do
                    options[k] = v
                end
            end

            local optionKey =  string.match(key, '^motras_(.*)$')
            if optionKey then
                options[optionKey] = value
            end
        end
    end

    return options
end

function Slot:debug()
    print('ID: ' .. self.id)
    print('Type: ' .. self.type .. '(Grid Type: ' .. self.gridType .. ')')
    print('Grid X: ' .. self.gridX)
    print('Grid Y: ' .. self.gridY)
    print('Asset Id: ' .. self.assetId)
    print('Asset Decoration Id: ' .. self.assetDecorationId)
end

return Slot