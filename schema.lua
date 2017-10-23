-- schema.lua
return {
  no_consumer = true,
  fields = {
    -- only google for now
    provider = {type = "string", required = true },

    -- oauth2 credential
    client_id = {type = "string", required = true },
    client_secret = {type = "string", required = true },
    -- oauth2 redirect uri
    redirect_uri = {type = "string", required = true },

    -- api token to by pass the request
    token = {type = "string", required = true },
    -- aes secret key which is used to encrypt data
    aes_secret = {type = "string", required = true },

    -- valid domain which we allow access
    email_domain = {type = "string", required = true },
  }
}
