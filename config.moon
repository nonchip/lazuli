import config from require "lapis.config"
import slugify from require "lapis.util"

appname="<EDIT THIS>"
dbname=slugify appname
sessionname=slugify appname
secretkey="<EDIT THIS>"..slugify appname

config "development", ->
  set "envmode","development"
config {"test","production"}, ->
  set "envmode","production"

config {"development","test","production"},->
  set "appname", appname
  set "env_lua_path", (os.getenv "LUA_PATH")\gsub "%;", "\\;"
  set "env_moon_path", (os.getenv "MOON_PATH")\gsub "%;", "\\;"
  postgres ->
    backend "pgmoon"

config {"development","test"}, ->
  postgres ->
    database dbname.."_dev"
    password "<EDIT THIS>"
    host "127.0.0.1:5432"
    user "postgres"
  port 8080
  enable_console true
  page_cache_size "1m"
  code_cache "off"
  run_daemon "off"
  session_name sessionname.."_dev"
  secret secretkey.."_dev"
  measure_performance true

config "production", ->
  postgres ->
    database dbname
    password "<EDIT THIS>"
    host "127.0.0.1:5432"
    user "postgres"
  port 8081 -- EDIT THIS
  enable_console false
  page_cache_size "30m"
  code_cache "on"
  num_workers 4
  run_daemon "on"
  session_name sessionname
  secret secretkey
  measure_performance false
