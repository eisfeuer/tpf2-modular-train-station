local Slot = require('motras_slot')
local t = require('motras_types')

local Blueprint = {}

function Blueprint:new(o)
    o = o or {}
    setmetatable(o, self)
    self.__index = self
    return o
end

local function getPlatformModuleCount(platformCount, platformWidth, preferIslandPlatforms)
    local evenPlatformCount = platformCount % 2 == 0
    if preferIslandPlatforms then
        local islandPlatformsModules = math.floor(platformCount / 2) * platformWidth
        return evenPlatformCount and islandPlatformsModules or (islandPlatformsModules + 1)
    end
    local islandPlatformsModules = math.floor((platformCount - 1) / 2) * platformWidth
    return evenPlatformCount and (islandPlatformsModules + 2) or (islandPlatformsModules + 1)
end

local function isPlatform(index, platformWidth, preferIsland, evenPlatformCount)
    local offset = (preferIsland and evenPlatformCount) and 1 or -1
    return (index + offset) % (platformWidth + 2) > 1
end

local function addSegmentRowToTemplate(template, segmentType, segmentModule, segmentCount, yPos)
    local isEven = segmentCount % 2 == 0

    local from = isEven and -segmentCount / 2 + 1 or -math.floor(segmentCount / 2)
    local to = math.floor(segmentCount / 2)

    for i = from, to do
        local slotId = Slot.makeId({type = segmentType, gridX = i, gridY = yPos})
        template[slotId] = segmentModule
    end
end

function Blueprint:toTpf2Template()
    local template = {}

    if self.platformCount == 1 then
        addSegmentRowToTemplate(template, t.TRACK, self.trackModule, self.platformSegmentCount, 0)
        addSegmentRowToTemplate(template, t.PLATFORM, self.platformModule, self.platformSegmentCount, 1)
        return template
    end

    local trackModuleCount = self.platformCount
    local platformModuleCount = getPlatformModuleCount(self.platformCount, self.platformWidth, self.preferIslandPlatforms)

    local startY = -math.floor((trackModuleCount + platformModuleCount) / 2)

    for i = 0, trackModuleCount + platformModuleCount - 1 do
        local moduleIsPlatform = isPlatform(i, self.platformWidth, self.preferIslandPlatforms, self.platformCount % 2 == 0)
        addSegmentRowToTemplate(
            template,
            moduleIsPlatform and t.PLATFORM or t.TRACK,
            moduleIsPlatform and self.platformModule or self.trackModule,
            self.platformSegmentCount,
            startY + i
        )
    end

    return template
end

return Blueprint