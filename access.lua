local _M = {}

local match = string.match
local kong = kong
local type = type

local noop = function()
end

-- Iterate through the array list
local function iter(config_array)
    if type(config_array) ~= "table" then
        return noop
    end

    return function(config_array, i)
        i = i + 1

        local header_to_test = config_array[i]
        if header_to_test == nil then -- n + 1
            return nil
        end

        local header_to_test_name, header_to_test_value = match(header_to_test, "^([^:]+):*(.-)$")
        if header_to_test_value == "" then
            header_to_test_value = nil
        end

        return i, header_to_test_name, header_to_test_value
    end, config_array, 0
end

-- Split the string based on the delimiter
local function Split(s, delimiter)
    local result = {}
    for match in (s .. delimiter):gmatch("(.-)" .. delimiter) do
        table.insert(result, match)
    end
    return result
end

-- Plugin Implementation
function _M.execute(conf)
    local headers = kong.request.get_headers()
    local default_host = conf.default_host
    local header_count = conf.header_count
    local operator = conf.operator
    local count = 0
    local targetValue = nil
    local targetFound = false

    for _, header_name, header_value in iter(conf.headerdetails.list) do
        local splitHeader = Split(header_name, "|")
        if headers[splitHeader[1]] == splitHeader[2] then
            count = count + 1
            targetValue = header_value
        end

        if (count == header_count and operator == "AND") or (count > 0 and operator == "OR") then
            break
        end
    end

    for _, header_name, header_value in iter(conf.targetdetails.list) do
        local splitTarget = Split(header_value, "|")
        if targetValue == header_name and count == header_count and operator == "AND" then
            ngx.req.set_header("Host", splitTarget[1])
            kong.service.set_target(splitTarget[1], tonumber(splitTarget[2]))
            targetFound = true
            break
        elseif targetValue == header_name and count > 0 and count <= header_count and operator == "OR" then
            ngx.req.set_header("Host", splitTarget[1])
            kong.service.set_target(splitTarget[1], tonumber(splitTarget[2]))
            targetFound = true
            break
        end
    end

    if targetFound == false then
        ngx.req.set_header("Host", default_host)
        kong.service.set_target(default_host, 443)
    end
end

return _M
