local aes = require "resty.aes"

local Vault = { secret =  ""}

function Vault:new(secret)
  self.secret = secret

  self.aes_128_cbc_md5 = aes:new(self.secret)
  return self
end

function Vault:sign(data)
  local expire = ngx.time() + (3600 * 24 * 7) -- 7 days

  local payload = expire .. ";" .. data
  local encrypted = str.to_hex(self.aes_128_cbc_md5:encrypt(data))

  return encrypted
end

function Vault:decrypt(data)
  local payload = self.aes_128_cbc_md5:decrypt(email)

  local parts = string.gmatch(example, ";+")

end

return Vault
