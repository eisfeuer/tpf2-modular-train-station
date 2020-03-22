local NatBomb = require('natbomb')
local t = require('motras_types')

local DIGIT_SPACES = {7, 7, 6, 4}

local Slot = {}

local function toSignedId(unsigned_id)
    if unsigned_id then
        return unsigned_id - 64
    end
    return 0
end

function Slot:new (o)
    local ids = NatBomb.explode(DIGIT_SPACES, o.id or 0)

    o = o or {}
    o.type = ids[1] or t.UNKNOWN
    o.gridType = math.floor(o.type / 64)
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

return Slot