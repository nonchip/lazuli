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
  postgres ->
    backend "pgmoon"

config {"development","test"}, ->
  postgres ->
    database dbname.."_dev"
    password "<EDIT THIS>"
  port 8080
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
  port 8081 -- EDIT THIS
  page_cache_size "30m"
  code_cache "on"
  num_workers 4
  run_daemon "on"
  session_name sessionname
  secret secretkey
  measure_performance false
