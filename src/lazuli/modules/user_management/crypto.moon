import hmac_sha1, encode_base64 from require "lapis.util.encoding"
config = (require "lapis.config").get!

hash_password=(username,password)->
  encode_base64 hmac_sha1 password..config.secret, username..password

verify_password=(username,password,hash)->
  hash == hash_password username, password

{:hash_password, :verify_password}
