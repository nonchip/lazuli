import config from require "lazuli.config"


config {"development","test","production"},->
  set "appname", "<EDIT THIS>"

config {"development","test"}, ->
  postgres ->
    database "<EDIT THIS>"
    password "<EDIT THIS>"
    backend "pgmoon" -- see https://github.com/leafo/lapis/issues/283
  session_name "<EDIT THIS>"
  secret "<EDIT THIS>"

config "production", ->
  postgres ->
    database "<EDIT THIS>"
    password "<EDIT THIS>"
    backend "pgmoon" -- see https://github.com/leafo/lapis/issues/283
  port 8081 -- EDIT THIS
  session_name "<EDIT THIS>"
  secret "<EDIT THIS>"
