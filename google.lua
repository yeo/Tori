local https = require "ssl.https"
local json = require "kong.plugins.tori.json"
local ltn12 = require "ltn12"

local GoogleAPI = { access_token =  ""}

function GoogleAPI.token(code, client_id, client_secret, redirect_uri)
  local response_body = { }
  local payload = "code=" .. code .. "&client_id=" .. client_id ..
                   "&client_secret=" .. client_secret ..
                   "&grant_type=authorization_code&redirect_uri=" .. redirect_uri

  https.request{
    url = "https://www.googleapis.com/oauth2/v4/token",
    sink = ltn12.sink.table(response_body),
    method = 'POST',
    headers = {
      ["Content-Type"] = "application/x-www-form-urlencoded",
      ["Content-Length"] = payload:len()
    },
    source = ltn12.source.string(payload),
  }

  return json:decode(table.concat(response_body))
end

function GoogleAPI:new(token)
  self.access_token = token

  return self
end

function GoogleAPI:userinfo()
  local raw_userinfo = {}
  https.request{
    url = "https://www.googleapis.com/oauth2/v3/userinfo",
    sink = ltn12.sink.table(raw_userinfo),
    method = 'GET',
    headers = {
      ["Authorization"] = "Bearer " .. self.access_token
    },
  }

  return json:decode(table.concat(raw_userinfo))
end

return GoogleAPI
