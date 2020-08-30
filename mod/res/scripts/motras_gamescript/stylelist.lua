local Stylelist = {}

function Stylelist:new(o)
    o = o or {}
    o.stylelist = o.stylelist or {}

    setmetatable(o, self)
    self.__index = self
    return o
end

function Stylelist:findStyle(styleName)
    for _, style in ipairs(self.stylelist) do
        if styleName == style.metadata.name then
            return style
        end
    end

    local style = {
        metadata = {
            name = styleName
        }
    }
    table.insert(self.stylelist, style)

    return style
end

function Stylelist:collectFromModules()
    if not api then
        error('UG Api not found')
    end

    for _, moduleFile in pairs(api.res.moduleRep.getAll()) do
        local conModule = api.res.moduleRep.get(api.res.moduleRep.find(moduleFile))
        if conModule.metadata and conModule.metadata.motras_style_groups and conModule.metadata.motras_style_type then
            for _, styleGroup in pairs(conModule.metadata.motras_style_groups) do
                local style = self:findStyle(styleGroup)
                style[conModule.metadata.motras_style_type] = moduleFile
            end
        end
    end
end

function Stylelist:get()
    return self.stylelist
end

function Stylelist:getNames()
    local names = {}

    for _, value in ipairs(self:get()) do
        table.insert(names, value.metadata.name)
    end

    return names
end

return Stylelist