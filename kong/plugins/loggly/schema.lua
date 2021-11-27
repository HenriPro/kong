local typedefs = require "kong.db.schema.typedefs"

local severity = {
  type = "string",
  default = "info",
  one_of = { "debug", "info", "notice", "warning", "err", "crit", "alert", "emerg" },
}

-- kong-ee
-- encrypt key, if configured. This is available in Kong Enterprise:
-- https://docs.konghq.com/gateway/2.6.x/plan-and-deploy/security/db-encryption/
local ok, enabled = pcall(function() return kong.configuration.keyring_enabled end)
local ENCRYPTED = ok and enabled or nil
-- /kong-ee

return {
  name = "loggly",
  fields = {
    { protocols = typedefs.protocols },
    { config = {
        type = "record",
        fields = {
          { host = typedefs.host({ default = "logs-01.loggly.com" }), },
          { port = typedefs.port({ default = 514 }), },
          { key = { type = "string", required = true, encrypted = ENCRYPTED }, },
          { tags = {
              type = "set",
              default = { "kong" },
              elements = { type = "string" },
          }, },
          { log_level = severity },
          { successful_severity = severity },
          { client_errors_severity = severity },
          { server_errors_severity = severity },
          { timeout = { type = "number", default = 10000 }, },
          { custom_fields_by_lua = typedefs.lua_code },
        },
      },
    },
  },
}
