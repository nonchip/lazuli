lapisconfig=require "lapis.config"
import config from lapisconfig

config "development", ->
  set "envmode","development"
config {"test","production"}, ->
  set "envmode","production"

config {"development","test","production"},->
  set "appname", "please set the appname in config.moon"
  session_name "please set the session name in config.moon"
  secret "please set the secret in config.moon"
  set "env_lua_path", (os.getenv "LUA_PATH")\gsub "%;", "\\;"
  set "env_lua_cpath", (os.getenv "LUA_CPATH")\gsub "%;", "\\;"
  set "env_moon_path", (os.getenv "MOON_PATH")\gsub "%;", "\\;"
  modules {}
  postgres ->
    database "please set the database in config.moon"
    password "please set the password in config.moon"
    host "127.0.0.1"
    port "5432"
    user "postgres"
    backend "pgmoon"

config {"development","test"}, ->
  port 8080
  enable_console true
  enable_web_migration true
  page_cache_size "1m"
  num_workers 1
  code_cache "off"
  run_daemon "off"
  measure_performance true

config "production", ->
  port 8081
  enable_console false
  enable_web_migration false
  page_cache_size "30m"
  num_workers 4
  code_cache "on"
  run_daemon "on"
  measure_performance false

return lapisconfig