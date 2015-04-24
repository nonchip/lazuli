config = require "lapis.config"
import slugify from require "lapis.utils"
import hmac_sha1 from require "lapis.util.encoding"

appname="<EDIT THIS>"
dbname=slugify appname
secretkey=hmac_sha1 "lazuli",appname

config "development", ->
  postgres ->
    backend "pgmoon"
    password "<EDIT THIS>"
    database dbname.."_dev"
  port 8080
  code_cache "off"
  daemon "off"
  session_name sessionname.."_dev"
  secret secretkey.."_dev"

config "production", ->
  postgres ->
    backend "pgmoon"
    password "<EDIT THIS>"
    database dbname
  port 8081 -- EDIT THIS
  code_cache "on"
  num_workers 4
  daemon "on"
  session_name sessionname
  secret secretkey
