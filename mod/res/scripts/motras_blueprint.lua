local Slot = require('motras_slot')
local t = require('motras_types')
local AssetBlueprint = require('motras_asset_blueprint')

local Blueprint = {}

function Blueprint:new(o)
    o = o or {}
    o.tpf2Template = o.tpf2Template or {}
    o.platformDecorationFunc = function () end
    o.trackDecorationFunc = function () end
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
    return (index + offset) % (platformWidth + 2) > 1, (index + offset) % (platformWidth + 2) >= 2
end

function Blueprint:addModuleToTemplate(slotId, moduleName)
    self.tpf2Template[slotId] = moduleName
    return self
end

function Blueprint:addRowOfModulesToTemplate(slotType, moduleName, moduleCount, gridY, isPlatform, hasIslandPlatformSlots, hasSidePlatformTop, hasSidePlatformBottom)
    local isEven = moduleCount % 2 == 0

    local from = isEven and -moduleCount / 2 + 1 or -math.floor(moduleCount / 2)
    local to = math.floor(moduleCount / 2)

    local decorationFunc = isPlatform and self.platformDecorationFunc or self.trackDecorationFunc

    for i = from, to do
        local slotId = Slot.makeId({type = slotType, gridX = i, gridY = gridY})
        self:addModuleToTemplate(slotId, moduleName)
        if decorationFunc then
            decorationFunc(AssetBlueprint:new{
                blueprint = self,
                gridX = i,
                gridY = gridY,
                sidePlatformTop = isPlatform and hasSidePlatformTop,
                sidePlatformBottom = isPlatform and hasSidePlatformBottom,
                islandPlatformSlots = isPlatform and hasIslandPlatformSlots == true
            })
        end
    end
end

function Blueprint:validateOptions(options)
    if not options.trackModule then
        error('parameter trackModule is required')
    end

    if not options.platformModule then
        error('parameter platformModule is required')
    end

    if not options.platformSegmentCount then
        error('parameter platformSegmentCount is required')
    end

    if not options.platformCount then
        error('parameter platformCount is required')
    end
end

function Blueprint:createStation(options)
    self:validateOptions(options)
    local platformWidth = options.platformWidth or 1
    local preferIslandPlatforms = options.preferIslandPlatforms == true

    if options.platformCount == 1 then
        self:addRowOfModulesToTemplate(t.TRACK, options.trackModule, options.platformSegmentCount, 0, false, false, false, false)
        self:addRowOfModulesToTemplate(t.PLATFORM, options.platformModule, options.platformSegmentCount, 1, true, false, true, false)
        return self
    end

    local trackModuleCount = options.platformCount
    local platformModuleCount = getPlatformModuleCount(options.platformCount, platformWidth, preferIslandPlatforms)

    local startY = -math.floor((trackModuleCount + platformModuleCount) / 2)

    for i = 0, trackModuleCount + platformModuleCount - 1 do
        local moduleIsPlatform, hasIslandPlatformSlots = isPlatform(i, platformWidth, preferIslandPlatforms, options.platformCount % 2 == 0)
        if moduleIsPlatform then
            self:addRowOfModulesToTemplate(
                t.PLATFORM,
                options.platformModule,options.platformSegmentCount,
                startY + i, true,
                hasIslandPlatformSlots,
                i == 0,
                i == trackModuleCount + platformModuleCount - 1
            )
        else
            self:addRowOfModulesToTemplate(t.TRACK, options.trackModule, options.platformSegmentCount, startY + i, false, false, false, false)
        end   
    end

    return self
end

function Blueprint:decorateEachPlatform(platformDecorationFunc)
    self.platformDecorationFunc = platformDecorationFunc
    return self
end

function Blueprint:decorateEachTrack(trackDecorationFunc)
    self.trackDecorationFunc = trackDecorationFunc
    return self
end

function Blueprint:toTpf2Template()
    return self.tpf2Template
end

return Blueprint