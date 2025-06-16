--VibeLib is real 
SLOP = SLOP or {}

function SLOP:getValue(t, ...)
    local keys = {...}
    local cur = t
    for _, key in ipairs(keys) do
        if type(cur) ~= "table" then return {0,0,0,0} end
        cur = cur[key]
        if cur == nil then return {0,0,0,0} end
    end

    if type(cur) == "number" then
        return {cur, 0, 0, 0}
    elseif type(cur) == "table" then
        if #cur == 3 then
            return {cur[1], cur[2], cur[3], 0}
        elseif #cur == 4 then
            return cur
        end
    end

    return {0,0,0,0}
end