local typedefs = require "kong.db.schema.typedefs"

local colon_string_array = {
    type = "array",
    default = {},
    required = true,
    elements = {type = "string", match = "^[^:]+:.*$"}
}

local colon_string_record = {
    type = "record",
    fields = {
        {list = colon_string_array}
    }
}

return {
    name = "multi-header-based-route",
    fields = {
        {consumer = typedefs.no_consumer},
        {protocols = typedefs.protocols_http},
        {
            config = {
                type = "record",
                fields = {
                    {headerdetails = colon_string_record},
                    {targetdetails = colon_string_record},
                    {operator = {type = "string"}},
                    {header_count = {type = "number"}},
                    {default_host = {type = "string"}}
                }
            }
        }
    }
}
