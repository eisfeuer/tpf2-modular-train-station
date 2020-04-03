local t = require('motras_types')
local Grid = require('motras_grid')
local Slot = require('motras_slot')

local TrackSlotPlacement = {}

function TrackSlotPlacement:new(o)
    o = o or {}
    setmetatable(o, self)
    self.__index = self
    return o    
end

function TrackSlotPlacement:isPassingPlacementRule()
    if self.grid:isEmpty() then
        return self.gridX == 0 and self.gridY == 0
    end

    if self.grid:has(self.gridX, self.gridY) then
        return self.grid:get(self.gridX, self.gridY):isTrack()
    end

    return (Grid.isInBounds(self.gridX + 1, self.gridY) and self.grid:has(self.gridX + 1, self.gridY))
      or (Grid.isInBounds(self.gridX - 1, self.gridY) and self.grid:has(self.gridX - 1, self.gridY))
      or (Grid.isInBounds(self.gridX, self.gridY + 1) and self.grid:has(self.gridX, self.gridY + 1))
      or (Grid.isInBounds(self.gridX, self.gridY - 1) and self.grid:has(self.gridX, self.gridY - 1))
end

function TrackSlotPlacement:getSlot()
    return {
        id = Slot.makeId({type = t.TRACK, gridX = self.gridX, gridY = self.gridY}),
        type = 'motras_track',
        transf = {
            1, 0, 0, 0,
            0, 1, 0, 0,
            0, 0, 1, 0,
            self.gridX * self.grid:getHorizontalDistance(), self.gridY * self.grid:getVerticalDistance(), 0, 1,
        },
        spacing = Slot.getGridElementSpacing(self.grid)
    }
end

return TrackSlotPlacement