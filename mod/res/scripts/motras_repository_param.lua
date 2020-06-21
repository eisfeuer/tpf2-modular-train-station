local RepositoryParam = {}

function RepositoryParam:new(o)
    if not o.key then
        error('key attribute is required')
    end

    o = o or {}

    o.paramCollection = {}

    setmetatable(o, self)
    self.__index = self
    return o    
end

function RepositoryParam:getType()
    return self.type or 'BUTTON'
end

function RepositoryParam:getName()
    return self.name or _(self.key)
end

function RepositoryParam:getDefaultIndex()
    return self.defaultIndex or 0
end

function RepositoryParam:addRepositoryItem(value, item)
    table.insert(self.paramCollection, {item = item, value = value})
    self.years = nil
    self.valueCollection = nil
end

function RepositoryParam:insertYear(year)
    if year > 0 then
        for i, currentYear in ipairs(self.years) do
            if currentYear == year then
                return
            end

            if currentYear > year then
                table.insert(self.years, i, year)
                return
            end
        end

        table.insert(self.years, year)
    end
end

function RepositoryParam:getYears()
    if self.years then
        return self.years
    end

    self.years = {}
    for i, param in pairs(self.paramCollection) do
        self:insertYear(param.item.yearFrom)
        self:insertYear(param.item.yearTo)
    end

    return self.years
end

function RepositoryParam:getValues(year)
    if #self.paramCollection < 1 then
        return {'station/rail/modules/motras_track_train_normal.module'}
    end

    if not self.valueCollection then
        self:addToParams({})
    end

    for i, value in ipairs(self.valueCollection) do
        if (value.yearFrom == 0 or value.yearFrom <= year) and (value.yearTo == 0 or value.yearTo > year) then
            return value.values
        end     
    end

    return {}
end

function RepositoryParam:isInEra(item, yearFrom, yearTo)
    if yearFrom ~= 0 and item.yearTo ~= 0 and item.yearTo <= yearFrom then
        return false
    end

    if yearTo ~= 0 and item.yearFrom ~= 0 and item.yearFrom >= yearTo then
        return false
    end

    return true
end

function RepositoryParam:createParam(yearFrom, yearTo)
    local values = {}
    local valueCollectionItem = {
        yearFrom = yearFrom,
        yearTo = yearTo,
        values = {}
    }

    for i, param in ipairs(self.paramCollection) do
        if self:isInEra(param.item, yearFrom, yearTo) then
            table.insert(values, param.item.name)
            table.insert(valueCollectionItem.values, param.value)
        end
    end

    table.insert(self.valueCollection, valueCollectionItem)

    return {
        yearFrom = yearFrom,
        yearTo = yearTo,
        key = self.key,
        name = self:getName(),
        uiType =self:getType(),
        values = values,
        defaultIndex = self:getDefaultIndex(),
    }
end

function RepositoryParam:addToParams(params)
    if #self.paramCollection < 1 then
        return {}
    end

    table.sort(self.paramCollection, function (a, b)
        return a.item.yearFrom <= b.item.yearFrom
    end)

    self.valueCollection = {}
    local years = self:getYears()

    table.insert(params, self:createParam(0, years[1]))
    for i, year in ipairs(years) do
        table.insert(params, self:createParam(year, years[i + 1] or 0))
    end
end

return RepositoryParam