local function optional (tableOrNil)
    return tableOrNil or {}
end

local Theme = {}

function Theme:new(o)
    o = o or {}
    setmetatable(o, self)
    self.__index = self
    return o
end

function Theme:isExcluded(moduleType)
    local excludes = optional(self.theme.metadata).excludes or {}
    for _, exclude in pairs(excludes) do
        if moduleType == exclude then
            return true
        end
    end

    return false
end

function Theme:hasSelf(moduleType)
    if self:isExcluded(moduleType) then
        return false
    end

    if optional(self.theme[moduleType]).moduleName then
        return true
    end

    return false
end

function Theme:has(moduleType)
    if not self:hasSelf(moduleType) then
        return false
    end

    if optional(self.defaultTheme[moduleType]).moduleName then
        return true
    end

    return false
end

function Theme:get(moduleType)
    if self:isExcluded(moduleType) then
        return nil
    end

    return optional(self.theme[moduleType]).moduleName or optional(self.defaultTheme[moduleType]).moduleName
end

function Theme:getWithAlternative(moduleType, alternativeModuleType)
    return self:hasSelf(moduleType) and self:get(moduleType) or self:get(alternativeModuleType)
end

return Theme