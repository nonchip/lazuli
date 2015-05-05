lapisconfig=require "lapis.config"
import config from lapisconfig
import slugify from require "lapis.util"

config "development", ->
  set "envmode","development"
config {"test","production"}, ->
  set "envmode","production"

config {"development","test","production"},->
  set "appname", "please set the appname in config.moon"
  set "env_lua_path", (os.getenv "LUA_PATH")\gsub "%;", "\\;"
  set "env_lua_cpath", (os.getenv "LUA_CPATH")\gsub "%;", "\\;"
  set "env_moon_path", (os.getenv "MOON_PATH")\gsub "%;", "\\;"
  postgres ->
    backend "pgmoon"

config {"development","test"}, ->
  postgres ->
    database "please set the database in config.moon"
    password "please set the password in config.moon"
    host "127.0.0.1:5432"
    user "postgres"
  port 8080
  enable_console true
  enable_web_migration true
  page_cache_size "1m"
  code_cache "off"
  run_daemon "off"
  session_name "please set the session name in config.moon"
  secret "please set the secret in config.moon"
  measure_performance true

config "production", ->
  postgres ->
    database "please set the database in config.moon"
    password "please set the password in config.moon"
    host "127.0.0.1:5432"
    user "postgres"
  port 8081
  enable_console false
  enable_web_migration false
  page_cache_size "30m"
  code_cache "on"
  num_workers 4
  run_daemon "on"
  session_name "please set the session name in config.moon"
  secret "please set the secret in config.moon"
  measure_performance false

return lapisconfig