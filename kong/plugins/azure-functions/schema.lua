-- kong-ee
-- encrypt apikey and clientid, if configured. This is available in Kong Enterprise:
-- https://docs.konghq.com/gateway/2.6.x/plan-and-deploy/security/db-encryption/
local ok, enabled = pcall(function() return kong.configuration.keyring_enabled end)
local ENCRYPTED = ok and enabled or nil
-- /kong-ee

return {
  name = "azure-functions",
  fields = {
    { config = {
        type = "record",
        fields = {
          -- connection basics
          { timeout       = { type = "number",  default  = 600000}, },
          { keepalive     = { type = "number",  default  = 60000 }, },
          { https         = { type = "boolean", default  = true  }, },
          { https_verify  = { type = "boolean", default  = false }, },
          -- authorization
          { apikey        = { type = "string", encrypted = ENCRYPTED }, },
          { clientid      = { type = "string", encrypted = ENCRYPTED }, },
          -- target/location
          { appname       = { type = "string",  required = true  }, },
          { hostdomain    = { type = "string",  required = true, default = "azurewebsites.net" }, },
          { routeprefix   = { type = "string",  default = "api"  }, },
          { functionname  = { type = "string",  required = true  }, },
        },
    }, },
  },
}
