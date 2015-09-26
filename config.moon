import config from require "lazuli.config"


config {"development","test","production"},->
  set "appname", "<EDIT THIS>"

config {"development","test"}, ->
  postgres ->
    database "<EDIT THIS>"
    password "<EDIT THIS>"
  session_name "<EDIT THIS>"
  secret "<EDIT THIS>"
  port 8089

config "production", ->
  postgres ->
    database "<EDIT THIS>"
    password "<EDIT THIS>"
  port 8081 -- EDIT THIS
  session_name "<EDIT THIS>"
  secret "<EDIT THIS>"
