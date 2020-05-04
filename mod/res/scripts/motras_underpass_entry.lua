local c = require('motras_constants')
local PathUtils = require('motras_pathutils')

local UnderpassEntry = {}

local SMALL = 1
local LARGE = 2

function UnderpassEntry:new(o)
    o = o or {}
    o.smallUnderpassIds = o.smallUnderpassIds or c.PLATFORM_40M_SMALL_UNDERPATH_SLOT_IDS
    o.largeUnderpassIds = o.largeUnderpassIds or c.PLATFORM_40M_LARGE_UNDERPATH_SLOT_IDS

    setmetatable(o, self)
    self.__index = self
    return o
end

function UnderpassEntry:getId()
    return self:getModule():getId()
end

function UnderpassEntry:getSizeAndSection()
    if self.size and self.section then
        return self.size, self.section
    end

    local underpassModuleId = self:getId()

    for section, underpassSlotId in ipairs(self.smallUnderpassIds) do
        if underpassSlotId == underpassModuleId then
            self.size = SMALL
            self.section = section
            return SMALL, section
        end
    end

    for section, underpassSlotId in ipairs(self.largeUnderpassIds) do
        if underpassSlotId == underpassModuleId then
            self.size = LARGE
            self.section = section
            return LARGE, section
        end
    end

    return nil, nil
end

function UnderpassEntry:getModule()
    return self.underpassModule
end

function UnderpassEntry:getOppositeEntryModule()
    local size, section = self:getSizeAndSection()
    local oppositeSection = 5 - section
    local platform = self:getModule():getParentGridElement()

    if section == 1 or section == 4 then
        return platform:getAsset(self.smallUnderpassIds[oppositeSection])
            or platform:getAsset(self.largeUnderpassIds[oppositeSection])
    end

    local neighbor
    if section == 2 then
        neighbor = platform:getNeighborLeft()
    elseif section == 3 then
        neighbor = platform:getNeighborRight()
    else
        return nil
    end

    if not neighbor:isPlatform() then
        return nil
    end

    return neighbor:getAsset(self.smallUnderpassIds[oppositeSection])
        or neighbor:getAsset(self.largeUnderpassIds[oppositeSection])
end

function UnderpassEntry:getOppositeEntry()
    local underpassModule = self:getOppositeEntryModule()

    if not underpassModule then
        return nil
    end

    return UnderpassEntry:new{underpassModule = underpassModule}
end

function UnderpassEntry:getSmallUnderpassIdInSection(sectionId)
    return self.smallUnderpassIds[sectionId]
end

function UnderpassEntry:getLargeUnderpassIdInSection(sectionId)
    return self.largeUnderpassIds[sectionId]
end

function UnderpassEntry:hasOppositeEntry()
    return self:getOppositeEntryModule() ~= nil
end

function UnderpassEntry:getLaneXPosition()
    local size, section = self:getSizeAndSection()
    local xPos = self:getModule():getParentGridElement():getAbsoluteX()
    
    if section == 2 then
        return xPos - self:getModule():getGrid():getHorizontalDistance() / 2
    end

    if section == 3 then
        return xPos + self:getModule():getGrid():getHorizontalDistance() / 2
    end

    return xPos
end

function UnderpassEntry:getUnderpassFloorHeight()
    return self:getModule():getOption('underpassFloorHeight', 0)
end

function UnderpassEntry:getLaneStartPoint()
    local size = self:getSizeAndSection()
    local platform = self:getModule():getParentGridElement()
    local zPos = platform:getAbsolutePlatformHeight() + self:getUnderpassFloorHeight()
    local yPos = platform:getAbsoluteY()

    if size == SMALL then
        return { x = self:getLaneXPosition(), y = yPos, z = zPos }
    end

    local oppositeEntry = self:getOppositeEntry()
    if not oppositeEntry then
        return { x = self:getLaneXPosition(), y = yPos - platform:getGrid():getVerticalDistance() / 2, z = zPos }
    end

    local oppositeSize = oppositeEntry:getSizeAndSection()
    if oppositeSize == SMALL then
        return { x = self:getLaneXPosition(), y = yPos, z = zPos }
    end

    return { x = self:getLaneXPosition(), y = yPos - platform:getGrid():getVerticalDistance() / 2, z = zPos }
end

function UnderpassEntry:getLaneEndPoint()
    local size = self:getSizeAndSection()
    local platform = self:getModule():getParentGridElement()
    local zPos = platform:getAbsolutePlatformHeight() + self:getUnderpassFloorHeight()
    local yPos = platform:getAbsoluteY()

    if size == LARGE then
        return { x = self:getLaneXPosition(), y = yPos - platform:getGrid():getVerticalDistance() / 2, z = zPos }
    end

    local oppositeEntry = self:getOppositeEntry()
    if not oppositeEntry then
        return { x = self:getLaneXPosition(), y = yPos, z = zPos }
    end

    local oppositeSize = oppositeEntry:getSizeAndSection()
    if oppositeSize == SMALL then
        return { x = self:getLaneXPosition(), y = yPos, z = zPos }
    end

    return { x = self:getLaneXPosition(), y = yPos - platform:getGrid():getVerticalDistance() / 2, z = zPos }
end

function UnderpassEntry:addEntryConnectionLaneToModelsIfNecessary(models)
    local oppositeEntry = self:getOppositeEntry()
    if oppositeEntry then
        local size = self:getSizeAndSection()
        local oppositeSize = oppositeEntry:getSizeAndSection()
        if size ~= oppositeSize then
            table.insert(models, PathUtils.makePassengerPathModel(self:getLaneEndPoint(), self:getLaneStartPoint()))
        end
    end
end

function UnderpassEntry:isMainEntry()
    local size, section = self:getSizeAndSection()
    if not size then
        return false
    end

    if section <= 2 then
        return true
    end

    return not self:hasOppositeEntry()
end

return UnderpassEntry