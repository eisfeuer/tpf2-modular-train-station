local Theme = {}

function Theme:new(o)
    o = o or {}
    o.components = o.components or {}
    o.defaultComponents = o.defaultComponents or {}

    setmetatable(o, self)
    self.__index = self
    return o
end

function Theme:hasComponent(component, considerDefaultComponents)
    if self.components[component] then
        return true
    end

    if considerDefaultComponents and self.defaultComponents[component] then
        return true
    end

    return false
end

function Theme:getModuleForComponent(component)
    return self.components[component] or self.defaultComponents[component]
end

function Theme:getModuleForComponentOrAlternative(component, alternative, considerDefaultComponents)
    if self:hasComponent(component, considerDefaultComponents) then
        return self:getModuleForComponent(component)
    end

    return self:getModuleForComponent(alternative)
end

return Theme