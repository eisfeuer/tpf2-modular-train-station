local NatBomb = {}

local function reverse_table(table)
    local result = {}
    for i=1, math.floor(#table / 2) do
        result[i], result[#table - i + 1] = table[#table - i + 1], table[i]
    end
    if #table % 2 == 1 then
        local mid = math.ceil(#table / 2)
        result[mid] = table[mid] 
    end
    return result
end

-----------------------------------------------------------------------------
-- Makes a single integer (including negative values)
--
-- @param digits    Spaces
-- @param values    Values
--
-- @return          A single integer
-----------------------------------------------------------------------------
function NatBomb.implode(digits, values)
    if #values == 0 then
        return nil
    end
    local result = table.remove(values, 1)
    for i, digit in ipairs(digits) do
        result = result * 2 ^ digit -- result << digit
        result = result + (values[i] or 0) % (2 ^ digit)
    end
    return result
end

-----------------------------------------------------------------------------
-- Makes values from ID
--
-- @param digits    Spaces
-- @param id        id
--
-- @return          A single integer
-----------------------------------------------------------------------------
function NatBomb.explode(digits, id)
    local result = {}
    for k, digit in pairs(reverse_table(digits)) do
        table.insert(result, id % (2 ^ digit))
        id = math.floor(id / (2 ^ digit)) -- id >> digit
    end
    table.insert(result, id)
    return reverse_table(result)
end

return NatBomb