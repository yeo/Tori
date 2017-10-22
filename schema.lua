-- schema.lua
return {
  no_consumer = true,
  fields = {
    client_type = {type = "string", required = true },
    client_id = {type = "string", required = true },
    client_secret = {type = "string", required = true },
    redirect_uri = {type = "string", required = true },
  }
}
