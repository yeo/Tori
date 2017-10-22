local _M = {}

local responses = require "kong.tools.responses"

local aes = require "resty.aes"
local str = require "resty.string"
local aes_128_cbc_md5 = aes:new("AKeyForAES")
local encrypted = aes_128_cbc_md5:encrypt("Secret message!")

-- Document about google oatuh2
-- https://developers.google.com/identity/protocols/OAuth2WebServer

-- Check to see if we have the cookie, parse the cookie get email to see if the
-- email is whitelisted. If no, return forbiddne
-- If no cookie, return redirect thing
function _M.execute(conf)
  local encrypted = aes_128_cbc_md5:encrypt("Secret message!")

  e =  str.to_hex(encrypted)
  d = aes_128_cbc_md5:decrypt(encrypted)

  responses.send_HTTP_OK("<a href='#'>Login with Google</a>" .. e .. "<br>" .. d, {ContentType = "text/html; charset=utf-8"})
end

return _M
