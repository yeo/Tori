local _M = {}

local responses = require "kong.tools.responses"
local json = require "kong.plugins.tori.json"
local google_api = require "kong.plugins.tori.google"
local https = require "ssl.https"
local ltn12 = require "ltn12"
local aes = require "resty.aes"
local str = require "resty.string"

local req_get_headers = ngx.req.get_headers
local req_get_args = ngx.req.get_uri_args

local function build_urls(conf)
  -- TODO: Improve by checking params for redirect_uri
  return "https://accounts.google.com/o/oauth2/v2/auth?client_id=" .. conf.client_id ..
         "&redirect_uri=" .. ngx.escape_uri(conf.redirect_uri) .. "&scope=https://www.googleapis.com/auth/userinfo.email" ..
         "&response_type=code"
end

-- TODO: May need to rewrite this with C binding for performance reason
local function hex_to_binary(hex)
  return pcall(function ()
                return hex:gsub('..', function(hexval)
                    return string.char(tonumber(hexval, 16))
                end)
              end)
end

local function request_has_valid_cookie(conf, aes_128_cbc_md5)
  local err, email = hex_to_binary(ngx.var["cookie_tori_auth"])

  if err == false or (not email) then
    return false
  end

  email = aes_128_cbc_md5:decrypt(email)
  return (email and email:ends(conf.email_domain))
end

function string.ends(String,End)
  return End =='' or string.sub(String, -string.len(End)) == End
end

local function get_cookies()
  local cookies = ngx.header["Set-Cookie"] or {}
  if type(cookies) == "string" then
    cookies = {cookies}
  end

  return cookies
end

local function add_cookie(cookie)
  local cookies = get_cookies()
  table.insert(cookies, cookie)
  ngx.header['Set-Cookie'] = cookies
end

-- Document about google oatuh2
-- https://developers.google.com/identity/protocols/OAuth2WebServer
local function exchange_code_email(conf, aes_128_cbc_md5)
  local response_json = google_api.token(req_get_args()["code"], conf.client_id, conf.client_secret, conf.redirect_uri)

  if response_json and response_json["access_token"] then
    local client = google_api:new(response_json["access_token"])
    local userinfo = client:userinfo()

    if conf.email_domain and userinfo["hd"] == conf.email_domain then
      local expires = 3600 * 24 * 30  -- 30 day
      add_cookie("tori_auth=" ..
                  str.to_hex(aes_128_cbc_md5:encrypt(userinfo["email"])) ..
                  "; HttpOnly; Expires=" ..
                  ngx.cookie_time(ngx.time() + expires))

      return true
    end
  end

  return false
end


function _M.execute(conf)
  local aes_128_cbc_md5 = aes:new(conf.aes_secret)

  if request_has_valid_cookie(conf, aes_128_cbc_md5) then
    return
  end

  -- no cookie, no api key, trigger oauth2 flow
  if not req_get_args()["code"] then
    return ngx.redirect(build_urls(conf))
  end

  -- trigger email exchange if we pass code over
  if exchange_code_email(conf, aes_128_cbc_md5) then
    -- This is a valid request
    return
  end

  return responses.send_HTTP_UNAUTHORIZED("Invalid code or email")
end

return _M
