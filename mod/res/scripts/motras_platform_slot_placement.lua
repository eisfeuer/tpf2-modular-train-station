local t = require('motras_types')
local Grid = require('motras_grid')
local Slot = require('motras_slot')

local PlatformSlotPlacement = {}

function PlatformSlotPlacement:new(o)
    o = o or {}
    setmetatable(o, self)
    self.__index = self
    return o    
end

function PlatformSlotPlacement:isPassingPlacementRule()
    if self.grid:isEmpty() then
        return self.gridX == 0 and self.gridY == 0
    end

    if self.grid:has(self.gridX, self.gridY) then
        return self.grid:get(self.gridX, self.gridY):isPlatform()
    end

    return (Grid.isInBounds(self.gridX + 1, self.gridY) and self.grid:has(self.gridX + 1, self.gridY))
      or (Grid.isInBounds(self.gridX - 1, self.gridY) and self.grid:has(self.gridX - 1, self.gridY))
      or (Grid.isInBounds(self.gridX, self.gridY + 1) and self.grid:has(self.gridX, self.gridY + 1))
      or (Grid.isInBounds(self.gridX, self.gridY - 1) and self.grid:has(self.gridX, self.gridY - 1))
end

function PlatformSlotPlacement:getSlot()
    return {
        id = Slot.makeId({type = t.PLATFORM, gridX = self.gridX, gridY = self.gridY}),
        type = self.grid:getModulePrefix() .. '_platform',
        transf = {
            1, 0, 0, 0,
            0, 1, 0, 0,
            0, 0, 1, 0,
            self.gridX * self.grid:getHorizontalDistance(), self.gridY * self.grid:getVerticalDistance(), self.grid:getBaseHeight(), 1,
        },
        spacing = Slot.getGridElementSpacing(self.grid)
    }
end

return PlatformSlotPlacement